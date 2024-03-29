import 'graphql_parameter.dart';
import 'graphql_type.dart';

class GraphQLFunction extends GraphQLType {
  GraphQLFunction(
    this.functionType,
    String name,
    this.params,
    this._result,
    this.validFragments,
  ) : super(name);

  final String functionType;
  final List<GraphQLParameter> params;
  final String _result;
  final List<String> validFragments;

  String get result => _result.replaceAll(RegExp(r'(!|\[|\])'), '');

  String get _functionParamsLiteral {
    final literal = params.map((p) => '\$${p.name}: ${p.type}').join(', ');
    return literal.isEmpty ? '' : '($literal)';
  }

  String get _paramsLiteral {
    final literal = params.map((p) => '${p.name}: \$${p.name}').join(', ');
    return literal.isEmpty ? '' : '($literal)';
  }

  String get function {
    final validType = validFragments.contains(result);
    final typeLiteral = validType ? ' {\n    ...$result\n  }' : '';

    return '${functionType.toLowerCase()} $name$_functionParamsLiteral {\n  $name$_paramsLiteral$typeLiteral\n}';
  }

  Map<String, dynamic> toMap() {
    return {
      'functionType': functionType,
      'name': name,
      'params': params.map((p) => p.toMap()).toList(),
      'result': result
    };
  }
}
