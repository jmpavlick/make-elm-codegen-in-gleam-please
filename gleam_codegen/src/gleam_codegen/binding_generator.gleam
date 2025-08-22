// Binding generator for gleam-codegen
// Generates helper bindings for existing Gleam packages
// Similar to how elm-codegen generates bindings for Elm packages

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import gleam_codegen/internal/compiler as c
import gleam_codegen/package_parser as parser

// ===== BINDING GENERATION =====

/// Generate bindings for a parsed Gleam module
pub fn generate_module_bindings(module: parser.GleamModule) -> c.Declaration {
  let module_name = ["Gen"] |> list.append(string.split(module.name, "/"))

  // Generate the main module with helper functions
  let public_functions = parser.get_public_functions(module)

  // Create function bindings
  let function_bindings = list.map(public_functions, generate_function_binding)

  // Create call_ record for dynamic calls  
  let call_record = generate_call_record(public_functions, module.name)

  // Create values_ record for value references
  let values_record = generate_values_record(public_functions, module.name)

  // Combine all declarations
  c.Group([
    c.Comment("Generated bindings for " <> module.name),
    c.Group(function_bindings),
    call_record,
    values_record,
  ])
}

/// Generate a binding for a single function
fn generate_function_binding(func: parser.GleamFunction) -> c.Declaration {
  case func.args {
    // No arguments - create a simple value
    [] -> generate_simple_value_binding(func)

    // Has arguments - create a function binding
    args -> generate_function_call_binding(func, args)
  }
}

/// Generate a binding for a function with no arguments
fn generate_simple_value_binding(func: parser.GleamFunction) -> c.Declaration {
  let value_expr =
    c.simple_expression(
      c.Variable(func.name),
      string_to_gleam_type(func.return_type),
    )

  c.Declaration(
    c.DeclarationDetails(
      name: func.name,
      exposed: c.Exposed,
      imports: [],
      docs: func.documentation,
      to_body: fn(_index) {
        c.DeclarationBody(
          declaration: c.ConstDecl(
            name: func.name,
            type_: Some(string_to_gleam_type(func.return_type)),
            value: c.Variable(func.name),
          ),
          additional_imports: [],
          warning: None,
        )
      },
    ),
  )
}

/// Generate a binding for a function with arguments
fn generate_function_call_binding(
  func: parser.GleamFunction,
  args: List(#(String, String)),
) -> c.Declaration {
  // Create a function that takes expressions and generates a function call
  c.Declaration(
    c.DeclarationDetails(
      name: func.name,
      exposed: c.Exposed,
      imports: [],
      docs: func.documentation,
      to_body: fn(_index) {
        c.DeclarationBody(
          declaration: c.FunctionDecl(
            name: func.name,
            args: list.map(args, fn(arg) {
              #(arg.0, Some(c.CustomType([], "Expression", [])))
            }),
            return_type: Some(c.CustomType([], "Expression", [])),
            body: generate_function_call_body(func.name, args),
          ),
          additional_imports: [],
          warning: None,
        )
      },
    ),
  )
}

/// Generate the body of a function binding that creates a function call
fn generate_function_call_body(
  func_name: String,
  args: List(#(String, String)),
) -> c.GleamExpression {
  let arg_vars = list.map(args, fn(arg) { c.Variable(arg.0) })
  c.FunctionCall(c.Variable(func_name), arg_vars)
}

/// Generate a call_ record for dynamic function calls
fn generate_call_record(
  functions: List(parser.GleamFunction),
  module_name: String,
) -> c.Declaration {
  let call_fields =
    list.map(functions, fn(func) {
      let field_name = func.name
      let field_value = case func.args {
        [] -> c.Variable(func.name)
        // No args, just the value
        args -> {
          // Create a function that takes expressions
          let lambda_args = list.map(args, fn(arg) { c.VariablePattern(arg.0) })
          let call_expr =
            c.FunctionCall(
              c.Variable(func.name),
              list.map(args, fn(arg) { c.Variable(arg.0) }),
            )
          c.Lambda(lambda_args, call_expr)
        }
      }
      #(field_name, field_value)
    })

  c.Declaration(
    c.DeclarationDetails(
      name: "call_",
      exposed: c.Exposed,
      imports: [],
      docs: Some("Dynamic function calls for " <> module_name),
      to_body: fn(_index) {
        c.DeclarationBody(
          declaration: c.ConstDecl(
            name: "call_",
            type_: None,
            value: c.Record(call_fields),
          ),
          additional_imports: [],
          warning: None,
        )
      },
    ),
  )
}

/// Generate a values_ record for value references
fn generate_values_record(
  functions: List(parser.GleamFunction),
  module_name: String,
) -> c.Declaration {
  let value_fields =
    list.map(functions, fn(func) {
      let field_name = func.name
      let field_value = c.StringLiteral(func.name)
      // String representation of the function name
      #(field_name, field_value)
    })

  c.Declaration(
    c.DeclarationDetails(
      name: "values_",
      exposed: c.Exposed,
      imports: [],
      docs: Some("Value references for " <> module_name),
      to_body: fn(_index) {
        c.DeclarationBody(
          declaration: c.ConstDecl(
            name: "values_",
            type_: None,
            value: c.Record(value_fields),
          ),
          additional_imports: [],
          warning: None,
        )
      },
    ),
  )
}

// ===== UTILITY FUNCTIONS =====

/// Convert a string type representation to a GleamType
fn string_to_gleam_type(type_str: String) -> c.GleamType {
  case string.trim(type_str) {
    "Int" -> c.IntType
    "Float" -> c.FloatType
    "String" -> c.StringType
    "Bool" -> c.BoolType
    "Nil" -> c.NilType
    "List(" <> rest -> {
      // Simple List parsing - would need more sophisticated parsing for nested types
      let inner_type = string.replace(rest, ")", "")
      c.ListType(string_to_gleam_type(inner_type))
    }
    "Result(" <> rest -> {
      // Simple Result parsing
      case string.split_once(rest, ",") {
        Ok(#(ok_type, err_part)) -> {
          let err_type = string.replace(err_part, ")", "") |> string.trim
          c.ResultType(
            string_to_gleam_type(ok_type),
            string_to_gleam_type(err_type),
          )
        }
        Error(_) -> c.CustomType([], type_str, [])
      }
    }
    other -> c.CustomType([], other, [])
    // Default to custom type
  }
}

/// Generate bindings for an entire package
pub fn generate_package_bindings(
  package_path: String,
) -> Result(List(c.Declaration), String) {
  // This would scan a package directory and generate bindings for all modules
  // For now, just return an empty list as a placeholder
  Ok([])
}

/// Generate a complete Gen module file for a parsed module
pub fn generate_gen_module_file(module: parser.GleamModule) -> String {
  let bindings = generate_module_bindings(module)
  let module_path = ["Gen"] |> list.append(string.split(module.name, "/"))

  // This would create a file with the bindings
  // let file = gc.file(module_path, [bindings])

  // This would use our to_string functionality when it's more complete
  "// Generated bindings for "
  <> module.name
  <> "\n// TODO: Implement full rendering"
}
