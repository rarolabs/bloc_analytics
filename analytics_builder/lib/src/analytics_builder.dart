import 'dart:async';

import 'package:analytics_annotations/analytics_annotations.dart';
import 'package:analytics_builder/src/state.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'factory_visitor.dart';

class AnalyticsBuilder extends GeneratorForAnnotation<AnalyticBloc> {
  @override
  FutureOr<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    FactoryVisitor visitor = FactoryVisitor(element);
    BuildState buildState = BuildState();
    State state = buildState.states[visitor.blocName] ?? State();
    state.bloc = state.bloc ?? visitor.blocName;

    switch (visitor.kind) {
      case Kind.State:
        state.hasState = true;
        break;
      case Kind.Event:
        state.hasActions = true;
    }

    buildState.states[visitor.blocName] = state;

    return visitor.dartCode;
  }
}
