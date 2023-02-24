import 'package:gql_generator/models/object_cast.dart';

class GraphQLParameter {
  GraphQLParameter(this.name, this._type, this.cast);

  final String name;
  final String _type;
  final ObjectCast cast;

  String get type {
    if (cast.isFunctionType) return _type.trim();
    return _type.trim().replaceAll(RegExp(r'(!|\[|\])'), '');
  }

  Map<String, String> toMap() {
    return {'name': name, 'type': type};
  }
}
