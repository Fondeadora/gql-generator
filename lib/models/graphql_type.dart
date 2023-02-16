class GraphQLType {
  const GraphQLType(this.name);

  final String name;

  /// utiliza el nombre del tipo como nombre del archivo en formato {camelCase}
  String get fileName {
    final exp = RegExp(r'(?<=[a-z])[A-Z]');

    return name
        .replaceAllMapped(exp, (m) => '_${m.group(0) ?? ''}')
        .toLowerCase();
  }
}
