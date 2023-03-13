import 'package:gql_generator/models/object_cast.dart';

import 'extended_string.dart';
import 'graphql_function.dart';
import 'graphql_parameter.dart';

class FunctionParser {
  const FunctionParser(this.functionType, this.tokens, this.validFragments);

  final String functionType;
  final List<String> tokens;
  final List<String> validFragments;

  List<GraphQLParameter> _extractParams(String? paramsToken) {
    if (paramsToken != null) {
      final rawParams = paramsToken.split(',').map((e) => e.trim()).toList();

      final parsedParams = rawParams.map((param) {
        /// quita los paréntesis y los separa por el nombre del objeto
        /// y el objeto
        final clean = param.replaceAll(RegExp(r'[(]|[)]'), '').paramMetadata;
        return GraphQLParameter(clean[0], clean[1], ObjectCast.functionType);
      }).toList();

      return parsedParams;
    }

    return const [];
  }

  List<GraphQLFunction> get function {
    return tokens.map<GraphQLFunction>((token) {
      final paramsExp = RegExp(r'\(([^\)]+)\)');

      /// devuelve el nombre de la función y el objeto de retorno
      final remainingTokens = token.replaceAll(paramsExp, '').paramMetadata;

      /// obtiene una lista de parámetros, en caso de contenerlos
      final params = _extractParams(paramsExp.stringMatch(token));

      return GraphQLFunction(
        functionType,
        remainingTokens[0],
        params,
        remainingTokens[1],
        validFragments,
      );
    }).toList();
  }
}
