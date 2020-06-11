library analitycs_builder;

import 'package:analytics_builder/src/mixin_builder.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/analytics_builder.dart';

Builder analyticsBuilder(BuilderOptions options) =>
    PartBuilder([AnalyticsBuilder(), MixinBuilder()], '.analytics.dart');
