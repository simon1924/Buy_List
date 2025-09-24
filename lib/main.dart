import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spesa/Localization/Locales.dart';
import 'package:spesa/theme/ThemeSettings.dart';
import 'DaComprare.dart';
import "package:spesa/Localization/Localization_helper.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("daComprare");
  await Hive.openBox("lista");
  await FlutterLocalization.instance.ensureInitialized();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final indicatoreTema = sharedPreferences.getBool("indicatoreTema") ?? false;
  final indicatoreCategorie =
      sharedPreferences.getBool("indicatoreCategorie") ?? false;

  runApp(
    MyApp(
      indicatoreTema: indicatoreTema,
      indicatoreCategorie: indicatoreCategorie,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    required this.indicatoreTema,
    required this.indicatoreCategorie,
  });

  final bool indicatoreTema;
  final bool indicatoreCategorie;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalization localization = FlutterLocalization.instance;

  @override
  void initState() {
    super.initState();
    //configureLocalization();
    configureLocalization(localization, () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => ThemeSettings(widget.indicatoreTema),
      builder: (context, snapshot) {
        final settings = context.watch<ThemeSettings>();
        return MaterialApp(
          title: 'Home',
          theme: settings.temaCorrente,
          home: Builder(
            builder: (context) {
              return DaComprare(title: LocaleDate.title.getString(context));
            },
          ),

          supportedLocales: localization.supportedLocales,
          localizationsDelegates: localization.localizationsDelegates,
        );
      },
    );
  }

}
