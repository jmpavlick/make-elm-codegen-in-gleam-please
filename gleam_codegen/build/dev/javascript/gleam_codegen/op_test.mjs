import * as $should from "../gleeunit/gleeunit/should.mjs";
import { toList } from "./gleam.mjs";
import * as $gc from "./gleam_codegen.mjs";
import * as $op from "./gleam_codegen/op.mjs";

export function arithmetic_operators_test() {
  let x = $gc.int(10);
  let y = $gc.int(5);
  let sum = $op.plus(x, y);
  let diff = $op.minus(x, y);
  let product = $op.multiply(x, y);
  let quotient = $op.divide(x, y);
  let remainder = $op.modulo(x, y);
  let $ = toList([sum, diff, product, quotient, remainder]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function comparison_operators_test() {
  let x = $gc.int(10);
  let y = $gc.int(20);
  let eq = $op.equal(x, y);
  let neq = $op.not_equal(x, y);
  let less = $op.lt(x, y);
  let greater = $op.gt(x, y);
  let lte = $op.lte(x, y);
  let gte = $op.gte(x, y);
  let $ = toList([eq, neq, less, greater, lte, gte]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function logical_operators_test() {
  let t = $gc.bool(true);
  let f = $gc.bool(false);
  let and_expr = $op.and(t, f);
  let or_expr = $op.or(t, f);
  let $ = toList([and_expr, or_expr]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function string_operators_test() {
  let hello = $gc.string("hello");
  let world = $gc.string(" world");
  let greeting = $op.append(hello, world);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function pipe_operators_test() {
  let value = $gc.int(42);
  let func = $gc.variable("some_function");
  let piped = $op.pipe(value, func);
  let reverse_piped = $op.pipe_left(func, value);
  let $ = toList([piped, reverse_piped]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function chained_operators_test() {
  let a = $gc.int(10);
  let b = $gc.int(20);
  let c = $gc.int(30);
  let complex_expr = $op.multiply($op.plus(a, b), c);
  let sum_chain = $op.plus($op.plus(a, b), c);
  let $ = toList([complex_expr, sum_chain]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function main_api_operators_test() {
  let x = $gc.int(5);
  let y = $gc.int(3);
  let sum = $gc.add(x, y);
  let diff = $gc.subtract(x, y);
  let product = $gc.multiply(x, y);
  let quotient = $gc.divide(x, y);
  let $ = toList([sum, diff, product, quotient]);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}
