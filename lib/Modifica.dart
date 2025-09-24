import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spesa/Db/Funzioni_Hive.dart';
import 'package:spesa/Localization/Locales.dart';

class Modifica extends StatefulWidget {
  final dynamic oggetto;
  final int? indice;

  const Modifica({super.key, this.oggetto, this.indice});

  @override
  State<Modifica> createState() => _ModificaState();
}

class _ModificaState extends State<Modifica> {
  late TextEditingController categoriaController;
  late TextEditingController nomeController;

  @override
  void initState() {
    super.initState();
    categoriaController = TextEditingController(
      text: widget.oggetto["categoria"] ?? "",
    );
    nomeController = TextEditingController(text: widget.oggetto["cibo"] ?? "");
  }

  @override
  void dispose() {
    categoriaController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  void mod() {
    var nuovoOggetto = {
      "categoria": categoriaController.text,
      "cibo": nomeController.text,
      "indice": widget.oggetto["indice"],
    };


    Funzioni_Hive.modificaOggetto(widget.oggetto["indice"], nuovoOggetto);

  }

  void elimina() {

    Funzioni_Hive.eliminaDaLista(widget.oggetto["indice"]);

  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 23),
    );
    final ButtonStyle style1 = ElevatedButton.styleFrom(
      backgroundColor: Colors.purple,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 23),
    );
    final stileEtichette = TextStyle(fontSize: 23);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleDate.modificaPulsante.getString(context)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(LocaleDate.eliminazione.getString(context)),
                    content: Text(LocaleDate.eliminazioneTesto.getString(context)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(LocaleDate.annulla.getString(context)),
                      ),
                      TextButton(
                        onPressed: () {
                          elimina();
                          Fluttertoast.showToast(
                            msg: "Cibo eliminato",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.blueGrey,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(LocaleDate.conferma.getString(context)),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Builder(
        builder:
            (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {
                      mod();

                      Fluttertoast.showToast(
                        msg: "Cibo modificato",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blueGrey,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    child: Text(LocaleDate.modificaPulsante.getString(context)),
                  ),
                ),

              ],
            ),
      ),
    );
  }
}
