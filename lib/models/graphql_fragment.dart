import 'graphql_parameter.dart';
import 'graphql_type.dart';

class GraphQLFragment extends GraphQLType {
  GraphQLFragment(String name, this._attributes) : super(name);

  final List<GraphQLParameter> _attributes;

  String get attributes => _attributes.map((a) => a.name).join('\n  ');

  String get literal {
    return 'fragment $name on $name {\n  $attributes\n}';
  }
}
