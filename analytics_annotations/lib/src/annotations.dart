class AnalyticBloc {
  final Map<String, String> properties;
  const AnalyticBloc({this.properties});
}

class AnalyticState {
  final String id;
  final Map<String, String> properties;
  final Map<String, String> dynamicProperties;

  const AnalyticState(this.id, {this.properties, this.dynamicProperties});
}

class AnalyticAction {
  final String id;
  final Map<String, String> properties;
  final Map<String, String> dynamicProperties;

  const AnalyticAction(this.id, {this.properties, this.dynamicProperties});
}
