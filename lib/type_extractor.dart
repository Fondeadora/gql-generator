import 'models/extracted_nodes.dart';
import 'models/factory_type.dart';
import 'models/function_parser.dart';
import 'models/graphql_fragment.dart';
import 'models/graphql_function.dart';
import 'models/graphql_parameter.dart';

class TypeExtractor {
  const TypeExtractor._();

  static TypeExtractor instance = TypeExtractor._();

  RegExp get _initTypeExp => RegExp('(type.+{)');

  RegExp get _closeExp => RegExp('(})');

  /// regresa una lista con los {token} en forma de lista de cadena
  ///
  /// esto quiere decir que cada lista de cadena representa un {token} para
  /// formar un {type} válido
  ///
  /// se recupera de esta forma para poder sacar los parámetros de las
  /// consultas y las mutaciones
  List<List<String>> _typesFrom(List<String> tokens) {
    return _getTypes(tokens).map((e) => e.type).toList();
  }

  List<ExtractedNodes> _getTypes(
    List<String> tokens, [
    List<ExtractedNodes> nodes = const [],
  ]) {
    if (tokens.isEmpty) return nodes;

    /// si es diferente del inicio común de los {type}: `type <objeto> {`;
    /// quita el {token} de la lista de {token}
    ///
    /// sirve como filtro para quitar {token} inválidos
    if (!_initTypeExp.hasMatch(tokens[0])) {
      final newTokens = tokens.getRange(1, tokens.length);
      return _getTypes(newTokens.toList(), nodes);
    }

    /// en caso de que el {token} sea válido: se extraer el {node} de la
    /// lista completa de {token} envíados
    final node = _extractNode(tokens);

    return _getTypes(

        /// ahora, los {token} a evaluar no contienen los {token} extraídos
        node.tokens,

        /// en su lugar, se adjunta a la lista de nodos extraídos, el nodo
        /// con información de los últimos {token} recuperados, que son los
        /// mismos que generan un {type} válido
        [...nodes, node]);
  }

  ExtractedNodes _extractNode(List<String> tokens) {
    /// encuentra el índice de un inicio válido
    final start = tokens.indexWhere((l) => _initTypeExp.hasMatch(l));

    /// encuentra el índice de un cierre válido
    final end = tokens.indexWhere((l) => _closeExp.hasMatch(l)) + 1;

    /// obtiene un tipo a través de los índices
    final type = tokens.getRange(start, end).toList();

    /// finalmente, eliminar los {token} recuperados para volver a evaluar
    /// los otros {type} válidos
    tokens.removeRange(start, end);

    /// regresa un nodo conformado por el {type} recuperado y los {token} aún
    /// no procesados sin la información del {type} actual
    return ExtractedNodes(type, tokens);
  }

  /// recibe una lista de {token}.
  ///
  /// cada token es una línea filtrada y cortada del {schema} de {GraphQL}.
  List<Object> parsedTypesFrom(List<String> tokens) {
    List<Object> types = [];

    _rawTypeFrom(tokens).forEach((type) {
      if (type is List<GraphQLFunction>) {
        for (GraphQLFunction functionType in type) {
          types.add(functionType);
        }

        return;
      }

      types.add(type);
    });

    return types;
  }

  List<Object> _rawTypeFrom(List<String> tokens) {
    final types = _typesFrom(tokens);

    final validFragments = types
        .where((t) => Type(t).name == 'Fragment')
        .map((e) => e[0].split(' ')[1])
        .toList();

    return types.map((t) {
      /// cada elemento {t} no es nada más que una lista con {token} válidos
      /// para generar un {type}
      final identifiedType = Type(t);

      /// se encarga de designar que tipo de enumerador {ObjectType} es
      final cast = identifiedType.cast;

      /// esta lista de elementos puede contener los parámetros necesarios
      /// para una mutación o consulta; o, los atributos de un fragmento
      final elements = t.getRange(1, t.length - 1).toList();

      /// mediante el {cast} se determina cual de estos dos {type} es:
      /// - consulta o mutación, o
      /// - fragmento
      if (cast.isFunctionType) {
        return FunctionParser(identifiedType.name, elements).function;
      }

      final attributes = elements.map((attribute) {
        final splittedAttribute = attribute.split(':');

        return GraphQLParameter(
          splittedAttribute[0],
          splittedAttribute[1],
          cast,
        );
      });

      return GraphQLFragment(
        t[0].split(' ')[1],
        attributes.toList(),
        validFragments,
      );
    }).toList();
  }
}
