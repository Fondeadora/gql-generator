import 'dart:io';

/// se encarga de leer el archivo ubicado en la ruta indicada.
class SchemaReader {
  const SchemaReader(this.filePath);

  final String filePath;

  /// regresa una lista de {type} válidos.
  Future<List<String>> readType() async {
    final file = File(filePath);
    final fileReader = await file.readAsLines();

    /// filtra todas la líneas que no sean vacías, o inicien con los
    /// siguientes símbolos: {"}, {#}. normalmente, son símbolos son para
    /// indicar comentarios.
    final filtered = fileReader.map((l) => l.trim()).where((line) {
      if (line.isNotEmpty) {
        return line[0] != '"' && line[0] != '#';
      }

      return line.isNotEmpty;
    });

    return filtered.toList();
  }
}
