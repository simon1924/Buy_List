import "package:flutter/material.dart";
import "package:flutter_localization/flutter_localization.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:spesa/Aggiungi.dart";
import "package:spesa/Localization/Locales.dart";
import "package:spesa/Modifica.dart";
import 'package:spesa/Db/Funzioni_Hive.dart';
import "package:spesa/theme/ThemeSettings.dart";

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> listaCibi = [];
  bool raggruppaCategorie = false;
  List<String> chiavi = [];

  @override
  void initState() {
    super.initState();
    _caricaRaggruppaCategorie();
  }

  void ricarica() {
    _caricaRaggruppaCategorie();
    setState(() {
    });
  }

  void _caricaRaggruppaCategorie() async {
    raggruppaCategorie = await _ottieniRaggruppaCategorie();
    setState(() {
      if (raggruppaCategorie == true) {
        listaCibi = Funzioni_Hive.getListaCategorie();
        if (listaCibi != null) {
          chiavi = listaCibi[0].keys.toList();
        }
      } else {
        listaCibi = Funzioni_Hive.getLista();
      }
      print("chiavi: $chiavi");
    });
  }

  Future<bool> _ottieniRaggruppaCategorie() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool boolValue = prefs.getBool('raggruppaCategorie') ?? false;
    return boolValue;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ThemeSettings>(context);
    final stileEtichette = TextStyle(fontSize: 20);


    return Scaffold(
      appBar: AppBar(
        title: Builder(
          builder: (context) => Text(LocaleDate.lista.getString(context)),
        ),
      ),
      body: Scaffold(
        body:
            listaCibi.isEmpty
                ? Center(child: CircularProgressIndicator())
                : (raggruppaCategorie
                    ? costruisciListaCategorie(settings, stileEtichette)
                    : costruisciListaNormale(settings, stileEtichette)),

        floatingActionButton: FloatingActionButton(
          backgroundColor: settings.coloreFloatingButton,
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Aggiungi()),
            );
            ricarica();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget costruisciListaNormale(
    ThemeSettings settings,
    TextStyle stileEtichette,
  ) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          tileColor:
              index.isOdd ? settings.oddItemColor : settings.evenItemColor,
          title: Text("${listaCibi[index]["cibo"]}", style: stileEtichette),
          //"${listaCibi[index]["cibo"]}, indice ${listaCibi[index]["indice"]}"
          onTap: () {
            print(listaCibi[index]);
            Funzioni_Hive.salvaInDaComprare(listaCibi[index]);
            Fluttertoast.showToast(
              msg: "Cibo aggiunto",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.blueGrey,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          trailing: Icon(Icons.add_shopping_cart),
          onLongPress: () async {
            //print("bellaa");
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        Modifica(indice: index, oggetto: listaCibi[index]),
              ),
            );
            ricarica();
          },
        );
      },
      itemCount: listaCibi.length,
    );
  }

  Widget costruisciListaCategorie(
    ThemeSettings settings,
    TextStyle stileEtichette,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...List.generate(chiavi.length, (catIndex) {
            return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  Text(chiavi[catIndex], style: TextStyle(fontSize: 23)),
                  SizedBox(height: 8),
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          tileColor:
                              index.isOdd
                                  ? settings.oddItemColor
                                  : settings.evenItemColor,
                          title: Text(
                            (listaCibi.isNotEmpty
                                ? "${listaCibi[0][chiavi[catIndex]][index]["cibo"]}"
                                : ""),
                            style: stileEtichette,
                          ),
                          onTap: () {
                            print(listaCibi[0][chiavi[catIndex]][index]);
                            Funzioni_Hive.salvaInDaComprare(
                              listaCibi[0][chiavi[catIndex]][index],
                            );
                            Fluttertoast.showToast(
                              msg: "Cibo aggiunto",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          },
                          trailing: Icon(Icons.add_shopping_cart),
                          onLongPress: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => Modifica(
                                      indice: index,
                                      oggetto: listaCibi[index],
                                    ),
                              ),
                            );
                            ricarica();
                          },
                        );
                      },
                      itemCount: listaCibi[0][chiavi[catIndex]].length,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
