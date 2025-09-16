import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spesa/Db/Funzioni_Hive.dart';

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
    //print(widget.oggetto);
    var nuovoOggetto = {
      "categoria": categoriaController.text,
      "cibo": nomeController.text,
      "indice": widget.oggetto["indice"]
    };

    //if (widget.indice != null) {
      Funzioni_Hive.modificaOggetto(widget.oggetto["indice"], nuovoOggetto);
    //}
  }

  void elimina() {
    //if (widget.indice != null) {
      Funzioni_Hive.eliminaDaLista(widget.oggetto["indice"]);
    //}
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
        title: Text("Modifica"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Conferma eliminazione"),
                    content: Text("Sei sicuro di voler eliminare il cibo?"),
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
                        child: Text("Conferma"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //const Text("Ciao"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text("Categoria", style: stileEtichette),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: categoriaController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Modifica Categoria',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text("Nome", style: stileEtichette),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              controller: nomeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Modifica Nome',
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
              child: const Text('Modifica'),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 32),
          //   child: ElevatedButton(
          //     style: style1,
          //     onPressed: () {
          //       elimina();
          //
          //       Fluttertoast.showToast(
          //         msg: "Cibo eliminato",
          //         toastLength: Toast.LENGTH_SHORT,
          //         gravity: ToastGravity.BOTTOM,
          //         timeInSecForIosWeb: 1,
          //         backgroundColor: Colors.blueGrey,
          //         textColor: Colors.white,
          //         fontSize: 16.0,
          //       );
          //     },
          //     child: const Text('Elimina Cibo'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
