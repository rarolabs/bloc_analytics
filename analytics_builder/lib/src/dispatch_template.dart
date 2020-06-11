import 'analytic_spec.dart';

class DispatchTemplate {
  final List<AnalyticSpec> specs;
  final Map<String, String> globals;
  final String dispatchKind;
  final String blocName;

  DispatchTemplate(
      {this.specs, this.globals, this.dispatchKind, this.blocName});

  String toDart() {
    return '''
Map<String,String> _dispatch$dispatchKind($blocName$dispatchKind ${dispatchKind.toLowerCase()}) {
  ${_dispatch(specs, dispatchKind.toLowerCase())}
}
    ''';
  }

  String _dispatch(List<AnalyticSpec> specs, String varName) {
    switch (specs.length) {
      case 0:
        return "return null;";
      case 1:
        return '''
          Map<String,String> payload = {
            ${_varsTemplate(specs[0].dynamicProperties, specs[0].properties, prefix: varName)}
          };
          return payload;
        ''';
      default:
        final String _specs =
            specs.map((e) => _specsTemplate(e)).join("\n    ");

        return '''
        final payload = $varName.maybeWhen(
          orElse:() => null,
          $_specs
        );
        return payload;
      ''';
    }
  }

  String _specsTemplate(
    AnalyticSpec spec,
  ) {
    return '''${spec.name}: (${spec.parameters.join(",")}) {
      Map<String,String> map = {
        \"id\": \"${spec.id}\",
        ${_varsTemplate(spec.dynamicProperties, spec.properties)}        
      };
      return map;
    },''';
  }

  String _varsTemplate(
      Map<String, String> dynamicProperties, Map<String, String> properties,
      {String prefix}) {
    final _prefix = prefix != null ? "$prefix." : "";
    final _globals =
        globals.entries.map((e) => "\"${e.key}\": \"${e.value}\"").toList();
    final _dynamicProperties = dynamicProperties.entries
        .map((e) => "\"${e.key}\": $_prefix${e.value}.toString()")
        .toList();
    final _properties =
        properties.entries.map((e) => "\"${e.key}\": \"${e.value}\"").toList();

    _globals.addAll(_properties);
    _globals.addAll(_dynamicProperties);

    return _globals.join(",\n");
  }
}
