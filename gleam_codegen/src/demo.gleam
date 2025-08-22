// Comprehensive demo of gleam-codegen's code generation capabilities
// Shows that we now have a WORKING code generator!

import gleam/io
import gleam_codegen as gc
import gleam_codegen/op

pub fn main() {
  io.println("🎉 GLEAM-CODEGEN WORKING DEMO 🎉")
  io.println("=====================================")

  demo_basic_expressions()
  demo_complex_expressions()
  demo_real_world_example()
  demo_file_generation()
}

fn demo_basic_expressions() {
  io.println("\n📝 BASIC EXPRESSION GENERATION")
  io.println("------------------------------")

  // Create expressions programmatically
  let number = gc.int(42)
  let text = gc.string("Hello, Gleam!")
  let flag = gc.bool(True)
  let var = gc.variable("my_variable")

  // Convert to source code
  io.println("Number: " <> gc.expression_to_string(number))
  io.println("String: " <> gc.expression_to_string(text))
  io.println("Bool: " <> gc.expression_to_string(flag))
  io.println("Variable: " <> gc.expression_to_string(var))
}

fn demo_complex_expressions() {
  io.println("\n🔧 COMPLEX EXPRESSION GENERATION")
  io.println("--------------------------------")

  let x = gc.variable("x")
  let y = gc.variable("y")
  let z = gc.variable("z")

  // Mathematical expression: (x + y) * z - 10
  let math_expr = op.minus(op.multiply(op.plus(x, y), z), gc.int(10))
  io.println("Math: " <> gc.expression_to_string(math_expr))

  // Logical expression: x > 0 && y < 100 || z == 42
  let logic_expr =
    op.or(
      op.and(op.gt(x, gc.int(0)), op.lt(y, gc.int(100))),
      op.equal(z, gc.int(42)),
    )
  io.println("Logic: " <> gc.expression_to_string(logic_expr))

  // Pipe expression: value |> func1 |> func2
  let pipe_expr =
    op.pipe(
      op.pipe(gc.variable("value"), gc.variable("func1")),
      gc.variable("func2"),
    )
  io.println("Pipe: " <> gc.expression_to_string(pipe_expr))

  // String concatenation
  let greeting = op.append(gc.string("Hello, "), gc.variable("name"))
  io.println("Concat: " <> gc.expression_to_string(greeting))
}

fn demo_real_world_example() {
  io.println("\n🌟 REAL-WORLD CODE GENERATION")
  io.println("-----------------------------")

  // Generate a realistic function body
  let input = gc.variable("input")
  let result = gc.variable("result")

  // if input > 0 then input * 2 else 0
  // (We don't have if-then-else yet, so simulate with operations)
  let validation = op.gt(input, gc.int(0))
  let calculation = op.multiply(input, gc.int(2))
  let fallback = gc.int(0)

  io.println("Validation: " <> gc.expression_to_string(validation))
  io.println("Calculation: " <> gc.expression_to_string(calculation))
  io.println("Fallback: " <> gc.expression_to_string(fallback))

  // Complex nested expression
  let complex =
    op.pipe(
      op.plus(op.multiply(gc.int(10), input), gc.int(5)),
      gc.variable("some_transform"),
    )
  io.println("Complex: " <> gc.expression_to_string(complex))
}

fn demo_file_generation() {
  io.println("\n📁 FILE GENERATION")
  io.println("------------------")

  // Create some meaningful expressions
  let magic_number = op.plus(gc.int(40), gc.int(2))
  let greeting_template =
    op.append(gc.string("Welcome, "), gc.variable("user_name"))

  // Create declarations
  let decl1 = gc.declaration("magic_number", magic_number)
  let decl2 = gc.declaration("greeting", greeting_template)

  // Generate a complete file
  let generated_file = gc.file(["generated", "math"], [decl1, decl2])
  let file_content = gc.to_string(generated_file)

  io.println("Generated File Content:")
  io.println("----------------------")
  io.println(file_content)
  io.println("----------------------")
}
