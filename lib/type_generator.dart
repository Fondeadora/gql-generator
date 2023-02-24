import 'dart:io';

import 'models/graphql_fragment.dart';
import 'models/graphql_function.dart';

class TypeGenerator {
  TypeGenerator(this.types, this.path);

  final List<Object> types;
  final String path;

  Future<void> writeTypes() async {
    for (Object type in types) {
      if (type is GraphQLFunction) {
        final folder = type.functionType.toLowerCase();
        await _writeType(folder, type.fileName, type.function);
      }

      if (type is GraphQLFragment) {
        await _writeType('fragment', type.fileName, type.type);
      }
    }
  }

  Future<void> _writeType(String folder, String name, String literal) async {
    final directory = await Directory('$path/$folder/').create();
    final file = File('${directory.path}/$name.graphql');
    await file.writeAsString(literal);
  }
}
