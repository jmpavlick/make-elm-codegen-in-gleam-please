// Internal compiler types and functions for gleam-codegen
// Maps to elm-codegen's Internal.Compiler module

import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{type Option}

import gleam/set.{type Set}
import gleam/string

// ===== INDEX SYSTEM =====

/// Index system for variable generation and scoping
/// Maps to elm-codegen's Internal.Index
pub opaque type Index {
  Index(
    module_name: Option(List(String)),
    counter: Int,
    trail: List(Int),
    scope: Set(String),
    typecheck: Bool,
  )
}

pub fn start_index(module_name: Option(List(String))) -> Index {
  Index(module_name, 0, [], set.new(), True)
}

pub fn next(index: Index) -> Index {
  case index {
    Index(mod_name, counter, trail, scope, check) ->
      Index(mod_name, counter + 1, trail, scope, check)
  }
}

pub fn dive(index: Index) -> Index {
  case index {
    Index(mod_name, counter, trail, scope, check) ->
      Index(mod_name, 0, [counter, ..trail], scope, check)
  }
}

pub fn get_name(index: Index, base_name: String) -> String {
  case index {
    Index(_, 0, [], _, _) -> base_name
    Index(_, counter, trail, _, _) -> {
      let suffix =
        list.reverse([counter, ..trail])
        |> list.map(fn(n) { "_" <> int.to_string(n) })
        |> string.join("")
      base_name <> suffix
    }
  }
}

// ===== CORE TYPES =====

/// Represents a Gleam module name and import info
pub type Module {
  Module(name: List(String), alias: Option(String), exposing: List(String))
}

/// Type inference errors
pub type InferenceError {
  UnificationError(expected: String, found: String)
  UnknownVariable(name: String)
  CircularType(name: String)
}

/// Type inference information
pub type Inference {
  Inference(
    type_: GleamType,
    inferences: Dict(String, GleamType),
    aliases: Dict(String, TypeAlias),
  )
}

pub type TypeAlias {
  TypeAlias(variables: List(String), target: GleamType)
}

/// Represents Gleam types
pub type GleamType {
  // Basic types
  IntType
  FloatType
  StringType
  BoolType
  NilType

  // Compound types
  ListType(GleamType)
  TupleType(List(GleamType))
  FunctionType(List(GleamType), GleamType)

  // Custom types
  CustomType(module: List(String), name: String, args: List(GleamType))
  TypeVariable(name: String)

  // Result and Option
  ResultType(GleamType, GleamType)
  OptionType(GleamType)
}

/// Represents Gleam expressions in our AST
pub type GleamExpression {
  // Literals
  IntLiteral(Int)
  FloatLiteral(Float)
  StringLiteral(String)
  BoolLiteral(Bool)
  NilLiteral

  // Variables and references
  Variable(String)
  FieldAccess(GleamExpression, String)

  // Function calls
  FunctionCall(GleamExpression, List(GleamExpression))

  // Control flow
  Case(GleamExpression, List(#(Pattern, GleamExpression)))
  Let(List(#(Pattern, GleamExpression)), GleamExpression)

  // Functions
  Lambda(List(Pattern), GleamExpression)

  // Data structures
  List(List(GleamExpression))
  Tuple(List(GleamExpression))
  Record(List(#(String, GleamExpression)))
  RecordUpdate(GleamExpression, List(#(String, GleamExpression)))

  // Operators (will be expanded)
  BinaryOp(String, GleamExpression, GleamExpression)
  UnaryOp(String, GleamExpression)

  // Pipe
  Pipe(GleamExpression, GleamExpression)
}

/// Patterns for case expressions and let bindings
pub type Pattern {
  VariablePattern(String)
  IntPattern(Int)
  FloatPattern(Float)
  StringPattern(String)
  BoolPattern(Bool)
  NilPattern
  ListPattern(List(Pattern))
  TuplePattern(List(Pattern))
  ConstructorPattern(String, List(Pattern))
  AsPattern(Pattern, String)
  DiscardPattern
}

/// Expression details - the core of our expression system
pub type ExpressionDetails {
  ExpressionDetails(
    expression: GleamExpression,
    annotation: Result(Inference, List(InferenceError)),
    imports: List(Module),
  )
}

/// The main Expression type - lazy evaluation with indexing
/// Maps directly to elm-codegen's Expression type
pub opaque type Expression {
  Expression(fn(Index) -> ExpressionDetails)
}

/// Helper to create expressions that properly dive into the index
pub fn expression(builder: fn(Index) -> ExpressionDetails) -> Expression {
  Expression(fn(index) { builder(dive(index)) })
}

/// Extract details from an expression given an index
pub fn to_expression_details(
  expr: Expression,
  index: Index,
) -> ExpressionDetails {
  case expr {
    Expression(builder) -> builder(index)
  }
}

// ===== DECLARATION TYPES =====

/// Exposure settings for declarations
pub type Expose {
  NotExposed
  Exposed
  ExposedConstructors
}

/// Top-level declarations
pub type Declaration {
  Declaration(DeclarationDetails)
  Comment(String)
  ModuleDocs(String)
  Block(String)
  Group(List(Declaration))
}

pub type DeclarationDetails {
  DeclarationDetails(
    name: String,
    exposed: Expose,
    imports: List(Module),
    docs: Option(String),
    to_body: fn(Index) -> DeclarationBody,
  )
}

pub type DeclarationBody {
  DeclarationBody(
    declaration: GleamDeclaration,
    additional_imports: List(Module),
    warning: Option(Warning),
  )
}

pub type Warning {
  Warning(declaration: String, warning: String)
}

/// Represents actual Gleam declarations
pub type GleamDeclaration {
  FunctionDecl(
    name: String,
    args: List(#(String, Option(GleamType))),
    return_type: Option(GleamType),
    body: GleamExpression,
  )

  TypeDecl(
    name: String,
    vars: List(String),
    constructors: List(#(String, List(GleamType))),
  )

  TypeAliasDecl(name: String, vars: List(String), type_: GleamType)

  ConstDecl(name: String, type_: Option(GleamType), value: GleamExpression)
}

// ===== UTILITY FUNCTIONS =====

/// Create an expression with no imports and inferred type
pub fn simple_expression(expr: GleamExpression, type_: GleamType) -> Expression {
  Expression(fn(_index) {
    ExpressionDetails(
      expression: expr,
      annotation: Ok(Inference(type_, dict.new(), dict.new())),
      imports: [],
    )
  })
}

/// Create an expression with unknown type (to be inferred)
pub fn untyped_expression(expr: GleamExpression) -> Expression {
  Expression(fn(_index) {
    ExpressionDetails(
      expression: expr,
      annotation: Error([UnknownVariable("untyped")]),
      imports: [],
    )
  })
}

/// Merge two sets of imports
pub fn merge_imports(
  imports1: List(Module),
  imports2: List(Module),
) -> List(Module) {
  list.append(imports1, imports2)
  |> list.unique
}
