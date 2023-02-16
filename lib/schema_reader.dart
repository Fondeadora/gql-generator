import 'dart:io';

class SchemaReader {
  const SchemaReader(this.filePath);

  final String filePath;

  Future<List<String>> readType() async {
    final file = File(filePath);
    final fileReader = await file.readAsLines();

    final filtered = fileReader.map((l) => l.trim()).where((line) {
      if (line.isNotEmpty) {
        return line[0] != '"' && line[0] != '#';
      }

      return line.isNotEmpty;
    });

    return filtered.toList();
  }
}
