import 'models/extracted_nodes.dart';
import 'models/factory_type.dart';
import 'models/function_parser.dart';
import 'models/graphql_fragment.dart';
import 'models/graphql_function.dart';
import 'models/graphql_parameter.dart';

class TypeExtractor {
  const TypeExtractor._();

  static TypeExtractor instance = TypeExtractor._();

  /// identifica el inicio de un tipo
  RegExp get _initTypeExp => RegExp('(type.+{)');

  /// identifica el cierre de un tipo
  RegExp get _closeExp => RegExp('(})');

  /// obtiene una lista de tipos
  List<List<String>> _typesFrom(List<String> literals) {
    /// manda una lista de tipos, obtenidos de la lista de nodos extraídos
    return _getTypes(literals).map((e) => e.type).toList();
  }

  /// se utiliza principalmente para hacer recursión en las literales y
  /// recuperar los nodos entre cada iteración.
  ///
  /// los nodos están compuestos por literales válidas y un tipo.
  List<ExtractedNodes> _getTypes(
    List<String> literals, [
    List<ExtractedNodes> nodes = const [],
  ]) {
    if (literals.isEmpty) return nodes;

    /// si la literal inicial no contiene un formato válido, se corta de la
    /// lista de literales y se regresa la misma función con el remanente.
    ///
    /// esta validación permite obtener literales válidas que sean fácilmente
    /// identificables para generar un tipo.
    if (!_initTypeExp.hasMatch(literals[0])) {
      final newLiterals = literals.getRange(1, literals.length);
      return _getTypes(newLiterals.toList(), nodes);
    }

    final node = _extractNode(literals);

    /// mediante el regreso de la misma función con los nodos generados y el
    /// nuevo es como se genera el tipo.
    return _getTypes(node.literals, [...nodes, node]);
  }

  /// obtiene un tipo mediante la identificación de un inicio y un cierre
  /// válido.
  ExtractedNodes _extractNode(List<String> literals) {
    /// encuentra el índice de un inicio válido.
    final start = literals.indexWhere((l) => _initTypeExp.hasMatch(l));

    /// encuentra el índice de un cierre válido.
    final end = literals.indexWhere((l) => _closeExp.hasMatch(l)) + 1;

    /// obtiene un tipo a través de los índices.
    final type = literals.getRange(start, end).toList();
    literals.removeRange(start, end);

    /// regresa un nodo conformado por el tipo y la literal después de haber
    /// extraído los elementos que conforman la tipo.
    return ExtractedNodes(type, literals);
  }

  List<Object> parsedTypesFrom(List<String> literals) {
    List<Object> types = [];

    _rawTypeFrom(literals).forEach((type) {
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

  List<Object> _rawTypeFrom(List<String> literals) {
    return _typesFrom(literals).map((t) {
      final identifiedType = FactoryType(t);
      final cast = identifiedType.cast;

      final literals = t.getRange(1, t.length - 1).toList();

      if (cast.isFunctionType) {
        return FunctionParser(identifiedType.name, literals).function;
      }

      final attributes = literals.map((literal) {
        return GraphQLParameter(literal.split(':')[0]);
      });

      return GraphQLFragment(t[0].split(' ')[1], attributes.toList());
    }).toList();
  }
}
