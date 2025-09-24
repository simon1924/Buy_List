
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:spesa/Localization/Locales.dart';

void configureLocalization(FlutterLocalization localization, VoidCallback onTranslatedLanguage) {
  localization.init(mapLocales: LOCALES, initLanguageCode: "en");
  localization.onTranslatedLanguage = (Locale? locale) => onTranslatedLanguage();
}
