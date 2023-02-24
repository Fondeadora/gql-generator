import 'graphql_parameter.dart';
import 'graphql_type.dart';

class GraphQLFragment extends GraphQLType {
  GraphQLFragment(String name, this._attributes) : super(name);

  final List<GraphQLParameter> _attributes;

  String get attributes {
    return _attributes.map((a) {
      return '${a.name} {\n    ...${a.type}\n  }';
    }).join('\n  ');
  }

  String get type {
    return 'fragment $name on $name {\n  $attributes\n}';
  }
}
