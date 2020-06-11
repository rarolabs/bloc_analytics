class State {
  String bloc;
  bool hasActions;
  bool hasState;
  bool mixinGenerated;

  State({this.bloc, this.hasActions, this.hasState, this.mixinGenerated});
}

class BuildState {
  Map<String, State> states = {};
  static BuildState _instance = BuildState._internal();

  factory BuildState() {
    return _instance;
  }

  BuildState._internal();
}
