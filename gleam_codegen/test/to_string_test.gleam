import gleeunit/should
import gleam_codegen as gc
import gleam_codegen/op
import gleam_codegen/to_string

// Test basic literal rendering
pub fn literals_rendering_test() {
  let int_expr = gc.int(42)
  let float_expr = gc.float(3.14)
  let string_expr = gc.string("hello world")
  let bool_true = gc.bool(True)
  let bool_false = gc.bool(False)
  let nil_expr = gc.nil()
  
  gc.expression_to_string(int_expr) |> should.equal("42")
  gc.expression_to_string(float_expr) |> should.equal("3.14")
  gc.expression_to_string(string_expr) |> should.equal("\"hello world\"")
  gc.expression_to_string(bool_true) |> should.equal("True")
  gc.expression_to_string(bool_false) |> should.equal("False")
  gc.expression_to_string(nil_expr) |> should.equal("Nil")
}

// Test variable rendering
pub fn variables_rendering_test() {
  let var = gc.variable("my_variable")
  let complex_var = gc.variable("some_long_variable_name")
  
  gc.expression_to_string(var) |> should.equal("my_variable")
  gc.expression_to_string(complex_var) |> should.equal("some_long_variable_name")
}

// Test arithmetic operator rendering
pub fn arithmetic_operators_test() {
  let x = gc.int(10)
  let y = gc.int(5)
  
  let sum = op.plus(x, y)
  let diff = op.minus(x, y)
  let product = op.multiply(x, y)
  let quotient = op.divide(x, y)
  
  gc.expression_to_string(sum) |> should.equal("10 + 5")
  gc.expression_to_string(diff) |> should.equal("10 - 5")
  gc.expression_to_string(product) |> should.equal("10 * 5")
  gc.expression_to_string(quotient) |> should.equal("10 / 5")
}

// Test comparison operator rendering
pub fn comparison_operators_test() {
  let x = gc.int(10)
  let y = gc.int(20)
  
  let eq = op.equal(x, y)
  let neq = op.not_equal(x, y)
  let less = op.lt(x, y)
  let greater = op.gt(x, y)
  
  gc.expression_to_string(eq) |> should.equal("10 == 20")
  gc.expression_to_string(neq) |> should.equal("10 != 20")
  gc.expression_to_string(less) |> should.equal("10 < 20")
  gc.expression_to_string(greater) |> should.equal("10 > 20")
}

// Test logical operator rendering
pub fn logical_operators_test() {
  let t = gc.bool(True)
  let f = gc.bool(False)
  
  let and_expr = op.and(t, f)
  let or_expr = op.or(t, f)
  
  gc.expression_to_string(and_expr) |> should.equal("True && False")
  gc.expression_to_string(or_expr) |> should.equal("True || False")
}

// Test operator precedence and parentheses
pub fn precedence_test() {
  let a = gc.int(1)
  let b = gc.int(2)
  let c = gc.int(3)
  
  // (a + b) * c should render with parentheses
  let complex1 = op.multiply(op.plus(a, b), c)
  gc.expression_to_string(complex1) |> should.equal("(1 + 2) * 3")
  
  // a + b * c should render without extra parentheses (multiplication has higher precedence)
  let complex2 = op.plus(a, op.multiply(b, c))
  gc.expression_to_string(complex2) |> should.equal("1 + 2 * 3")
  
  // (a == b) && (c > 0) - comparison in logical context  
  let complex3 = op.and(op.equal(a, b), op.gt(c, gc.int(0)))
  gc.expression_to_string(complex3) |> should.equal("1 == 2 && 3 > 0")
}

// Test pipe operator rendering
pub fn pipe_operators_test() {
  let value = gc.int(42)
  let func = gc.variable("some_function")
  
  let piped = op.pipe(value, func)
  gc.expression_to_string(piped) |> should.equal("42 |> some_function")
  
  // Chained pipes
  let func2 = gc.variable("another_function")
  let double_piped = op.pipe(piped, func2)
  gc.expression_to_string(double_piped) |> should.equal("42 |> some_function |> another_function")
}

// Test string concatenation
pub fn string_concatenation_test() {
  let hello = gc.string("Hello, ")
  let world = gc.string("World!")
  
  let greeting = op.append(hello, world)
  gc.expression_to_string(greeting) |> should.equal("\"Hello, \" <> \"World!\"")
}

// Test complex nested expressions
pub fn complex_expressions_test() {
  let x = gc.variable("x")
  let y = gc.variable("y")
  let z = gc.variable("z")
  
  // Complex mathematical expression: (x + y) * z - 10
  let math_expr = op.minus(
    op.multiply(op.plus(x, y), z),
    gc.int(10)
  )
  gc.expression_to_string(math_expr) |> should.equal("(x + y) * z - 10")
  
  // Complex logical expression: x > 0 && y < 100 || z == 42  
  let logic_expr = op.or(
    op.and(op.gt(x, gc.int(0)), op.lt(y, gc.int(100))),
    op.equal(z, gc.int(42))
  )
  gc.expression_to_string(logic_expr) |> should.equal("x > 0 && y < 100 || z == 42")
}

// Test string escaping
pub fn string_escaping_test() {
  let quote_string = gc.string("He said \"Hello!\"")
  let newline_string = gc.string("Line 1\nLine 2")
  let backslash_string = gc.string("C:\\path\\to\\file")
  
  gc.expression_to_string(quote_string) |> should.equal("\"He said \\\"Hello!\\\"\"")
  gc.expression_to_string(newline_string) |> should.equal("\"Line 1\\nLine 2\"")
  gc.expression_to_string(backslash_string) |> should.equal("\"C:\\\\path\\\\to\\\\file\"")
}

// Test that the main API delegates properly
pub fn main_api_delegation_test() {
  let x = gc.int(5)
  let y = gc.int(3)
  
  // These should use the proper rendering via the main API
  let sum = gc.add(x, y)
  let product = gc.multiply(x, y)
  
  gc.expression_to_string(sum) |> should.equal("5 + 3")
  gc.expression_to_string(product) |> should.equal("5 * 3")
}