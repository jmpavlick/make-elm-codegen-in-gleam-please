// Demonstration of package binding generation
// Shows how gleam-codegen can generate bindings for existing Gleam packages

import gleam/io
import gleam/string
import gleam/list
import gleam/option.{Some}
import gleam_codegen/package_parser as parser
import gleam_codegen/binding_generator as binder

pub fn main() {
  io.println("🔧 GLEAM PACKAGE BINDING GENERATION DEMO")
  io.println("========================================")
  
  demo_parse_simple_module()
  demo_parse_stdlib_module()
  demo_generate_bindings()
}

fn demo_parse_simple_module() {
  io.println("\n📝 PARSING A SIMPLE MODULE")
  io.println("--------------------------")
  
  // Example of a simple Gleam module
  let simple_module = "
/// A simple math module
import gleam/int

/// Add two integers together
pub fn add(x: Int, y: Int) -> Int {
  x + y
}

/// Get the absolute value of an integer
pub fn abs(x: Int) -> Int {
  case x >= 0 {
    True -> x
    False -> -x
  }
}

/// A constant value
pub fn pi() -> Float {
  3.14159
}

/// Private function (not exported)
fn helper(x: Int) -> Int {
  x * 2
}
"
  
  case parser.parse_module_from_string(simple_module, "math") {
    Ok(module) -> {
      io.println("✅ Successfully parsed module: " <> module.name)
      io.println("📊 Found " <> string.inspect(list.length(module.functions)) <> " functions")
      io.println("📦 Found " <> string.inspect(list.length(module.imports)) <> " imports")
      
      let public_functions = parser.get_public_functions(module)
      io.println("🔓 Public functions:")
      list.each(public_functions, fn(func) {
        let args_str = func.args 
          |> list.map(fn(arg) { arg.0 <> ": " <> arg.1 })
          |> string.join(", ")
        io.println("   - " <> func.name <> "(" <> args_str <> ") -> " <> func.return_type)
      })
    }
    Error(err) -> {
      io.println("❌ Failed to parse module: " <> err)
    }
  }
}

fn demo_parse_stdlib_module() {
  io.println("\n📚 PARSING A STDLIB MODULE")
  io.println("---------------------------")
  
  // Try to parse the gleam/int module from the standard library
  let stdlib_path = "build/packages/gleam_stdlib/src/gleam/int.gleam"
  
  case parser.parse_module_from_file(stdlib_path) {
    Ok(module) -> {
      io.println("✅ Successfully parsed stdlib module: " <> module.name)
      
      let public_functions = parser.get_public_functions(module)
      io.println("📊 Found " <> string.inspect(list.length(public_functions)) <> " public functions")
      
      // Show first few functions as examples
      let sample_functions = list.take(public_functions, 5)
      io.println("🔍 Sample functions:")
      list.each(sample_functions, fn(func) {
        let args_str = func.args 
          |> list.map(fn(arg) { arg.0 <> ": " <> arg.1 })
          |> string.join(", ")
        io.println("   - " <> func.name <> "(" <> args_str <> ") -> " <> func.return_type)
      })
      
      // Show imports
      io.println("📦 Imports: " <> string.join(module.imports, ", "))
    }
    Error(err) -> {
      io.println("❌ Could not parse stdlib module: " <> err)
      io.println("💡 This is expected if the build directory doesn't exist")
    }
  }
}

fn demo_generate_bindings() {
  io.println("\n🏗️ GENERATING BINDINGS")
  io.println("----------------------")
  
  // Create a sample module for binding generation
  let sample_module = parser.GleamModule(
    name: "gleam/string",
    functions: [
      parser.GleamFunction(
        name: "length",
        args: [#("str", "String")],
        return_type: "Int",
        is_public: True,
        documentation: Some("Get the length of a string")
      ),
      parser.GleamFunction(
        name: "append",
        args: [#("first", "String"), #("second", "String")],
        return_type: "String", 
        is_public: True,
        documentation: Some("Append two strings together")
      ),
      parser.GleamFunction(
        name: "empty",
        args: [],
        return_type: "String",
        is_public: True,
        documentation: Some("An empty string")
      )
    ],
    types: [],
    imports: []
  )
  
  io.println("📦 Generating bindings for sample module: " <> sample_module.name)
  
  // Generate bindings
  let _bindings = binder.generate_module_bindings(sample_module)
  let gen_file = binder.generate_gen_module_file(sample_module)
  
  io.println("✅ Generated bindings successfully!")
  io.println("📄 Generated file preview:")
  io.println("---")
  io.println(gen_file)
  io.println("---")
  
  io.println("\n🎯 WHAT THIS ENABLES:")
  io.println("---------------------")
  io.println("With these bindings, you could write code like:")
  io.println("")
  io.println("```gleam")
  io.println("import Gen.Gleam.String as GenString")
  io.println("import gleam_codegen as gc")
  io.println("")
  io.println("// Generate a string length call")
  io.println("let length_call = GenString.length(gc.string(\"hello\"))")
  io.println("")
  io.println("// Generate a string append call")
  io.println("let append_call = GenString.append(")
  io.println("  gc.string(\"Hello, \"),")
  io.println("  gc.string(\"World!\")")
  io.println(")")
  io.println("```")
  io.println("")
  io.println("And it would generate the corresponding Gleam code!")
}