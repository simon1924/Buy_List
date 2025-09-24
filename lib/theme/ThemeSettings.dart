import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

class ThemeSettings extends ChangeNotifier {
  ThemeData _temaCorrente = ThemeData.light();
  ThemeData get temaCorrente => _temaCorrente;

  ThemeSettings(bool indicatoreTema) {
    if (indicatoreTema == true) {
      _temaCorrente = ThemeData.dark();
    } else {
      _temaCorrente = ThemeData.light();
    }
  }

  void cambiaTema() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (_temaCorrente == ThemeData.light()) {
      _temaCorrente = ThemeData.dark();
      sharedPreferences.setBool("indicatoreTema", true);
    } else {
      _temaCorrente = ThemeData.light();
      sharedPreferences.setBool("indicatoreTema", false);
    }
    notifyListeners();
  }

  void cambiaCategorie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("indicatoreCategorie", true);
  }


  Color get oddItemColor => _temaCorrente == ThemeData.dark() ? Colors.deepPurple.withValues(alpha: 0.05) : Colors.orange.withValues(alpha: 0.05);
  Color get evenItemColor => _temaCorrente == ThemeData.dark() ? Colors.deepPurple.withValues(alpha: 0.15) : Colors.orange.withValues(alpha: 0.15);
  Color get coloreAppBar => _temaCorrente.brightness == Brightness.dark ? Colors.deepPurple : Colors.orange;
  Color get coloreFloatingButton => _temaCorrente.brightness == Brightness.dark ? Colors.deepPurple : Colors.orange;
  IconData get iconaTema => _temaCorrente.brightness == Brightness.dark ? Icons.wb_sunny : Icons.nights_stay;
  String get nomeTema => _temaCorrente.brightness == Brightness.dark ? "Tema Chiaro" : "Tema Scuro";
  Color get DarkModeButtonColor => _temaCorrente == ThemeData.dark() ? Colors.black : Colors.black54;
  Color get switchColor => _temaCorrente == ThemeData.dark() ? Colors.deepPurple : Colors.orange;
}
