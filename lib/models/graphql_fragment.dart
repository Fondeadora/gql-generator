import 'graphql_parameter.dart';
import 'graphql_type.dart';

class GraphQLFragment extends GraphQLType {
  GraphQLFragment(String name, this._attributes, this.validFragments)
      : super(name);

  final List<GraphQLParameter> _attributes;
  final List<String> validFragments;

  String get attributes {
    return _attributes.map((a) {
      final validType = validFragments.contains(a.type);
      final typeLiteral = validType ? ' {\n    ...${a.type}\n  }' : '';

      return '${a.name}$typeLiteral';
    }).join('\n  ');
  }

  String get type {
    return 'fragment $name on $name {\n  $attributes\n}';
  }
}
