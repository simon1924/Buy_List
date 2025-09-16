import "dart:convert";
import "dart:io";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:spesa/theme/ThemeSettings.dart";
import "package:spesa/Db/Funzioni_Hive.dart";
import 'package:spesa/variabili.dart';

class Impostazioni extends StatefulWidget {
  const Impostazioni({super.key});

  @override
  State<Impostazioni> createState() => _ImpostazioniState();
}

class _ImpostazioniState extends State<Impostazioni> {
  List listaCibi = [];
  bool raggruppaCategorie = false;

  @override
  void initState() {
    listaCibi = Funzioni_Hive.getLista();
    super.initState();
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
  }

  void esporta() {
    scriviLista(listaCibi);
  }

  // void tema() {
  //   final settings = Provider.of<ThemeSettings>(context);
  //   settings.cambiaTema();
  // }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<ThemeSettings>();
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text("Impostazioni")),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          Consumer<ThemeSettings>(
            builder: (context, snapshot, child) {
              final settings = context.read<ThemeSettings>();
              return GestureDetector(
                child: Container(
                  height: 50,
                  color: settings.DarkModeButtonColor,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(settings.iconaTema, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          settings.nomeTema,
                          style: TextStyle(fontSize: 23, color: Colors.white),
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
              height: 50,
              color: settings.oddItemColor,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.import_export_rounded),
                    SizedBox(width: 8),
                    Text("Esporta Lista", style: TextStyle(fontSize: 23)),
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
              height: 50,
              color: settings.evenItemColor,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.import_export_rounded),
                    SizedBox(width: 8),
                    Text("Importa Lista", style: TextStyle(fontSize: 23)),
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
              height: 50,
              color: settings.oddItemColor,
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear_rounded),
                    SizedBox(width: 8),
                    Text(
                      "Elimina tutti i dati",
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
                    content: Text("Sei sicuro di voler eliminare tutti i dati"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Annulla"),
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
                        child: Text("Conferma"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          GestureDetector(
            child: Container(
              height: 50,
              color: settings.evenItemColor,
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language),
                    SizedBox(width: 8),
                    Text("Lingua", style: TextStyle(fontSize: 23)),
                  ],
                ),
              ),
            ),
            onTap: () {},
          ),
          Container(
            height: 50,
            color: settings.oddItemColor,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon(Icons.category_rounded),
                  Text(
                    "Raggruppa per categorie",
                    style: TextStyle(fontSize: 23),
                  ),
                  SizedBox(width: 8),
                  Switch(
                    activeTrackColor: settings.switchColor,
                    value: raggruppaCategorie,
                    onChanged: (bool value) {
                      //print(value);
                      setState(() {
                        raggruppaCategorie = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
