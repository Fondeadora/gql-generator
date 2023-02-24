import 'object_cast.dart';

class Type {
  const Type(this.type);

  final List<String> type;

  /// asigna un nombre al tipo, dependiendo del tipo leído en la cadena
  String get name {
    final currentType = type[0].split(' ')[1];

    if (currentType == 'Query' || currentType == 'Mutation') {
      return currentType;
    }

    return 'Fragment';
  }

  /// regresa {ObjectCast}, extraído del nombre
  ObjectCast get cast {
    if (name == 'Query' || name == 'Mutation') {
      return ObjectCast.functionType;
    }

    return ObjectCast.fragmentType;
  }
}
