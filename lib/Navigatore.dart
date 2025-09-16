import 'package:flutter/material.dart';
import 'package:spesa/Impostazioni.dart';
import 'package:spesa/Lista.dart';

class Navigatore extends StatefulWidget {
  const Navigatore({
    super.key,
    this.onReturnFromLista,
    //required this.tema,
    //required this.indicatoreTema,
  });

  final VoidCallback? onReturnFromLista;
 // final Function() tema;
  //final bool indicatoreTema;

  @override
  State<Navigatore> createState() => _NavigatoreState();
}

class _NavigatoreState extends State<Navigatore> {
  @override
  Widget build(BuildContext context) {
    final stileEtichette = TextStyle(fontSize: 20);

    return Drawer(
      child: ListView(
        children: [
          // ListTile(
          //   title: Text("Da Comprare"),
          //   leading: Icon(Icons.home),
          //   onTap: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (context) => DaComprare()));
          //   },
          // ),
          SizedBox(height: 20),
          ListTile(
            title: Text("Lista", style: stileEtichette),
            leading: Icon(Icons.list),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Lista()),
              ).then((_) {
                if (widget.onReturnFromLista != null) {
                  widget.onReturnFromLista!(); // Trigger refresh
                }
              });

            },
          ),
          ListTile(
            title: Text("Impostazioni", style: stileEtichette),
            leading: Icon(Icons.settings),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Impostazioni(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
