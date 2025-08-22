// Main API for gleam-codegen
// Maps to elm-codegen's Elm.elm module

import gleam_codegen/internal/compiler as c
import gleam_codegen/op
import gleam_codegen/to_string

// ===== FILE GENERATION =====

/// Represents a complete Gleam file
pub type File {
  File(
    module_name: List(String),
    declarations: List(c.Declaration),
    imports: List(c.Module),
  )
}

/// Create a basic file with module name and declarations
pub fn file(
  module_name: List(String),
  declarations: List(c.Declaration),
) -> File {
  File(module_name, declarations, [])
}

/// Convert a file to Gleam source code string
pub fn to_string(file: File) -> String {
  let File(module_name, declarations, _imports) = file
  to_string.render_file_placeholder(module_name, declarations)
}

/// Convert an expression to Gleam source code string
pub fn expression_to_string(expr: c.Expression) -> String {
  to_string.expression_to_string(expr)
}

// ===== BASIC EXPRESSIONS =====

/// Create an integer literal
pub fn int(value: Int) -> c.Expression {
  c.simple_expression(c.IntLiteral(value), c.IntType)
}

/// Create a float literal  
pub fn float(value: Float) -> c.Expression {
  c.simple_expression(c.FloatLiteral(value), c.FloatType)
}

/// Create a string literal
pub fn string(value: String) -> c.Expression {
  c.simple_expression(c.StringLiteral(value), c.StringType)
}

/// Create a boolean literal
pub fn bool(value: Bool) -> c.Expression {
  c.simple_expression(c.BoolLiteral(value), c.BoolType)
}

/// Create a nil literal
pub fn nil() -> c.Expression {
  c.simple_expression(c.NilLiteral, c.NilType)
}

/// Create a variable reference
pub fn variable(name: String) -> c.Expression {
  c.untyped_expression(c.Variable(name))
}

/// Create a list
pub fn list(_items: List(c.Expression)) -> List(c.Expression) {
  // TODO: Implement proper list creation with type inference
  []
}

/// Create a tuple
pub fn tuple(_items: List(c.Expression)) -> c.Expression {
  // TODO: Implement proper tuple creation
  c.untyped_expression(c.Tuple([]))
}

// ===== FUNCTION CALLS =====

/// Call a function with arguments
pub fn call(_function: c.Expression, _args: List(c.Expression)) -> c.Expression {
  c.untyped_expression(c.FunctionCall(c.Variable("placeholder"), []))
}

// ===== OPERATORS =====

/// Add two expressions
pub fn add(left: c.Expression, right: c.Expression) -> c.Expression {
  op.plus(left, right)
}

/// Subtract two expressions  
pub fn subtract(left: c.Expression, right: c.Expression) -> c.Expression {
  op.minus(left, right)
}

/// Multiply two expressions
pub fn multiply(left: c.Expression, right: c.Expression) -> c.Expression {
  op.multiply(left, right)
}

/// Divide two expressions
pub fn divide(left: c.Expression, right: c.Expression) -> c.Expression {
  op.divide(left, right)
}

// ===== CONTROL FLOW =====

/// Create a case expression
pub fn case_(
  _subject: c.Expression,
  _branches: List(#(String, c.Expression)),
) -> c.Expression {
  // TODO: Implement proper case expression
  c.untyped_expression(c.Variable("case_placeholder"))
}

/// Create a let binding
pub fn let_(
  _bindings: List(#(String, c.Expression)),
  _in_expr: c.Expression,
) -> c.Expression {
  // TODO: Implement proper let expression
  c.untyped_expression(c.Variable("let_placeholder"))
}

// ===== FUNCTIONS =====

/// Create a function with one argument
pub fn fn1(
  arg_name: String,
  body: fn(c.Expression) -> c.Expression,
) -> c.Expression {
  let arg = variable(arg_name)
  let _body_expr = body(arg)
  // TODO: Implement proper lambda creation
  c.untyped_expression(c.Lambda([], c.Variable("lambda_placeholder")))
}

/// Create a function with two arguments
pub fn fn2(
  arg1_name: String,
  arg2_name: String,
  body: fn(c.Expression, c.Expression) -> c.Expression,
) -> c.Expression {
  let arg1 = variable(arg1_name)
  let arg2 = variable(arg2_name)
  let _body_expr = body(arg1, arg2)
  // TODO: Implement proper lambda creation
  c.untyped_expression(c.Lambda([], c.Variable("lambda_placeholder")))
}

// ===== DECLARATIONS =====

/// Create a simple value declaration
pub fn declaration(name: String, _value: c.Expression) -> c.Declaration {
  // TODO: Implement proper declaration creation
  c.Comment("TODO: declaration " <> name)
}

/// Create a function declaration
pub fn function(
  name: String,
  _args: List(String),
  _body: c.Expression,
) -> c.Declaration {
  // TODO: Implement proper function declaration
  c.Comment("TODO: function " <> name)
}
