class AnalyticSpec {
  final String id;
  final String name;
  final String bloc;
  final Map<String, String> properties;
  final Map<String, String> dynamicProperties;
  final List<String> parameters;

  AnalyticSpec(
    this.id,
    this.bloc,
    this.name, {
    this.properties,
    this.dynamicProperties,
    this.parameters,
  });

  @override
  String toString() {
    return '''
      id:$id
      bloc:$bloc
      name:$name
      properties:$properties
      dynamicProperties:$dynamicProperties
      parameters:$parameters
    ''';
  }
}
