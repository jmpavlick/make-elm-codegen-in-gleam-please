import * as $dict from "../../gleam_stdlib/gleam/dict.mjs";
import { Ok, CustomType as $CustomType } from "../gleam.mjs";
import * as $c from "../gleam_codegen/internal/compiler.mjs";

export class BinOp extends $CustomType {
  constructor(symbol, precedence, left_associative) {
    super();
    this.symbol = symbol;
    this.precedence = precedence;
    this.left_associative = left_associative;
  }
}

/**
 * Apply a binary operator to two expressions
 * 
 * @ignore
 */
function apply_infix(op, type_, left, right) {
  return $c.expression(
    (index) => {
      let left_details = $c.to_expression_details(left, index);
      let right_details = $c.to_expression_details(right, $c.next(index));
      return new $c.ExpressionDetails(
        new $c.BinaryOp(
          op.symbol,
          left_details.expression,
          right_details.expression,
        ),
        new Ok(new $c.Inference(type_, $dict.new$(), $dict.new$())),
        $c.merge_imports(left_details.imports, right_details.imports),
      );
    },
  );
}

/**
 * Addition operator `+`
 */
export function plus(left, right) {
  return apply_infix(new BinOp("+", 6, true), new $c.IntType(), left, right);
}

/**
 * Subtraction operator `-`
 */
export function minus(left, right) {
  return apply_infix(new BinOp("-", 6, true), new $c.IntType(), left, right);
}

/**
 * Multiplication operator `*`
 */
export function multiply(left, right) {
  return apply_infix(new BinOp("*", 7, true), new $c.IntType(), left, right);
}

/**
 * Division operator `/`
 */
export function divide(left, right) {
  return apply_infix(new BinOp("/", 7, true), new $c.IntType(), left, right);
}

/**
 * Integer division operator `//` (not in Gleam, but useful for completeness)
 */
export function int_divide(left, right) {
  return apply_infix(new BinOp("//", 7, true), new $c.IntType(), left, right);
}

/**
 * Modulo operator `%`
 */
export function modulo(left, right) {
  return apply_infix(new BinOp("%", 7, true), new $c.IntType(), left, right);
}

/**
 * Equality operator `==`
 */
export function equal(left, right) {
  return apply_infix(new BinOp("==", 4, false), new $c.BoolType(), left, right);
}

/**
 * Inequality operator `!=`
 */
export function not_equal(left, right) {
  return apply_infix(new BinOp("!=", 4, false), new $c.BoolType(), left, right);
}

/**
 * Less than operator `<`
 */
export function lt(left, right) {
  return apply_infix(new BinOp("<", 4, false), new $c.BoolType(), left, right);
}

/**
 * Greater than operator `>`
 */
export function gt(left, right) {
  return apply_infix(new BinOp(">", 4, false), new $c.BoolType(), left, right);
}

/**
 * Less than or equal operator `<=`
 */
export function lte(left, right) {
  return apply_infix(new BinOp("<=", 4, false), new $c.BoolType(), left, right);
}

/**
 * Greater than or equal operator `>=`
 */
export function gte(left, right) {
  return apply_infix(new BinOp(">=", 4, false), new $c.BoolType(), left, right);
}

/**
 * Logical AND operator `&&`
 */
export function and(left, right) {
  return apply_infix(new BinOp("&&", 3, true), new $c.BoolType(), left, right);
}

/**
 * Logical OR operator `||`
 */
export function or(left, right) {
  return apply_infix(new BinOp("||", 2, true), new $c.BoolType(), left, right);
}

/**
 * String/List concatenation operator `<>`
 */
export function append(left, right) {
  return apply_infix(new BinOp("<>", 5, true), new $c.StringType(), left, right);
}

/**
 * Pipe operator `|>`
 */
export function pipe(left, right) {
  return $c.expression(
    (index) => {
      let left_details = $c.to_expression_details(left, index);
      let right_details = $c.to_expression_details(right, $c.next(index));
      return new $c.ExpressionDetails(
        new $c.Pipe(left_details.expression, right_details.expression),
        right_details.annotation,
        $c.merge_imports(left_details.imports, right_details.imports),
      );
    },
  );
}

/**
 * Reverse pipe operator `<|`
 */
export function pipe_left(left, right) {
  return pipe(right, left);
}

/**
 * Add parentheses around an expression
 */
export function parens(expr) {
  return $c.expression(
    (index) => {
      let details = $c.to_expression_details(expr, index);
      return new $c.ExpressionDetails(
        details.expression,
        details.annotation,
        details.imports,
      );
    },
  );
}
