import 'dart:async';

import 'package:analytics_annotations/analytics_annotations.dart';
import 'package:analytics_builder/src/state.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class MixinBuilder extends GeneratorForAnnotation<AnalyticBloc> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    final blocName = _getName(element);
    BuildState buildState = BuildState();

    State state = buildState.states[blocName];

    if (state.mixinGenerated == true) {
      buildState.states[blocName] = null;
      return null;
    } else {
      state.mixinGenerated = true;
      buildState.states[blocName] = state;
      return '''
  mixin ${blocName}BlocAnalytics
    on Bloc<${blocName}Event, ${blocName}State> {
  
  final AnalyticsProvider analyticsProvider = Modular.get<AnalyticsProvider>();
  
  @override
  void onTransition(
      Transition<${blocName}Event, ${blocName}State> transition) {
    _analitycs(transition);

    super.onTransition(transition);
  }

  void _analitycs(
      Transition<${blocName}Event, ${blocName}State> transition) {
      ${_dispatch(state)}
  }
}
''';
    }
  }

  _getName(Element element) {
    return element.name.replaceAll("Event", "").replaceAll("State", "");
  }

  _dispatch(State state) {
    String buffer = "";
    if (state.hasState == true) {
      buffer +=
          "analyticsProvider.sendState(payload: _dispatchState(transition.nextState));\n";
    }
    if (state.hasActions == true) {
      buffer +=
          "analyticsProvider.sendAction(payload: _dispatchEvent(transition.event));\n";
    }

    return buffer;
  }
}
