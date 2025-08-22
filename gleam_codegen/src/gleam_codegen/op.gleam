// Operators module for gleam-codegen
// Maps to elm-codegen's Elm.Op module

import gleam_codegen/internal/compiler as c
import gleam/dict

// ===== BINARY OPERATORS =====

/// Represents a binary operator with precedence and associativity
pub type BinOp {
  BinOp(symbol: String, precedence: Int, left_associative: Bool)
}

/// Apply a binary operator to two expressions
fn apply_infix(
  op: BinOp, 
  type_: c.GleamType, 
  left: c.Expression, 
  right: c.Expression
) -> c.Expression {
  c.expression(fn(index) {
    let left_details = c.to_expression_details(left, index)
    let right_details = c.to_expression_details(right, c.next(index))
    
    c.ExpressionDetails(
      expression: c.BinaryOp(op.symbol, left_details.expression, right_details.expression),
      annotation: Ok(c.Inference(type_, dict.new(), dict.new())),
      imports: c.merge_imports(left_details.imports, right_details.imports)
    )
  })
}

// ===== ARITHMETIC OPERATORS =====

/// Addition operator `+`
pub fn plus(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("+", 6, True),
    c.IntType, // TODO: Should infer between Int/Float
    left,
    right
  )
}

/// Subtraction operator `-`
pub fn minus(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("-", 6, True),
    c.IntType, // TODO: Should infer between Int/Float  
    left,
    right
  )
}

/// Multiplication operator `*`
pub fn multiply(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("*", 7, True),
    c.IntType, // TODO: Should infer between Int/Float
    left,
    right
  )
}

/// Division operator `/`
pub fn divide(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("/", 7, True),
    c.IntType, // TODO: Should infer between Int/Float
    left,
    right
  )
}

/// Integer division operator `//` (not in Gleam, but useful for completeness)
pub fn int_divide(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("//", 7, True),
    c.IntType,
    left,
    right
  )
}

/// Modulo operator `%`
pub fn modulo(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("%", 7, True),
    c.IntType,
    left,
    right
  )
}

// ===== COMPARISON OPERATORS =====

/// Equality operator `==`
pub fn equal(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("==", 4, False),
    c.BoolType,
    left,
    right
  )
}

/// Inequality operator `!=`
pub fn not_equal(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("!=", 4, False),
    c.BoolType,
    left,
    right
  )
}

/// Less than operator `<`
pub fn lt(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("<", 4, False),
    c.BoolType,
    left,
    right
  )
}

/// Greater than operator `>`
pub fn gt(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp(">", 4, False),
    c.BoolType,
    left,
    right
  )
}

/// Less than or equal operator `<=`
pub fn lte(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("<=", 4, False),
    c.BoolType,
    left,
    right
  )
}

/// Greater than or equal operator `>=`
pub fn gte(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp(">=", 4, False),
    c.BoolType,
    left,
    right
  )
}

// ===== LOGICAL OPERATORS =====

/// Logical AND operator `&&`
pub fn and(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("&&", 3, True),
    c.BoolType,
    left,
    right
  )
}

/// Logical OR operator `||`
pub fn or(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("||", 2, True),
    c.BoolType,
    left,
    right
  )
}

// ===== STRING/LIST OPERATORS =====

/// String/List concatenation operator `<>`
pub fn append(left: c.Expression, right: c.Expression) -> c.Expression {
  apply_infix(
    BinOp("<>", 5, True),
    c.StringType, // TODO: Should infer String vs List
    left,
    right
  )
}

// ===== PIPE OPERATORS =====

/// Pipe operator `|>`
pub fn pipe(left: c.Expression, right: c.Expression) -> c.Expression {
  // Pipe is special - it doesn't need parentheses and has different semantics
  c.expression(fn(index) {
    let left_details = c.to_expression_details(left, index)
    let right_details = c.to_expression_details(right, c.next(index))
    
    c.ExpressionDetails(
      expression: c.Pipe(left_details.expression, right_details.expression),
      annotation: right_details.annotation, // Result type is the right side
      imports: c.merge_imports(left_details.imports, right_details.imports)
    )
  })
}

/// Reverse pipe operator `<|` 
pub fn pipe_left(left: c.Expression, right: c.Expression) -> c.Expression {
  // <| is just reversed |>
  pipe(right, left)
}

// ===== UTILITY FUNCTIONS =====

/// Add parentheses around an expression
pub fn parens(expr: c.Expression) -> c.Expression {
  c.expression(fn(index) {
    let details = c.to_expression_details(expr, index)
    
    c.ExpressionDetails(
      ..details,
      // TODO: Wrap expression in parentheses in the AST
      expression: details.expression
    )
  })
}