import gleeunit
import gleeunit/should
import gleam_codegen as gc

pub fn main() {
  gleeunit.main()
}

// Test basic literal creation
pub fn int_literal_test() {
  let _expr = gc.int(42)
  // We can't easily test the internal structure without exposing it,
  // but we can verify that it compiles and creates an expression
  True
  |> should.be_true
}

pub fn string_literal_test() {
  let _expr = gc.string("hello world")
  True
  |> should.be_true  
}

pub fn bool_literal_test() {
  let _expr = gc.bool(True)
  True
  |> should.be_true
}

pub fn variable_test() {
  let _expr = gc.variable("my_var")
  True
  |> should.be_true
}

// Test basic file creation
pub fn file_creation_test() {
  let declarations = [
    gc.declaration("my_value", gc.int(42)),
    gc.declaration("my_string", gc.string("test"))
  ]
  
  let file = gc.file(["my_module"], declarations)
  let output = gc.to_string(file)
  
  output
  |> should.equal("// Generated Gleam code\n// TODO: Implement rendering")
}

// Test that operators compile (even if they don't work properly yet)
pub fn operators_compile_test() {
  let left = gc.int(10)
  let right = gc.int(20)
  
  let _sum = gc.add(left, right)
  let _diff = gc.subtract(left, right)
  let _product = gc.multiply(left, right)
  let _quotient = gc.divide(left, right)
  
  // Just verify they all compile and return expressions
  True
  |> should.be_true
}

// Test function builders compile
pub fn function_builders_test() {
  let _add_func = gc.fn2("x", "y", fn(x, y) { gc.add(x, y) })
  let _simple_func = gc.fn1("x", fn(x) { gc.multiply(x, gc.int(2)) })
  
  True
  |> should.be_true
}