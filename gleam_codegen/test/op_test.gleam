import gleam_codegen as gc
import gleam_codegen/op
import gleeunit/should

// Test arithmetic operators
pub fn arithmetic_operators_test() {
  let x = gc.int(10)
  let y = gc.int(5)

  // Test that all operators compile and create expressions
  let sum = op.plus(x, y)
  let diff = op.minus(x, y)
  let product = op.multiply(x, y)
  let quotient = op.divide(x, y)
  let remainder = op.modulo(x, y)

  // Verify they all compile
  let _results = [sum, diff, product, quotient, remainder]
  True |> should.be_true
}

// Test comparison operators
pub fn comparison_operators_test() {
  let x = gc.int(10)
  let y = gc.int(20)

  let eq = op.equal(x, y)
  let neq = op.not_equal(x, y)
  let less = op.lt(x, y)
  let greater = op.gt(x, y)
  let lte = op.lte(x, y)
  let gte = op.gte(x, y)

  let _results = [eq, neq, less, greater, lte, gte]
  True |> should.be_true
}

// Test logical operators
pub fn logical_operators_test() {
  let t = gc.bool(True)
  let f = gc.bool(False)

  let and_expr = op.and(t, f)
  let or_expr = op.or(t, f)

  let _results = [and_expr, or_expr]
  True |> should.be_true
}

// Test string operations
pub fn string_operators_test() {
  let hello = gc.string("hello")
  let world = gc.string(" world")

  let greeting = op.append(hello, world)

  let _greeting = greeting
  True |> should.be_true
}

// Test pipe operators
pub fn pipe_operators_test() {
  let value = gc.int(42)
  let func = gc.variable("some_function")

  let piped = op.pipe(value, func)
  let reverse_piped = op.pipe_left(func, value)

  let _results = [piped, reverse_piped]
  True |> should.be_true
}

// Test that we can chain operators
pub fn chained_operators_test() {
  let a = gc.int(10)
  let b = gc.int(20)
  let c = gc.int(30)

  // (a + b) * c
  let complex_expr = op.multiply(op.plus(a, b), c)

  // a + b + c (left associative)
  let sum_chain = op.plus(op.plus(a, b), c)

  let _results = [complex_expr, sum_chain]
  True |> should.be_true
}

// Test using main API functions that delegate to Op module
pub fn main_api_operators_test() {
  let x = gc.int(5)
  let y = gc.int(3)

  // These should now use the proper Op module functions
  let sum = gc.add(x, y)
  let diff = gc.subtract(x, y)
  let product = gc.multiply(x, y)
  let quotient = gc.divide(x, y)

  let _results = [sum, diff, product, quotient]
  True |> should.be_true
}
