import * as $string from "../gleam_stdlib/gleam/string.mjs";
import * as $gleeunit from "../gleeunit/gleeunit.mjs";
import * as $should from "../gleeunit/gleeunit/should.mjs";
import { toList } from "./gleam.mjs";
import * as $gc from "./gleam_codegen.mjs";

export function main() {
  return $gleeunit.main();
}

export function int_literal_test() {
  let $ = $gc.int(42);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function string_literal_test() {
  let $ = $gc.string("hello world");
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function bool_literal_test() {
  let $ = $gc.bool(true);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function variable_test() {
  let $ = $gc.variable("my_var");
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function file_creation_test() {
  let declarations = toList([
    $gc.declaration("my_value", $gc.int(42)),
    $gc.declaration("my_string", $gc.string("test")),
  ]);
  let file = $gc.file(toList(["my_module"]), declarations);
  let output = $gc.to_string(file);
  let _pipe = output;
  $should.not_equal(
    _pipe,
    "// Generated Gleam code\n// TODO: Implement rendering",
  )
  let $ = $string.contains(output, "// Module: my_module") && $string.contains(
    output,
    "// TODO: declaration my_value",
  );
  if ($) {
    let _pipe$1 = true;
    return $should.be_true(_pipe$1);
  } else {
    return $should.fail();
  }
}

export function operators_compile_test() {
  let left = $gc.int(10);
  let right = $gc.int(20);
  let $ = $gc.add(left, right);
  
  let $1 = $gc.subtract(left, right);
  
  let $2 = $gc.multiply(left, right);
  
  let $3 = $gc.divide(left, right);
  
  let _pipe = true;
  return $should.be_true(_pipe);
}

export function function_builders_test() {
  let $ = $gc.fn2("x", "y", (x, y) => { return $gc.add(x, y); });
  
  let $1 = $gc.fn1("x", (x) => { return $gc.multiply(x, $gc.int(2)); });
  
  let _pipe = true;
  return $should.be_true(_pipe);
}
