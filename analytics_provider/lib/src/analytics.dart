abstract class AnalyticsProvider {
  final Map<String, String> globals;

  AnalyticsProvider(this.globals);

  Future<void> trackAction(String action, {Map<String, String> payload});
  Future<void> trackState(String action, {Map<String, String> payload});

  Future<void> sendState({Map<String, String> payload}) {
    if (payload != null) {
      return trackState(payload["id"], payload: payload);
    }
    return null;
  }

  Future<void> sendAction({Map<String, String> payload}) {
    if (payload != null) {
      return trackAction(payload["id"], payload: payload);
    }
    return null;
  }

  void setGlobal(String key, String value) {
    globals[key] = value;
  }
}
