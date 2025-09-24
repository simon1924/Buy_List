import "dart:convert";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spesa/theme/ThemeSettings.dart";
import "package:spesa/Db/Funzioni_Hive.dart";
import 'package:spesa/variabili.dart';

import "Localization/Locales.dart";

class Impostazioni extends StatefulWidget {
  const Impostazioni({super.key});

  @override
  State<Impostazioni> createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<Impostazioni> {
  List listaCibi = [];


  String? _groupValue = "";
  late String _currentLocale;
  late FlutterLocalization _flutterLocalization;
  bool raggruppaCategorieSwitch = false;

  @override
  void initState() {
    listaCibi = Funzioni_Hive.getLista();
    super.initState();
    _flutterLocalization = FlutterLocalization.instance;
    _currentLocale = _flutterLocalization.currentLocale!.languageCode;

    _groupValue = _currentLocale;
    _caricaRaggruppaCategorie();
  }

  Future<File> get _localFile async {
    final path = "storage/emulated/0/Download";
    return File('$path/Lista.txt');
  }

  Future<File> scriviLista(List l) async {
    final file = await _localFile;
    String stringato = jsonEncode(l);
    print(stringato);
    return file.writeAsString(stringato, mode: FileMode.write);
  }

  List converti(String stringa) {
    List convertito = jsonDecode(stringa);
    return convertito;
  }

  void importa() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      String contenuto = await file.readAsString();
      List<dynamic> contenutoConvertito = converti(contenuto);
      Funzioni_Hive.importa(contenutoConvertito);
    } else {
      print("nessun file selezionato");
    }
  }

  void elimina() {
    Funzioni_Hive.pulisciDbLista();
    Funzioni_Hive.pulisciDbDaComprare();
  }

  void esporta() {
    scriviLista(listaCibi);
  }

  _saveOptions(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('raggruppaCategorie', value);
    _caricaRaggruppaCategorie();
  }

  void _caricaRaggruppaCategorie() async {
    raggruppaCategorieSwitch = await _ottieniRaggruppaCategorie();
    //raggruppaCategorie = raggruppaCategorieSwitch;
    setState(() {});
    print(raggruppaCategorieSwitch);
  }

  Future<bool> _ottieniRaggruppaCategorie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('raggruppaCategorie') ?? false;
    return boolValue;
  }


  @override
  Widget build(BuildContext context) {
    final settings = context.read<ThemeSettings>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Builder(
      builder:
          (context) => Scaffold(
            appBar: AppBar(
              title: Text(LocaleDate.impostazioni.getString(context)),
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                Consumer<ThemeSettings>(
                  builder: (context, snapshot, child) {
                    final settings = context.read<ThemeSettings>();
                    return GestureDetector(
                      child: Container(
                        height: 55,
                        color: settings.evenItemColor,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(settings.iconaTema),
                              SizedBox(width: 8),
                              Text(
                                LocaleDate.tema.getString(context),
                                style: TextStyle(fontSize: 23),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        settings.cambiaTema();
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    color: settings.oddItemColor,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.import_export_rounded),
                          SizedBox(width: 8),
                          Builder(
                            builder:
                                (context) => Text(
                                  LocaleDate.esporta.getString(context),
                                  style: TextStyle(fontSize: 23),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    esporta();

                    Fluttertoast.showToast(
                      msg: "Lista esportata",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.blueGrey,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    color: settings.evenItemColor,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.import_export_rounded),
                          SizedBox(width: 8),
                          Text(
                            LocaleDate.importa.getString(context),
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    importa();
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    color: settings.oddItemColor,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.clear_rounded),
                          SizedBox(width: 8),
                          Text(
                            LocaleDate.elimina.getString(context),
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Conferma eliminazione"),
                          content: Text(
                            "Sei sicuro di voler eliminare tutti i dati",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                LocaleDate.annulla.getString(context),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                elimina();

                                Fluttertoast.showToast(
                                  msg: "Lista eliminata",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blueGrey,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                LocaleDate.conferma.getString(context),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 55,
                    color: settings.evenItemColor,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.language),
                          SizedBox(width: 8),
                          Text(
                            LocaleDate.lingua.getString(context),
                            style: TextStyle(fontSize: 23),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            LocaleDate.cambiaLingua.getString(context),
                          ),
                          content: StatefulBuilder(
                            builder: (
                              BuildContext context,
                              StateSetter setState,
                            ) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Radio(
                                            value: "it",
                                            groupValue: _groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _groupValue = value;
                                              });
                                              onChanged(value);
                                            },
                                          ),
                                          Text(
                                            "Italiano",
                                            style: TextStyle(fontSize: 23),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(
                                            value: "en",
                                            groupValue: _groupValue,
                                            onChanged: (value) {
                                              setState(() {
                                                _groupValue = value;
                                              });
                                              onChanged(value);
                                            },
                                          ),
                                          Text(
                                            "English",
                                            style: TextStyle(fontSize: 23),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                LocaleDate.annulla.getString(context),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                LocaleDate.conferma.getString(context),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                Container(
                  height: 55,
                  color: settings.oddItemColor,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(Icons.category_rounded),
                        Text(
                          LocaleDate.raggruppa.getString(context),
                          style: TextStyle(fontSize: 23),
                        ),
                        SizedBox(width: 8),
                        Switch(
                          activeTrackColor: settings.switchColor,
                          value: raggruppaCategorieSwitch,
                          onChanged: (bool value) {
                            //print(value);
                            setState(() {
                              raggruppaCategorieSwitch = value;
                              _saveOptions(value);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void onChanged(String? value) {
    setState(() {
      _setLocale(value);
      print(value);
      _groupValue = value;
    });
  }

  void _setLocale(String? value) {
    if (value == null) return;
    if (value == "en") {
      _flutterLocalization.translate("en");
    } else if (value == "it") {
      _flutterLocalization.translate("it");
    } else {
      return;
    }
  }
}
