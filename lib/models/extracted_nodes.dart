class ExtractedNodes {
  const ExtractedNodes(this.type, this.literals);

  /// este atributo esta conformado por una lista de cadenas que conforman al
  /// tipo.
  ///
  /// se mantiene en una lista para facilitar su transformación.
  final List<String> type;

  /// lista de literales válidas utilizada para identificar los tipos entre cada
  /// iteración.
  final List<String> literals;

  Map<String, List<String>> toMap() {
    return {'type': type, 'literals': literals};
  }
}
