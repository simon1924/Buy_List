import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spesa/theme/ThemeSettings.dart';
import 'DaComprare.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("daComprare");
  await Hive.openBox("lista");

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final indicatoreTema = sharedPreferences.getBool("indicatoreTema") ?? false;

  runApp(MyApp(indicatoreTema: indicatoreTema));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.indicatoreTema});
  final bool indicatoreTema;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeSettings(widget.indicatoreTema),
      builder: (context, snapshot) {
        final settings = context.watch<ThemeSettings>();
        return MaterialApp(
          title: 'Home',
          //theme: ThemeData(
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),),
          theme: settings.temaCorrente,
          home: DaComprare(title: 'Da Comprare'),
        );
      },
    );
  }
}
