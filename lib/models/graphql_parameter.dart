class GraphQLParameter {
  const GraphQLParameter(this.name, {this.type});

  final String name;
  final String? type;

  Map<String, String> toMap() {
    final baseMap = {'name': name};

    if (type != null) return {...baseMap, 'type': type!};
    return baseMap;
  }
}
