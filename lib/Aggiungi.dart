import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spesa/Db/Funzioni_Hive.dart';
import 'package:spesa/Localization/Locales.dart';

class Aggiungi extends StatefulWidget {
  const Aggiungi({super.key});

  @override
  _AggiungiStato createState() => _AggiungiStato();
}

class _AggiungiStato extends State<Aggiungi> {
  late String cat, n;
  String categoriaTesto = "", nomeTesto = "";

  void _SetText() {
    setState(() {
      categoriaTesto = cat;
      nomeTesto = n;
    });

    Map<String, String> oggetto = {
      "categoria": categoriaTesto,
      "cibo": nomeTesto,
    };
    bool presente = Funzioni_Hive.controllaDuplicati(oggetto);
    if (presente == true) {
      print("gia presente");
    } else {
      Funzioni_Hive.salvaInLista(oggetto);

      Fluttertoast.showToast(
        msg: "Cibo aggiunto",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController categoriaController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();

    final stileEtichette = const TextStyle(fontSize: 23);
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 23),
    );

    return Scaffold(
      appBar: AppBar(title: Text(LocaleDate.aggiungi.getString(context))),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(LocaleDate.categoria.getString(context), style: stileEtichette),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: categoriaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: LocaleDate.categoria.getString(context),
              ),
              onChanged: (valore) => cat = valore,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(LocaleDate.nome.getString(context), style: stileEtichette),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: LocaleDate.nome.getString(context),
              ),
              onChanged: (e) => n = e,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
            child: ElevatedButton(
              style: style,
              onPressed: () {

                _SetText();
                categoriaController.clear();
                nomeController.clear();

              },
              child: Text(LocaleDate.aggiungiPulsante.getString(context)),
            ),
          ),

        ],
      ),
    );
  }
}
