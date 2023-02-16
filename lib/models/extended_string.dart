extension GraphQLParameterParsing on String? {
  List<String> get paramMetadata {
    final splitted = this!.split(':').map((e) => e.trim()).toList();
    return splitted;
  }
}
