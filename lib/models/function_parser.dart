import 'extended_string.dart';
import 'graphql_function.dart';
import 'graphql_parameter.dart';

class FunctionParser {
  const FunctionParser(this.functionType, this.functionLiterals);

  final String functionType;
  final List<String> functionLiterals;

  List<GraphQLParameter> _extractParams(String? paramsLiteral) {
    if (paramsLiteral != null) {
      final rawParams = paramsLiteral.split(',').map((e) => e.trim()).toList();

      final parsedParams = rawParams.map((param) {
        final clean = param.replaceAll(RegExp(r'[(]|[)]'), '').paramMetadata;
        return GraphQLParameter(clean[0], type: clean[1]);
      }).toList();

      return parsedParams;
    }

    return const [];
  }

  List<GraphQLFunction> get function {
    return functionLiterals.map<GraphQLFunction>((literal) {
      final paramsExp = RegExp(r'\(([^\)]+)\)');

      final remainingLiterals = literal.replaceAll(paramsExp, '').paramMetadata;
      final params = _extractParams(paramsExp.stringMatch(literal));

      return GraphQLFunction(
        functionType,
        remainingLiterals[0],
        params,
        remainingLiterals[1],
      );
    }).toList();
  }
}
