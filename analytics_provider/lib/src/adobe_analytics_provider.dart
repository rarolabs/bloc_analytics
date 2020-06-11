import 'package:flutter_acpanalytics/flutter_acpanalytics.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';

import 'analytics.dart';

class AdobeAnalyticsProvider extends AnalyticsProvider {
  AdobeAnalyticsProvider(Map<String, String> globals) : super(globals);

  @override
  Future<void> trackAction(String action, {Map<String, String> payload}) async {
    final Map<String, String> data = {};
    data.addAll(globals);
    data.addAll(payload);
    final _ = await FlutterACPCore.trackAction(action, data: data);
  }

  @override
  Future<void> trackState(String state, {Map<String, String> payload}) async {
    final Map<String, String> data = {};
    data.addAll(globals);
    data.addAll(payload);
    final _ = await FlutterACPCore.trackState(state, data: data);
  }

  Future<void> getExperienceCloudId() async {
    // final experienceCloudId = await FlutterACPAnalytics.
    // this.globals["experienceCloudId"] = experienceCloudId;
  }
}
