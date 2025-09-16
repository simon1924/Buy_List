import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:provider/provider.dart";
import "package:spesa/Aggiungi.dart";
import "package:spesa/Modifica.dart";
import "package:flutter/services.dart";
import "dart:convert";
import 'package:spesa/Db/Funzioni_Hive.dart';
import "package:spesa/theme/ThemeSettings.dart";

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Map<String, dynamic>> listaCibi = [];

  @override
  void initState() {
    super.initState();
    listaCibi = Funzioni_Hive.getLista();
  }

  void ricarica() {
    setState(() {
      listaCibi = Funzioni_Hive.getLista();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ThemeSettings>(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    // final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    // final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    // final Color oddItemColor = colorScheme.primary.withValues(alpha: 0.05);
    // final Color evenItemColor = colorScheme.primary.withValues(alpha: 0.15);
    final stileEtichette = TextStyle(fontSize: 20);

    // if (listaCibi.isEmpty) {
    //   return Center(child: CircularProgressIndicator());
    // }

    return Scaffold(
      appBar: AppBar(title: Text("Lista")),
      body: Scaffold(
        body: ListView.builder(
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
        ),

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
}
