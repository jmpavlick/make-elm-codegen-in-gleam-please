import * as $should from "../gleeunit/gleeunit/should.mjs";
import * as $gc from "./gleam_codegen.mjs";
import * as $op from "./gleam_codegen/op.mjs";
import * as $to_string from "./gleam_codegen/to_string.mjs";

export function literals_rendering_test() {
  let int_expr = $gc.int(42);
  let float_expr = $gc.float(3.14);
  let string_expr = $gc.string("hello world");
  let bool_true = $gc.bool(true);
  let bool_false = $gc.bool(false);
  let nil_expr = $gc.nil();
  let _pipe = $gc.expression_to_string(int_expr);
  $should.equal(_pipe, "42")
  let _pipe$1 = $gc.expression_to_string(float_expr);
  $should.equal(_pipe$1, "3.14")
  let _pipe$2 = $gc.expression_to_string(string_expr);
  $should.equal(_pipe$2, "\"hello world\"")
  let _pipe$3 = $gc.expression_to_string(bool_true);
  $should.equal(_pipe$3, "True")
  let _pipe$4 = $gc.expression_to_string(bool_false);
  $should.equal(_pipe$4, "False")
  let _pipe$5 = $gc.expression_to_string(nil_expr);
  return $should.equal(_pipe$5, "Nil");
}

export function variables_rendering_test() {
  let var$ = $gc.variable("my_variable");
  let complex_var = $gc.variable("some_long_variable_name");
  let _pipe = $gc.expression_to_string(var$);
  $should.equal(_pipe, "my_variable")
  let _pipe$1 = $gc.expression_to_string(complex_var);
  return $should.equal(_pipe$1, "some_long_variable_name");
}

export function arithmetic_operators_test() {
  let x = $gc.int(10);
  let y = $gc.int(5);
  let sum = $op.plus(x, y);
  let diff = $op.minus(x, y);
  let product = $op.multiply(x, y);
  let quotient = $op.divide(x, y);
  let _pipe = $gc.expression_to_string(sum);
  $should.equal(_pipe, "10 + 5")
  let _pipe$1 = $gc.expression_to_string(diff);
  $should.equal(_pipe$1, "10 - 5")
  let _pipe$2 = $gc.expression_to_string(product);
  $should.equal(_pipe$2, "10 * 5")
  let _pipe$3 = $gc.expression_to_string(quotient);
  return $should.equal(_pipe$3, "10 / 5");
}

export function comparison_operators_test() {
  let x = $gc.int(10);
  let y = $gc.int(20);
  let eq = $op.equal(x, y);
  let neq = $op.not_equal(x, y);
  let less = $op.lt(x, y);
  let greater = $op.gt(x, y);
  let _pipe = $gc.expression_to_string(eq);
  $should.equal(_pipe, "10 == 20")
  let _pipe$1 = $gc.expression_to_string(neq);
  $should.equal(_pipe$1, "10 != 20")
  let _pipe$2 = $gc.expression_to_string(less);
  $should.equal(_pipe$2, "10 < 20")
  let _pipe$3 = $gc.expression_to_string(greater);
  return $should.equal(_pipe$3, "10 > 20");
}

export function logical_operators_test() {
  let t = $gc.bool(true);
  let f = $gc.bool(false);
  let and_expr = $op.and(t, f);
  let or_expr = $op.or(t, f);
  let _pipe = $gc.expression_to_string(and_expr);
  $should.equal(_pipe, "True && False")
  let _pipe$1 = $gc.expression_to_string(or_expr);
  return $should.equal(_pipe$1, "True || False");
}

export function precedence_test() {
  let a = $gc.int(1);
  let b = $gc.int(2);
  let c = $gc.int(3);
  let complex1 = $op.multiply($op.plus(a, b), c);
  let _pipe = $gc.expression_to_string(complex1);
  $should.equal(_pipe, "(1 + 2) * 3")
  let complex2 = $op.plus(a, $op.multiply(b, c));
  let _pipe$1 = $gc.expression_to_string(complex2);
  $should.equal(_pipe$1, "1 + 2 * 3")
  let complex3 = $op.and($op.equal(a, b), $op.gt(c, $gc.int(0)));
  let _pipe$2 = $gc.expression_to_string(complex3);
  return $should.equal(_pipe$2, "1 == 2 && 3 > 0");
}

export function pipe_operators_test() {
  let value = $gc.int(42);
  let func = $gc.variable("some_function");
  let piped = $op.pipe(value, func);
  let _pipe = $gc.expression_to_string(piped);
  $should.equal(_pipe, "42 |> some_function")
  let func2 = $gc.variable("another_function");
  let double_piped = $op.pipe(piped, func2);
  let _pipe$1 = $gc.expression_to_string(double_piped);
  return $should.equal(_pipe$1, "42 |> some_function |> another_function");
}

export function string_concatenation_test() {
  let hello = $gc.string("Hello, ");
  let world = $gc.string("World!");
  let greeting = $op.append(hello, world);
  let _pipe = $gc.expression_to_string(greeting);
  return $should.equal(_pipe, "\"Hello, \" <> \"World!\"");
}

export function complex_expressions_test() {
  let x = $gc.variable("x");
  let y = $gc.variable("y");
  let z = $gc.variable("z");
  let math_expr = $op.minus($op.multiply($op.plus(x, y), z), $gc.int(10));
  let _pipe = $gc.expression_to_string(math_expr);
  $should.equal(_pipe, "(x + y) * z - 10")
  let logic_expr = $op.or(
    $op.and($op.gt(x, $gc.int(0)), $op.lt(y, $gc.int(100))),
    $op.equal(z, $gc.int(42)),
  );
  let _pipe$1 = $gc.expression_to_string(logic_expr);
  return $should.equal(_pipe$1, "x > 0 && y < 100 || z == 42");
}

export function string_escaping_test() {
  let quote_string = $gc.string("He said \"Hello!\"");
  let newline_string = $gc.string("Line 1\nLine 2");
  let backslash_string = $gc.string("C:\\path\\to\\file");
  let _pipe = $gc.expression_to_string(quote_string);
  $should.equal(_pipe, "\"He said \\\"Hello!\\\"\"")
  let _pipe$1 = $gc.expression_to_string(newline_string);
  $should.equal(_pipe$1, "\"Line 1\\nLine 2\"")
  let _pipe$2 = $gc.expression_to_string(backslash_string);
  return $should.equal(_pipe$2, "\"C:\\\\path\\\\to\\\\file\"");
}

export function main_api_delegation_test() {
  let x = $gc.int(5);
  let y = $gc.int(3);
  let sum = $gc.add(x, y);
  let product = $gc.multiply(x, y);
  let _pipe = $gc.expression_to_string(sum);
  $should.equal(_pipe, "5 + 3")
  let _pipe$1 = $gc.expression_to_string(product);
  return $should.equal(_pipe$1, "5 * 3");
}
