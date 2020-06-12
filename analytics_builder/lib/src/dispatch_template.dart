import 'analytic_spec.dart';

class DispatchTemplate {
  final List<AnalyticSpec> specs;
  final Map<String, String> globals;
  final String dispatchKind;
  final String blocName;
  final int total;

  DispatchTemplate(
      {this.specs, this.globals, this.dispatchKind, this.blocName, this.total});

  String toDart() {
    return '''
Map<String,String> _dispatch$dispatchKind($blocName$dispatchKind ${dispatchKind.toLowerCase()}) {
  ${_dispatch(specs, dispatchKind.toLowerCase())}
}
    ''';
  }

  String _dispatch(List<AnalyticSpec> specs, String varName) {
    if (total == 0) {
      return "return null;";
    } else if (total == 1 && specs.length == 1) {
      return '''
          Map<String,String> payload = {
            \"id\": \"${specs[0].id}\",
            ${_varsTemplate(specs[0].dynamicProperties, specs[0].properties, prefix: varName)}
          };
          return payload;
        ''';
    } else {
      final String _specs = specs.map((e) => _specsTemplate(e)).join("\n    ");

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
