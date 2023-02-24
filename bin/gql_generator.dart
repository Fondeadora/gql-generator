import 'package:args/args.dart';
import 'package:gql_generator/gql_generator.dart';

void main(List<String> arguments) async {
  final stopwatch = Stopwatch()..start();

  try {
    /// configura como opción el parámetro {path}
    final parser = ArgParser()..addOption('path', abbr: 'p', mandatory: true);

    /// configura en el {parser} la información de los argumentos
    final result = parser.parse(arguments);

    print('📖 leyendo {schema.graphql}');

    /// lee el archivo envíado en el {path}
    final reader = SchemaReader(result['path']);
    final tokens = await reader.readType();

    print('🚜 extrayendo objetos {type} del esquema');

    final extractor = TypeExtractor.instance;
    final types = extractor.parsedTypesFrom(tokens);

    print('📝 generando archivos');

    /// genera los tipos en la ruta del argumento
    final generator = TypeGenerator(types, result['path'].split('/')[0]);
    await generator.writeTypes();

    print('🔥 archivo {graphql} generados');

    stopwatch.stop();
    final milliseconds = stopwatch.elapsed.inMilliseconds;
    print('🎯 ejecutado en $milliseconds millisegundos');
  } catch (e) {
    print(e);
    print('⚰️ algo salió mal');
  }
}
