import { toList, CustomType as $CustomType } from "./gleam.mjs";
import * as $c from "./gleam_codegen/internal/compiler.mjs";
import * as $op from "./gleam_codegen/op.mjs";

export class File extends $CustomType {
  constructor(module_name, declarations, imports) {
    super();
    this.module_name = module_name;
    this.declarations = declarations;
    this.imports = imports;
  }
}

/**
 * Create a basic file with module name and declarations
 */
export function file(module_name, declarations) {
  return new File(module_name, declarations, toList([]));
}

/**
 * Convert a file to Gleam source code string
 */
export function to_string(_) {
  return "// Generated Gleam code\n// TODO: Implement rendering";
}

/**
 * Create an integer literal
 */
export function int(value) {
  return $c.simple_expression(new $c.IntLiteral(value), new $c.IntType());
}

/**
 * Create a float literal
 */
export function float(value) {
  return $c.simple_expression(new $c.FloatLiteral(value), new $c.FloatType());
}

/**
 * Create a string literal
 */
export function string(value) {
  return $c.simple_expression(new $c.StringLiteral(value), new $c.StringType());
}

/**
 * Create a boolean literal
 */
export function bool(value) {
  return $c.simple_expression(new $c.BoolLiteral(value), new $c.BoolType());
}

/**
 * Create a nil literal
 */
export function nil() {
  return $c.simple_expression(new $c.NilLiteral(), new $c.NilType());
}

/**
 * Create a variable reference
 */
export function variable(name) {
  return $c.untyped_expression(new $c.Variable(name));
}

/**
 * Create a list
 */
export function list(_) {
  return toList([]);
}

/**
 * Create a tuple
 */
export function tuple(_) {
  return $c.untyped_expression(new $c.Tuple(toList([])));
}

/**
 * Call a function with arguments
 */
export function call(_, _1) {
  return $c.untyped_expression(
    new $c.FunctionCall(new $c.Variable("placeholder"), toList([])),
  );
}

/**
 * Add two expressions
 */
export function add(left, right) {
  return $op.plus(left, right);
}

/**
 * Subtract two expressions
 */
export function subtract(left, right) {
  return $op.minus(left, right);
}

/**
 * Multiply two expressions
 */
export function multiply(left, right) {
  return $op.multiply(left, right);
}

/**
 * Divide two expressions
 */
export function divide(left, right) {
  return $op.divide(left, right);
}

/**
 * Create a case expression
 */
export function case_(_, _1) {
  return $c.untyped_expression(new $c.Variable("case_placeholder"));
}

/**
 * Create a let binding
 */
export function let_(_, _1) {
  return $c.untyped_expression(new $c.Variable("let_placeholder"));
}

/**
 * Create a function with one argument
 */
export function fn1(arg_name, body) {
  let arg = variable(arg_name);
  let $ = body(arg);
  
  return $c.untyped_expression(
    new $c.Lambda(toList([]), new $c.Variable("lambda_placeholder")),
  );
}

/**
 * Create a function with two arguments
 */
export function fn2(arg1_name, arg2_name, body) {
  let arg1 = variable(arg1_name);
  let arg2 = variable(arg2_name);
  let $ = body(arg1, arg2);
  
  return $c.untyped_expression(
    new $c.Lambda(toList([]), new $c.Variable("lambda_placeholder")),
  );
}

/**
 * Create a simple value declaration
 */
export function declaration(name, _) {
  return new $c.Comment("TODO: declaration " + name);
}

/**
 * Create a function declaration
 */
export function function$(name, _, _1) {
  return new $c.Comment("TODO: function " + name);
}
