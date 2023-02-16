import 'package:args/args.dart';
import 'package:gql_generator/gql_generator.dart';

void main(List<String> arguments) async {
  /// configura como opción el parámetro {path}
  final parser = ArgParser()..addOption('path', abbr: 'p', mandatory: true);

  /// configura en el {parser} la información de los argumentos
  final result = parser.parse(arguments);

  /// lee el archivo envíado en el {path}
  final reader = SchemaReader(result['path']);
  final literals = await reader.readType();

  final extractor = TypeExtractor.instance;
  final types = extractor.parsedTypesFrom(literals);

  /// genera los tipos en la ruta del argumento
  final generator = TypeGenerator(types, result['path'].split('/')[0]);
  await generator.writeTypes();
}
