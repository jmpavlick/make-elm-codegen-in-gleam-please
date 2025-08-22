import * as $io from "../gleam_stdlib/gleam/io.mjs";
import { toList } from "./gleam.mjs";
import * as $gc from "./gleam_codegen.mjs";
import * as $op from "./gleam_codegen/op.mjs";

function demo_basic_expressions() {
  $io.println("\n📝 BASIC EXPRESSION GENERATION");
  $io.println("------------------------------");
  let number = $gc.int(42);
  let text = $gc.string("Hello, Gleam!");
  let flag = $gc.bool(true);
  let var$ = $gc.variable("my_variable");
  $io.println("Number: " + $gc.expression_to_string(number));
  $io.println("String: " + $gc.expression_to_string(text));
  $io.println("Bool: " + $gc.expression_to_string(flag));
  return $io.println("Variable: " + $gc.expression_to_string(var$));
}

function demo_complex_expressions() {
  $io.println("\n🔧 COMPLEX EXPRESSION GENERATION");
  $io.println("--------------------------------");
  let x = $gc.variable("x");
  let y = $gc.variable("y");
  let z = $gc.variable("z");
  let math_expr = $op.minus($op.multiply($op.plus(x, y), z), $gc.int(10));
  $io.println("Math: " + $gc.expression_to_string(math_expr));
  let logic_expr = $op.or(
    $op.and($op.gt(x, $gc.int(0)), $op.lt(y, $gc.int(100))),
    $op.equal(z, $gc.int(42)),
  );
  $io.println("Logic: " + $gc.expression_to_string(logic_expr));
  let pipe_expr = $op.pipe(
    $op.pipe($gc.variable("value"), $gc.variable("func1")),
    $gc.variable("func2"),
  );
  $io.println("Pipe: " + $gc.expression_to_string(pipe_expr));
  let greeting = $op.append($gc.string("Hello, "), $gc.variable("name"));
  return $io.println("Concat: " + $gc.expression_to_string(greeting));
}

function demo_real_world_example() {
  $io.println("\n🌟 REAL-WORLD CODE GENERATION");
  $io.println("-----------------------------");
  let input = $gc.variable("input");
  let result = $gc.variable("result");
  let validation = $op.gt(input, $gc.int(0));
  let calculation = $op.multiply(input, $gc.int(2));
  let fallback = $gc.int(0);
  $io.println("Validation: " + $gc.expression_to_string(validation));
  $io.println("Calculation: " + $gc.expression_to_string(calculation));
  $io.println("Fallback: " + $gc.expression_to_string(fallback));
  let complex = $op.pipe(
    $op.plus($op.multiply($gc.int(10), input), $gc.int(5)),
    $gc.variable("some_transform"),
  );
  return $io.println("Complex: " + $gc.expression_to_string(complex));
}

function demo_file_generation() {
  $io.println("\n📁 FILE GENERATION");
  $io.println("------------------");
  let magic_number = $op.plus($gc.int(40), $gc.int(2));
  let greeting_template = $op.append(
    $gc.string("Welcome, "),
    $gc.variable("user_name"),
  );
  let decl1 = $gc.declaration("magic_number", magic_number);
  let decl2 = $gc.declaration("greeting", greeting_template);
  let generated_file = $gc.file(
    toList(["generated", "math"]),
    toList([decl1, decl2]),
  );
  let file_content = $gc.to_string(generated_file);
  $io.println("Generated File Content:");
  $io.println("----------------------");
  $io.println(file_content);
  return $io.println("----------------------");
}

export function main() {
  $io.println("🎉 GLEAM-CODEGEN WORKING DEMO 🎉");
  $io.println("=====================================");
  demo_basic_expressions();
  demo_complex_expressions();
  demo_real_world_example();
  return demo_file_generation();
}
