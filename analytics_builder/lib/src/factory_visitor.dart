import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:analyzer/src/dart/element/element.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

import 'analytic_spec.dart';
import 'dispatch_template.dart';

enum Kind { State, Event }

class FactoryVisitor extends SimpleElementVisitor {
  final Map<String, String> globals = {};
  final List<AnalyticSpec> specs = [];
  final Element element;
  Kind kind;
  String blocName;
  int total = 0;

  FactoryVisitor(this.element) {
    _parseBlocName(element);
    _globalProperties(element);
    this.element.visitChildren(this);
  }

  void _parseBlocName(Element element) {
    if (element.name.contains("State")) {
      kind = Kind.State;
      blocName = element.name.replaceAll("State", "");
    } else if (element.name.contains("Event")) {
      kind = Kind.Event;
      blocName = element.name.replaceAll("Event", "");
    }
  }

  void _globalProperties(Element element) {
    for (ElementAnnotationImpl annotation in element.metadata) {
      var ast = annotation.annotationAst as AnnotationImpl;
      if (ast.name?.name == "AnalyticBloc") {
        var arguments = ast.arguments?.arguments;

        if (arguments != null && arguments.isNotEmpty) {
          final properties = ast.arguments?.arguments[0] as NamedExpressionImpl;
          final elements =
              (properties.expression as SetOrMapLiteralImpl).elements;
          for (MapLiteralEntryImpl exp in elements) {
            final key = exp.key as SimpleStringLiteralImpl;
            final value = exp.value as SimpleStringLiteralImpl;
            globals[key.value] = value.value;
          }
        }
      }
    }
  }

  String get dartCode => DispatchTemplate(
          specs: specs,
          globals: globals,
          dispatchKind: kind == Kind.State ? "State" : "Event",
          blocName: blocName,
          total: total)
      .toDart();

  @override
  visitConstructorElement(ConstructorElement element) {
    total++;
    for (ElementAnnotationImpl annotation in element.metadata) {
      var ast = annotation.annotationAst as AnnotationImpl;
      if (ast.name?.name == "AnalyticAction") {
        kind = Kind.Event;
        _generate(element, ast);
      } else if (ast.name?.name == "AnalyticState") {
        kind = Kind.State;
        _generate(element, ast);
      }
    }

    return super.visitConstructorElement(element);
  }

  void _generate(ConstructorElement element, AnnotationImpl ast) {
    final id = (ast.arguments?.arguments[0] as SimpleStringLiteralImpl).value;
    final arguments = ast.arguments?.arguments;
    Map<String, String> properties = {};
    Map<String, String> dynamicProperties = {};

    if (arguments != null) {
      for (int i = 1; i < arguments.length; i++) {
        final _properties = ast.arguments?.arguments[i] as NamedExpressionImpl;
        final _elements =
            (_properties.expression as SetOrMapLiteralImpl).elements;
        final name = (_properties.name.label as SimpleIdentifierImpl).name;
        _parseMap(
            _elements, name == "properties" ? properties : dynamicProperties);
      }
    }

    final List<String> parameters =
        element.parameters.map((p) => p.displayName).toList();

    specs.add(
      AnalyticSpec(
        id,
        element.enclosingElement.displayName,
        element.displayName,
        parameters: parameters,
        properties: properties,
        dynamicProperties: dynamicProperties,
      ),
    );
  }

  void _parseMap(
      NodeList<CollectionElement> elements, Map<String, String> map) {
    for (MapLiteralEntryImpl exp in elements) {
      final key = exp.key as SimpleStringLiteralImpl;
      final value = exp.value as SimpleStringLiteralImpl;
      map[key.value] = value.value;
    }
  }
}
