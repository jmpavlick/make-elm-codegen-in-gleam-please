// Code rendering module for gleam-codegen
// Maps to elm-codegen's ToString and Internal.Write modules

import gleam/float
import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/string
import gleam_codegen/internal/compiler as c

// ===== RENDERING CONTEXT =====

/// Context for expression rendering with precedence handling
pub type Context {
  Context(precedence: Int, indent: Int)
}

/// Top-level context (no precedence constraints)
pub fn top_context() -> Context {
  Context(precedence: 0, indent: 0)
}

/// Bottom context (maximum precedence)
pub fn bottom_context() -> Context {
  Context(precedence: 100, indent: 0)
}

// ===== EXPRESSION RENDERING =====

/// Convert an expression to a Gleam source code string
pub fn expression_to_string(expr: c.Expression) -> String {
  let index = c.start_index(None)
  let details = c.to_expression_details(expr, index)
  render_expression(details.expression, top_context())
}

/// Render a GleamExpression to source code
pub fn render_expression(expr: c.GleamExpression, context: Context) -> String {
  case expr {
    // Literals
    c.IntLiteral(value) -> int.to_string(value)
    c.FloatLiteral(value) -> float.to_string(value)
    c.StringLiteral(value) -> "\"" <> escape_string(value) <> "\""
    c.BoolLiteral(True) -> "True"
    c.BoolLiteral(False) -> "False"
    c.NilLiteral -> "Nil"

    // Variables and references
    c.Variable(name) -> name
    c.FieldAccess(expr, field) ->
      render_expression(expr, context) <> "." <> field

    // Function calls
    c.FunctionCall(func, args) -> {
      let func_str = render_expression(func, context)
      let args_str =
        list.map(args, fn(arg) { render_expression(arg, context) })
        |> string.join(", ")
      func_str <> "(" <> args_str <> ")"
    }

    // Binary operators
    c.BinaryOp(op, left, right) -> {
      let op_precedence = get_operator_precedence(op)
      // Need parentheses when the context has higher precedence (binds tighter)
      let needs_parens = context.precedence > op_precedence

      // Create contexts for left and right sides
      // Use a high precedence to force parentheses on lower precedence operations
      let child_context = Context(op_precedence, context.indent)

      let left_str = render_expression(left, child_context)
      let right_str = render_expression(right, child_context)
      let expr_str = left_str <> " " <> op <> " " <> right_str

      case needs_parens {
        True -> "(" <> expr_str <> ")"
        False -> expr_str
      }
    }

    // Unary operators
    c.UnaryOp(op, expr) -> {
      let expr_str = render_expression(expr, bottom_context())
      op <> expr_str
    }

    // Pipe operator (special case)
    c.Pipe(left, right) -> {
      let left_str = render_expression(left, Context(1, context.indent))
      let right_str = render_expression(right, Context(0, context.indent))
      left_str <> " |> " <> right_str
    }

    // Data structures
    c.List(items) -> {
      let items_str =
        list.map(items, fn(item) { render_expression(item, top_context()) })
        |> string.join(", ")
      "[" <> items_str <> "]"
    }

    c.Tuple(items) -> {
      let items_str =
        list.map(items, fn(item) { render_expression(item, top_context()) })
        |> string.join(", ")
      "#(" <> items_str <> ")"
    }

    c.Record(fields) -> {
      let fields_str =
        list.map(fields, fn(field) {
          let #(name, value) = field
          name <> ": " <> render_expression(value, top_context())
        })
        |> string.join(", ")
      case list.is_empty(fields) {
        True -> "{}"
        False -> "{ " <> fields_str <> " }"
      }
    }

    c.RecordUpdate(base, updates) -> {
      let base_str = render_expression(base, context)
      let updates_str =
        list.map(updates, fn(update) {
          let #(field, value) = update
          field <> ": " <> render_expression(value, top_context())
        })
        |> string.join(", ")
      case list.is_empty(updates) {
        True -> base_str
        False -> "{ " <> base_str <> " with " <> updates_str <> " }"
      }
    }

    // Control flow
    c.Case(subject, branches) -> {
      let subject_str = render_expression(subject, top_context())
      let branches_str =
        list.map(branches, fn(branch) {
          let #(pattern, expr) = branch
          let pattern_str = render_pattern(pattern)
          let expr_str = render_expression(expr, top_context())
          "  " <> pattern_str <> " -> " <> expr_str
        })
        |> string.join("\n")
      "case " <> subject_str <> " {\n" <> branches_str <> "\n}"
    }

    c.Let(bindings, body) -> {
      let bindings_str =
        list.map(bindings, fn(binding) {
          let #(pattern, expr) = binding
          let pattern_str = render_pattern(pattern)
          let expr_str = render_expression(expr, top_context())
          "  let " <> pattern_str <> " = " <> expr_str
        })
        |> string.join("\n")
      let body_str = render_expression(body, top_context())
      "{\n" <> bindings_str <> "\n  " <> body_str <> "\n}"
    }

    // Functions
    c.Lambda(args, body) -> {
      let args_str = list.map(args, render_pattern) |> string.join(", ")
      let body_str = render_expression(body, top_context())
      "fn(" <> args_str <> ") { " <> body_str <> " }"
    }
  }
}

// ===== PATTERN RENDERING =====

/// Render a pattern to source code
pub fn render_pattern(pattern: c.Pattern) -> String {
  case pattern {
    c.VariablePattern(name) -> name
    c.IntPattern(value) -> int.to_string(value)
    c.FloatPattern(value) -> float.to_string(value)
    c.StringPattern(value) -> "\"" <> escape_string(value) <> "\""
    c.BoolPattern(True) -> "True"
    c.BoolPattern(False) -> "False"
    c.NilPattern -> "Nil"
    c.DiscardPattern -> "_"

    c.ListPattern(patterns) -> {
      let patterns_str = list.map(patterns, render_pattern) |> string.join(", ")
      "[" <> patterns_str <> "]"
    }

    c.TuplePattern(patterns) -> {
      let patterns_str = list.map(patterns, render_pattern) |> string.join(", ")
      "#(" <> patterns_str <> ")"
    }

    c.ConstructorPattern(name, patterns) -> {
      case list.is_empty(patterns) {
        True -> name
        False -> {
          let patterns_str =
            list.map(patterns, render_pattern) |> string.join(", ")
          name <> "(" <> patterns_str <> ")"
        }
      }
    }

    c.AsPattern(pattern, name) -> {
      render_pattern(pattern) <> " as " <> name
    }
  }
}

// ===== DECLARATION RENDERING =====

/// Render a declaration to source code
pub fn render_declaration(decl: c.Declaration) -> String {
  case decl {
    c.Declaration(details) -> {
      // TODO: Extract the actual declaration from details
      "// TODO: Implement declaration rendering for " <> details.name
    }

    c.Comment(text) -> "// " <> text
    c.ModuleDocs(text) -> "/// " <> text
    c.Block(text) -> text

    c.Group(declarations) -> {
      list.map(declarations, render_declaration) |> string.join("\n\n")
    }
  }
}

/// Render a complete file to source code  
/// Note: This will be implemented when we integrate with the main File type
pub fn render_file_placeholder(
  module_name: List(String),
  declarations: List(c.Declaration),
) -> String {
  // Module declaration (Gleam doesn't use explicit module declarations like Elm)
  let module_comment = case list.is_empty(module_name) {
    True -> ""
    False -> "// Module: " <> string.join(module_name, ".") <> "\n\n"
  }

  // Declarations
  let declarations_str =
    list.map(declarations, render_declaration)
    |> string.join("\n\n")

  module_comment <> declarations_str
}

// ===== UTILITY FUNCTIONS =====

/// Get operator precedence for proper parenthesization
fn get_operator_precedence(op: String) -> Int {
  case op {
    "||" -> 2
    "&&" -> 3
    "==" | "!=" | "<" | ">" | "<=" | ">=" -> 4
    "<>" -> 5
    "+" | "-" -> 6
    "*" | "/" | "%" -> 7
    _ -> 10
    // Default high precedence
  }
}

/// Escape special characters in strings
fn escape_string(s: String) -> String {
  s
  |> string.replace("\\", "\\\\")
  |> string.replace("\"", "\\\"")
  |> string.replace("\n", "\\n")
  |> string.replace("\t", "\\t")
  |> string.replace("\r", "\\r")
}

// ===== TYPE RENDERING =====

/// Render a Gleam type to source code
pub fn render_type(type_: c.GleamType) -> String {
  case type_ {
    c.IntType -> "Int"
    c.FloatType -> "Float"
    c.StringType -> "String"
    c.BoolType -> "Bool"
    c.NilType -> "Nil"

    c.ListType(inner) -> "List(" <> render_type(inner) <> ")"
    c.TupleType(types) -> {
      let types_str = list.map(types, render_type) |> string.join(", ")
      "#(" <> types_str <> ")"
    }

    c.FunctionType(args, return) -> {
      let args_str = list.map(args, render_type) |> string.join(", ")
      "fn(" <> args_str <> ") -> " <> render_type(return)
    }

    c.CustomType(module, name, args) -> {
      let module_prefix = case list.is_empty(module) {
        True -> ""
        False -> string.join(module, ".") <> "."
      }
      let args_str = case list.is_empty(args) {
        True -> ""
        False -> "(" <> string.join(list.map(args, render_type), ", ") <> ")"
      }
      module_prefix <> name <> args_str
    }

    c.TypeVariable(name) -> name

    c.ResultType(ok, error) ->
      "Result(" <> render_type(ok) <> ", " <> render_type(error) <> ")"

    c.OptionType(inner) -> "Option(" <> render_type(inner) <> ")"
  }
}
