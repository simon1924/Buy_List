import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:spesa/theme/ThemeSettings.dart';
import 'package:spesa/Db/Funzioni_Hive.dart';
import 'Navigatore.dart';

class DaComprare extends StatefulWidget {
  const DaComprare({
    super.key,
    required this.title
  });

  final String title;

  @override
  State<DaComprare> createState() => _DaComprare();
}

class _DaComprare extends State<DaComprare> {
  final _textController = TextEditingController();
  late List listaDaComprare;



  @override
  void initState() {
    listaDaComprare = Funzioni_Hive.getListaDaComprare();
    super.initState();
  }

  void ricarica() {
    setState(() {
      listaDaComprare = Funzioni_Hive.getListaDaComprare();
      print(listaDaComprare);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final stileEtichette = TextStyle(fontSize: 20);
    final settings = Provider.of<ThemeSettings>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: settings.coloreAppBar,
        title: Text(widget.title),
      ),
      drawer: Navigatore(
        onReturnFromLista: ricarica
      ),
      body: Scaffold(
        body: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              tileColor: index.isOdd ? settings.oddItemColor : settings.evenItemColor,
              title: Text(

                "${listaDaComprare[index]["quantita"]} ${listaDaComprare[index]["cibo"]}",
                style: stileEtichette,
              ),
              onTap: () {

                Funzioni_Hive.eliminaDaComprare(listaDaComprare[index]["indice"]);
                ricarica();
                Fluttertoast.showToast(
                  msg: "Comprato",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blueGrey,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              },
              trailing: Icon(Icons.remove_shopping_cart),
            );
          },
          itemCount: listaDaComprare.length,
        ),
      ),

    );
  }
}
