import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:spesa/Impostazioni.dart';
import 'package:spesa/Lista.dart';
import 'package:spesa/Localization/Locales.dart';

class Navigatore extends StatefulWidget {
  const Navigatore({
    super.key,
    this.onReturnFromLista,
  });

  final VoidCallback? onReturnFromLista;


  @override
  State<Navigatore> createState() => _NavigatoreState();
}

class _NavigatoreState extends State<Navigatore> {
  @override
  Widget build(BuildContext context) {
    final stileEtichette = TextStyle(fontSize: 20);

    return Drawer(
      child: Builder(
        builder:
            (context) => ListView(
              children: [

                SizedBox(height: 20),
                ListTile(
                  title: Text(
                    LocaleDate.lista.getString(context),
                    style: stileEtichette,
                  ),
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
                  title: Text(LocaleDate.impostazioni.getString(context), style: stileEtichette),
                  leading: Icon(Icons.settings),
                  onTap: () async {
                    Navigator.pop(context);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Impostazioni()),
                    );
                  },
                ),
              ],
            ),
      ),
    );
  }
}
