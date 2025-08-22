// Package parser for gleam-codegen
// Extracts function signatures and types from Gleam source files
// to generate bindings similar to elm-codegen

import gleam/string
import gleam/list
import gleam/result
import gleam/option.{type Option, None, Some}
import simplifile

// ===== TYPES =====

/// Represents a parsed Gleam function
pub type GleamFunction {
  GleamFunction(
    name: String,
    args: List(#(String, String)), // (name, type)
    return_type: String,
    is_public: Bool,
    documentation: Option(String)
  )
}

/// Represents a parsed Gleam type
pub type GleamTypeDefinition {
  GleamTypeDefinition(
    name: String,
    type_vars: List(String),
    constructors: List(GleamConstructor),
    is_public: Bool,
    documentation: Option(String)
  )
}

/// Represents a type constructor
pub type GleamConstructor {
  GleamConstructor(name: String, args: List(String))
}

/// Represents a parsed Gleam module
pub type GleamModule {
  GleamModule(
    name: String,
    functions: List(GleamFunction),
    types: List(GleamTypeDefinition),
    imports: List(String)
  )
}

// ===== PARSING FUNCTIONS =====

/// Parse a Gleam source file and extract its public interface
pub fn parse_module_from_file(file_path: String) -> Result(GleamModule, String) {
  case simplifile.read(file_path) {
    Ok(content) -> parse_module_from_string(content, extract_module_name(file_path))
    Error(_) -> Error("Could not read file: " <> file_path)
  }
}

/// Parse a Gleam source string and extract its interface
pub fn parse_module_from_string(content: String, module_name: String) -> Result(GleamModule, String) {
  let lines = string.split(content, "\n")
  
  Ok(GleamModule(
    name: module_name,
    functions: parse_functions(lines),
    types: parse_types(lines),
    imports: parse_imports(lines)
  ))
}

/// Extract module name from file path
fn extract_module_name(file_path: String) -> String {
  file_path
  |> string.split("/")
  |> list.last
  |> result.unwrap("unknown")
  |> string.replace(".gleam", "")
}

/// Parse public function definitions from source lines
fn parse_functions(lines: List(String)) -> List(GleamFunction) {
  lines
  |> list.fold(#([], None, []), fn(acc, line) {
    let #(functions, current_doc, doc_lines) = acc
    
    case string.trim(line) {
      // Documentation comment
      "///" <> doc_line -> 
        #(functions, current_doc, [string.trim(doc_line), ..doc_lines])
      
      // Public function definition
      "pub fn " <> rest -> {
        let doc = case doc_lines {
          [] -> None
          lines -> Some(string.join(list.reverse(lines), "\n"))
        }
        
        case parse_function_signature(rest) {
          Some(func) -> {
            let updated_func = GleamFunction(
              ..func,
              is_public: True,
              documentation: doc
            )
            #([updated_func, ..functions], None, [])
          }
          None -> #(functions, None, [])
        }
      }
      
      // Clear doc accumulator for non-doc, non-function lines
      _ -> case string.starts_with(string.trim(line), "///") {
        True -> acc
        False -> #(functions, current_doc, [])
      }
    }
  })
  |> fn(result) { result.0 }
  |> list.reverse
}

/// Parse a function signature from a line like "add(x: Int, y: Int) -> Int {"
fn parse_function_signature(signature_line: String) -> Option(GleamFunction) {
  // This is a simplified parser - in practice you'd want a more robust one
  case string.split_once(signature_line, "(") {
    Ok(#(name, rest)) -> {
      case string.split_once(rest, ")") {
        Ok(#(args_str, return_part)) -> {
          let args = parse_function_args(args_str)
          let return_type = parse_return_type(return_part)
          
          Some(GleamFunction(
            name: string.trim(name),
            args: args,
            return_type: return_type,
            is_public: False, // Will be set by caller
            documentation: None
          ))
        }
        Error(_) -> None
      }
    }
    Error(_) -> None
  }
}

/// Parse function arguments from string like "x: Int, y: Int"
fn parse_function_args(args_str: String) -> List(#(String, String)) {
  case string.trim(args_str) {
    "" -> []
    args -> {
             string.split(args, ",")
       |> list.map(string.trim)
       |> list.filter_map(fn(arg) {
         case string.split_once(arg, ":") {
           Ok(#(name, type_)) -> Ok(#(string.trim(name), string.trim(type_)))
           Error(_) -> Error(Nil)
         }
       })
    }
  }
}

/// Parse return type from string like " -> Int {" or " {"
fn parse_return_type(return_part: String) -> String {
  case string.split_once(return_part, "->") {
    Ok(#(_, type_part)) -> {
      type_part
      |> string.split_once(" {")
      |> result.map(fn(parts) { parts.0 })
      |> result.unwrap(type_part)
      |> string.trim
    }
    Error(_) -> "Nil" // No explicit return type means Nil
  }
}

/// Parse type definitions from source lines
fn parse_types(lines: List(String)) -> List(GleamTypeDefinition) {
  // Simplified type parsing - would need more sophisticated parsing for full support
  lines
  |> list.filter_map(fn(line) {
    let trimmed = string.trim(line)
    case string.starts_with(trimmed, "pub type ") {
      True -> {
        let type_line = string.drop_start(trimmed, 9) // Remove "pub type "
        case string.split_once(type_line, " {") {
          Ok(#(name_part, _)) -> {
            Ok(GleamTypeDefinition(
              name: string.trim(name_part),
              type_vars: [], // TODO: Parse type variables
              constructors: [], // TODO: Parse constructors
              is_public: True,
              documentation: None
            ))
          }
          Error(_) -> Error(Nil)
        }
      }
      False -> Error(Nil)
    }
  })
}

/// Parse import statements from source lines
fn parse_imports(lines: List(String)) -> List(String) {
  lines
  |> list.filter_map(fn(line) {
    let trimmed = string.trim(line)
    case string.starts_with(trimmed, "import ") {
      True -> {
        let import_line = string.drop_start(trimmed, 7) // Remove "import "
        // Extract just the module name, ignoring any aliases or exposing clauses
        case string.split_once(import_line, ".{") {
          Ok(#(module_name, _)) -> Ok(string.trim(module_name))
          Error(_) -> case string.split_once(import_line, " as ") {
            Ok(#(module_name, _)) -> Ok(string.trim(module_name))
            Error(_) -> Ok(string.trim(import_line))
          }
        }
      }
      False -> Error(Nil)
    }
  })
}

// ===== UTILITY FUNCTIONS =====

/// Get all public functions from a module
pub fn get_public_functions(module: GleamModule) -> List(GleamFunction) {
  list.filter(module.functions, fn(func) { func.is_public })
}

/// Get all public types from a module
pub fn get_public_types(module: GleamModule) -> List(GleamTypeDefinition) {
  list.filter(module.types, fn(type_def) { type_def.is_public })
}

/// Find a specific function by name
pub fn find_function(module: GleamModule, name: String) -> Option(GleamFunction) {
  case list.find(module.functions, fn(func) { func.name == name }) {
    Ok(func) -> Some(func)
    Error(_) -> None
  }
}