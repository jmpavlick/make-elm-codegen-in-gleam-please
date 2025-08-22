import * as $float from "../../gleam_stdlib/gleam/float.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import { None } from "../../gleam_stdlib/gleam/option.mjs";
import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import { CustomType as $CustomType } from "../gleam.mjs";
import * as $c from "../gleam_codegen/internal/compiler.mjs";

export class Context extends $CustomType {
  constructor(precedence, indent) {
    super();
    this.precedence = precedence;
    this.indent = indent;
  }
}

/**
 * Top-level context (no precedence constraints)
 */
export function top_context() {
  return new Context(0, 0);
}

/**
 * Bottom context (maximum precedence)
 */
export function bottom_context() {
  return new Context(100, 0);
}

/**
 * Render a declaration to source code
 */
export function render_declaration(decl) {
  if (decl instanceof $c.Declaration) {
    let details = decl[0];
    return "// TODO: Implement declaration rendering for " + details.name;
  } else if (decl instanceof $c.Comment) {
    let text = decl[0];
    return "// " + text;
  } else if (decl instanceof $c.ModuleDocs) {
    let text = decl[0];
    return "/// " + text;
  } else if (decl instanceof $c.Block) {
    let text = decl[0];
    return text;
  } else {
    let declarations = decl[0];
    let _pipe = $list.map(declarations, render_declaration);
    return $string.join(_pipe, "\n\n");
  }
}

/**
 * Render a complete file to source code  
 * Note: This will be implemented when we integrate with the main File type
 */
export function render_file_placeholder(module_name, declarations) {
  let _block;
  let $ = $list.is_empty(module_name);
  if ($) {
    _block = "";
  } else {
    _block = ("// Module: " + $string.join(module_name, ".")) + "\n\n";
  }
  let module_comment = _block;
  let _block$1;
  let _pipe = $list.map(declarations, render_declaration);
  _block$1 = $string.join(_pipe, "\n\n");
  let declarations_str = _block$1;
  return module_comment + declarations_str;
}

/**
 * Get operator precedence for proper parenthesization
 * 
 * @ignore
 */
function get_operator_precedence(op) {
  if (op === "||") {
    return 2;
  } else if (op === "&&") {
    return 3;
  } else if (op === "==") {
    return 4;
  } else if (op === "!=") {
    return 4;
  } else if (op === "<") {
    return 4;
  } else if (op === ">") {
    return 4;
  } else if (op === "<=") {
    return 4;
  } else if (op === ">=") {
    return 4;
  } else if (op === "<>") {
    return 5;
  } else if (op === "+") {
    return 6;
  } else if (op === "-") {
    return 6;
  } else if (op === "*") {
    return 7;
  } else if (op === "/") {
    return 7;
  } else if (op === "%") {
    return 7;
  } else {
    return 10;
  }
}

/**
 * Escape special characters in strings
 * 
 * @ignore
 */
function escape_string(s) {
  let _pipe = s;
  let _pipe$1 = $string.replace(_pipe, "\\", "\\\\");
  let _pipe$2 = $string.replace(_pipe$1, "\"", "\\\"");
  let _pipe$3 = $string.replace(_pipe$2, "\n", "\\n");
  let _pipe$4 = $string.replace(_pipe$3, "\t", "\\t");
  return $string.replace(_pipe$4, "\r", "\\r");
}

/**
 * Render a pattern to source code
 */
export function render_pattern(pattern) {
  if (pattern instanceof $c.VariablePattern) {
    let name = pattern[0];
    return name;
  } else if (pattern instanceof $c.IntPattern) {
    let value = pattern[0];
    return $int.to_string(value);
  } else if (pattern instanceof $c.FloatPattern) {
    let value = pattern[0];
    return $float.to_string(value);
  } else if (pattern instanceof $c.StringPattern) {
    let value = pattern[0];
    return ("\"" + escape_string(value)) + "\"";
  } else if (pattern instanceof $c.BoolPattern) {
    let $ = pattern[0];
    if ($) {
      return "True";
    } else {
      return "False";
    }
  } else if (pattern instanceof $c.NilPattern) {
    return "Nil";
  } else if (pattern instanceof $c.ListPattern) {
    let patterns = pattern[0];
    let _block;
    let _pipe = $list.map(patterns, render_pattern);
    _block = $string.join(_pipe, ", ");
    let patterns_str = _block;
    return ("[" + patterns_str) + "]";
  } else if (pattern instanceof $c.TuplePattern) {
    let patterns = pattern[0];
    let _block;
    let _pipe = $list.map(patterns, render_pattern);
    _block = $string.join(_pipe, ", ");
    let patterns_str = _block;
    return ("#(" + patterns_str) + ")";
  } else if (pattern instanceof $c.ConstructorPattern) {
    let name = pattern[0];
    let patterns = pattern[1];
    let $ = $list.is_empty(patterns);
    if ($) {
      return name;
    } else {
      let _block;
      let _pipe = $list.map(patterns, render_pattern);
      _block = $string.join(_pipe, ", ");
      let patterns_str = _block;
      return ((name + "(") + patterns_str) + ")";
    }
  } else if (pattern instanceof $c.AsPattern) {
    let pattern$1 = pattern[0];
    let name = pattern[1];
    return (render_pattern(pattern$1) + " as ") + name;
  } else {
    return "_";
  }
}

/**
 * Render a GleamExpression to source code
 */
export function render_expression(expr, context) {
  if (expr instanceof $c.IntLiteral) {
    let value = expr[0];
    return $int.to_string(value);
  } else if (expr instanceof $c.FloatLiteral) {
    let value = expr[0];
    return $float.to_string(value);
  } else if (expr instanceof $c.StringLiteral) {
    let value = expr[0];
    return ("\"" + escape_string(value)) + "\"";
  } else if (expr instanceof $c.BoolLiteral) {
    let $ = expr[0];
    if ($) {
      return "True";
    } else {
      return "False";
    }
  } else if (expr instanceof $c.NilLiteral) {
    return "Nil";
  } else if (expr instanceof $c.Variable) {
    let name = expr[0];
    return name;
  } else if (expr instanceof $c.FieldAccess) {
    let expr$1 = expr[0];
    let field = expr[1];
    return (render_expression(expr$1, context) + ".") + field;
  } else if (expr instanceof $c.FunctionCall) {
    let func = expr[0];
    let args = expr[1];
    let func_str = render_expression(func, context);
    let _block;
    let _pipe = $list.map(
      args,
      (arg) => { return render_expression(arg, context); },
    );
    _block = $string.join(_pipe, ", ");
    let args_str = _block;
    return ((func_str + "(") + args_str) + ")";
  } else if (expr instanceof $c.Case) {
    let subject = expr[0];
    let branches = expr[1];
    let subject_str = render_expression(subject, top_context());
    let _block;
    let _pipe = $list.map(
      branches,
      (branch) => {
        let pattern;
        let expr$1;
        pattern = branch[0];
        expr$1 = branch[1];
        let pattern_str = render_pattern(pattern);
        let expr_str = render_expression(expr$1, top_context());
        return (("  " + pattern_str) + " -> ") + expr_str;
      },
    );
    _block = $string.join(_pipe, "\n");
    let branches_str = _block;
    return ((("case " + subject_str) + " {\n") + branches_str) + "\n}";
  } else if (expr instanceof $c.Let) {
    let bindings = expr[0];
    let body = expr[1];
    let _block;
    let _pipe = $list.map(
      bindings,
      (binding) => {
        let pattern;
        let expr$1;
        pattern = binding[0];
        expr$1 = binding[1];
        let pattern_str = render_pattern(pattern);
        let expr_str = render_expression(expr$1, top_context());
        return (("  let " + pattern_str) + " = ") + expr_str;
      },
    );
    _block = $string.join(_pipe, "\n");
    let bindings_str = _block;
    let body_str = render_expression(body, top_context());
    return ((("{\n" + bindings_str) + "\n  ") + body_str) + "\n}";
  } else if (expr instanceof $c.Lambda) {
    let args = expr[0];
    let body = expr[1];
    let _block;
    let _pipe = $list.map(args, render_pattern);
    _block = $string.join(_pipe, ", ");
    let args_str = _block;
    let body_str = render_expression(body, top_context());
    return ((("fn(" + args_str) + ") { ") + body_str) + " }";
  } else if (expr instanceof $c.List) {
    let items = expr[0];
    let _block;
    let _pipe = $list.map(
      items,
      (item) => { return render_expression(item, top_context()); },
    );
    _block = $string.join(_pipe, ", ");
    let items_str = _block;
    return ("[" + items_str) + "]";
  } else if (expr instanceof $c.Tuple) {
    let items = expr[0];
    let _block;
    let _pipe = $list.map(
      items,
      (item) => { return render_expression(item, top_context()); },
    );
    _block = $string.join(_pipe, ", ");
    let items_str = _block;
    return ("#(" + items_str) + ")";
  } else if (expr instanceof $c.Record) {
    let fields = expr[0];
    let _block;
    let _pipe = $list.map(
      fields,
      (field) => {
        let name;
        let value;
        name = field[0];
        value = field[1];
        return (name + ": ") + render_expression(value, top_context());
      },
    );
    _block = $string.join(_pipe, ", ");
    let fields_str = _block;
    let $ = $list.is_empty(fields);
    if ($) {
      return "{}";
    } else {
      return ("{ " + fields_str) + " }";
    }
  } else if (expr instanceof $c.RecordUpdate) {
    let base = expr[0];
    let updates = expr[1];
    let base_str = render_expression(base, context);
    let _block;
    let _pipe = $list.map(
      updates,
      (update) => {
        let field;
        let value;
        field = update[0];
        value = update[1];
        return (field + ": ") + render_expression(value, top_context());
      },
    );
    _block = $string.join(_pipe, ", ");
    let updates_str = _block;
    let $ = $list.is_empty(updates);
    if ($) {
      return base_str;
    } else {
      return ((("{ " + base_str) + " with ") + updates_str) + " }";
    }
  } else if (expr instanceof $c.BinaryOp) {
    let op = expr[0];
    let left = expr[1];
    let right = expr[2];
    let op_precedence = get_operator_precedence(op);
    let needs_parens = context.precedence > op_precedence;
    let child_context = new Context(op_precedence, context.indent);
    let left_str = render_expression(left, child_context);
    let right_str = render_expression(right, child_context);
    let expr_str = (((left_str + " ") + op) + " ") + right_str;
    if (needs_parens) {
      return ("(" + expr_str) + ")";
    } else {
      return expr_str;
    }
  } else if (expr instanceof $c.UnaryOp) {
    let op = expr[0];
    let expr$1 = expr[1];
    let expr_str = render_expression(expr$1, bottom_context());
    return op + expr_str;
  } else {
    let left = expr[0];
    let right = expr[1];
    let left_str = render_expression(left, new Context(1, context.indent));
    let right_str = render_expression(right, new Context(0, context.indent));
    return (left_str + " |> ") + right_str;
  }
}

/**
 * Convert an expression to a Gleam source code string
 */
export function expression_to_string(expr) {
  let index = $c.start_index(new None());
  let details = $c.to_expression_details(expr, index);
  return render_expression(details.expression, top_context());
}

/**
 * Render a Gleam type to source code
 */
export function render_type(type_) {
  if (type_ instanceof $c.IntType) {
    return "Int";
  } else if (type_ instanceof $c.FloatType) {
    return "Float";
  } else if (type_ instanceof $c.StringType) {
    return "String";
  } else if (type_ instanceof $c.BoolType) {
    return "Bool";
  } else if (type_ instanceof $c.NilType) {
    return "Nil";
  } else if (type_ instanceof $c.ListType) {
    let inner = type_[0];
    return ("List(" + render_type(inner)) + ")";
  } else if (type_ instanceof $c.TupleType) {
    let types = type_[0];
    let _block;
    let _pipe = $list.map(types, render_type);
    _block = $string.join(_pipe, ", ");
    let types_str = _block;
    return ("#(" + types_str) + ")";
  } else if (type_ instanceof $c.FunctionType) {
    let args = type_[0];
    let return$ = type_[1];
    let _block;
    let _pipe = $list.map(args, render_type);
    _block = $string.join(_pipe, ", ");
    let args_str = _block;
    return (("fn(" + args_str) + ") -> ") + render_type(return$);
  } else if (type_ instanceof $c.CustomType) {
    let module = type_.module;
    let name = type_.name;
    let args = type_.args;
    let _block;
    let $ = $list.is_empty(module);
    if ($) {
      _block = "";
    } else {
      _block = $string.join(module, ".") + ".";
    }
    let module_prefix = _block;
    let _block$1;
    let $1 = $list.is_empty(args);
    if ($1) {
      _block$1 = "";
    } else {
      _block$1 = ("(" + $string.join($list.map(args, render_type), ", ")) + ")";
    }
    let args_str = _block$1;
    return (module_prefix + name) + args_str;
  } else if (type_ instanceof $c.TypeVariable) {
    let name = type_.name;
    return name;
  } else if (type_ instanceof $c.ResultType) {
    let ok = type_[0];
    let error = type_[1];
    return ((("Result(" + render_type(ok)) + ", ") + render_type(error)) + ")";
  } else {
    let inner = type_[0];
    return ("Option(" + render_type(inner)) + ")";
  }
}
