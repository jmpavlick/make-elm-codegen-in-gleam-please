import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $int from "../../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import * as $set from "../../../gleam_stdlib/gleam/set.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import {
  Ok,
  Error,
  toList,
  Empty as $Empty,
  prepend as listPrepend,
  CustomType as $CustomType,
} from "../../gleam.mjs";

class Index extends $CustomType {
  constructor(module_name, counter, trail, scope, typecheck) {
    super();
    this.module_name = module_name;
    this.counter = counter;
    this.trail = trail;
    this.scope = scope;
    this.typecheck = typecheck;
  }
}

export class Module extends $CustomType {
  constructor(name, alias, exposing) {
    super();
    this.name = name;
    this.alias = alias;
    this.exposing = exposing;
  }
}

export class UnificationError extends $CustomType {
  constructor(expected, found) {
    super();
    this.expected = expected;
    this.found = found;
  }
}

export class UnknownVariable extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

export class CircularType extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

export class Inference extends $CustomType {
  constructor(type_, inferences, aliases) {
    super();
    this.type_ = type_;
    this.inferences = inferences;
    this.aliases = aliases;
  }
}

export class TypeAlias extends $CustomType {
  constructor(variables, target) {
    super();
    this.variables = variables;
    this.target = target;
  }
}

export class IntType extends $CustomType {}

export class FloatType extends $CustomType {}

export class StringType extends $CustomType {}

export class BoolType extends $CustomType {}

export class NilType extends $CustomType {}

export class ListType extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class TupleType extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class FunctionType extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class CustomType extends $CustomType {
  constructor(module, name, args) {
    super();
    this.module = module;
    this.name = name;
    this.args = args;
  }
}

export class TypeVariable extends $CustomType {
  constructor(name) {
    super();
    this.name = name;
  }
}

export class ResultType extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class OptionType extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class IntLiteral extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class FloatLiteral extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class StringLiteral extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class BoolLiteral extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class NilLiteral extends $CustomType {}

export class Variable extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class FieldAccess extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class FunctionCall extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class Case extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class Let extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class Lambda extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class List extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Tuple extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Record extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class RecordUpdate extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class BinaryOp extends $CustomType {
  constructor($0, $1, $2) {
    super();
    this[0] = $0;
    this[1] = $1;
    this[2] = $2;
  }
}

export class UnaryOp extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class Pipe extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class VariablePattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class IntPattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class FloatPattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class StringPattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class BoolPattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class NilPattern extends $CustomType {}

export class ListPattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class TuplePattern extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class ConstructorPattern extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class AsPattern extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}

export class DiscardPattern extends $CustomType {}

export class ExpressionDetails extends $CustomType {
  constructor(expression, annotation, imports) {
    super();
    this.expression = expression;
    this.annotation = annotation;
    this.imports = imports;
  }
}

class Expression extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class NotExposed extends $CustomType {}

export class Exposed extends $CustomType {}

export class ExposedConstructors extends $CustomType {}

export class Declaration extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Comment extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class ModuleDocs extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Block extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class Group extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}

export class DeclarationDetails extends $CustomType {
  constructor(name, exposed, imports, docs, to_body) {
    super();
    this.name = name;
    this.exposed = exposed;
    this.imports = imports;
    this.docs = docs;
    this.to_body = to_body;
  }
}

export class DeclarationBody extends $CustomType {
  constructor(declaration, additional_imports, warning) {
    super();
    this.declaration = declaration;
    this.additional_imports = additional_imports;
    this.warning = warning;
  }
}

export class Warning extends $CustomType {
  constructor(declaration, warning) {
    super();
    this.declaration = declaration;
    this.warning = warning;
  }
}

export class FunctionDecl extends $CustomType {
  constructor(name, args, return_type, body) {
    super();
    this.name = name;
    this.args = args;
    this.return_type = return_type;
    this.body = body;
  }
}

export class TypeDecl extends $CustomType {
  constructor(name, vars, constructors) {
    super();
    this.name = name;
    this.vars = vars;
    this.constructors = constructors;
  }
}

export class TypeAliasDecl extends $CustomType {
  constructor(name, vars, type_) {
    super();
    this.name = name;
    this.vars = vars;
    this.type_ = type_;
  }
}

export class ConstDecl extends $CustomType {
  constructor(name, type_, value) {
    super();
    this.name = name;
    this.type_ = type_;
    this.value = value;
  }
}

export function start_index(module_name) {
  return new Index(module_name, 0, toList([]), $set.new$(), true);
}

export function next(index) {
  let mod_name = index.module_name;
  let counter = index.counter;
  let trail = index.trail;
  let scope = index.scope;
  let check = index.typecheck;
  return new Index(mod_name, counter + 1, trail, scope, check);
}

export function dive(index) {
  let mod_name = index.module_name;
  let counter = index.counter;
  let trail = index.trail;
  let scope = index.scope;
  let check = index.typecheck;
  return new Index(mod_name, 0, listPrepend(counter, trail), scope, check);
}

export function get_name(index, base_name) {
  let $ = index.trail;
  if ($ instanceof $Empty) {
    let $1 = index.counter;
    if ($1 === 0) {
      return base_name;
    } else {
      let counter = $1;
      let trail = $;
      let _block;
      let _pipe = $list.reverse(listPrepend(counter, trail));
      let _pipe$1 = $list.map(_pipe, (n) => { return "_" + $int.to_string(n); });
      _block = $string.join(_pipe$1, "");
      let suffix = _block;
      return base_name + suffix;
    }
  } else {
    let counter = index.counter;
    let trail = $;
    let _block;
    let _pipe = $list.reverse(listPrepend(counter, trail));
    let _pipe$1 = $list.map(_pipe, (n) => { return "_" + $int.to_string(n); });
    _block = $string.join(_pipe$1, "");
    let suffix = _block;
    return base_name + suffix;
  }
}

/**
 * Helper to create expressions that properly dive into the index
 */
export function expression(builder) {
  return new Expression((index) => { return builder(dive(index)); });
}

/**
 * Extract details from an expression given an index
 */
export function to_expression_details(expr, index) {
  let builder = expr[0];
  return builder(index);
}

/**
 * Create an expression with no imports and inferred type
 */
export function simple_expression(expr, type_) {
  return new Expression(
    (_) => {
      return new ExpressionDetails(
        expr,
        new Ok(new Inference(type_, $dict.new$(), $dict.new$())),
        toList([]),
      );
    },
  );
}

/**
 * Create an expression with unknown type (to be inferred)
 */
export function untyped_expression(expr) {
  return new Expression(
    (_) => {
      return new ExpressionDetails(
        expr,
        new Error(toList([new UnknownVariable("untyped")])),
        toList([]),
      );
    },
  );
}

/**
 * Merge two sets of imports
 */
export function merge_imports(imports1, imports2) {
  let _pipe = $list.append(imports1, imports2);
  return $list.unique(_pipe);
}
