import 'dart:ffi';
import 'package:hive_ce/hive.dart';

class Funzioni_Hive {
  static final dbLista = Hive.box("lista");
  static final dbDaComprare = Hive.box("daComprare");


  static List<Map<String, dynamic>> getLista() {
    final List<dynamic> l = dbLista.values.toList() ?? [];
    final List<Map<String, dynamic>> sorted =
        l.map((e) => Map<String, dynamic>.from(e)).toList();
    sorted.sort((a, b) => a["cibo"]!.compareTo(b["cibo"]!));
    return sorted;
  }


  static List<Map<String, dynamic>> getListaCategorie() {
    final List<dynamic> l = dbLista.values.toList() ?? [];
    final List<String> categorie = [];
    for (int i = 0; i < l.length; i++) {
      categorie.add(l[i]["categoria"]);
    }

    final List<String> unici = categorie.toSet().toList();
    //print(unici);
    Map<String, dynamic> oggetto = {};
    for (int r = 0; r < unici.length; r++) {
      oggetto[unici[r]] = [];
      for (int i = 0; i < l.length; i++) {
        if(unici[r] == l[i]["categoria"]){
          oggetto[unici[r]].add(l[i]);
        }
      }
    }

    return [oggetto];
  }

  static List getListaDaComprare() {
    final List<dynamic> daCom = dbDaComprare.values.toList() ?? [];
    //print("daComprare, in DB: $daCom");
    final sorted = List<dynamic>.from(daCom);
    sorted.sort((a, b) => a["cibo"]!.compareTo(b["cibo"]!));
    //print("sorted in DB: $sorted");
    return sorted;
  }



  static void salvaInLista(Map<String, dynamic> oggetto) {
    //final int lunghezza = dbLista.values.toList().length;
    final List dbListaCopia = dbLista.values.toList();

    int maggiore = 0;
    for (int l = 0; l < dbListaCopia.length; l++) {
      if (dbListaCopia[l]["indice"] > maggiore) {
        maggiore = dbListaCopia[l]["indice"];
      }
    }
    ;

    Map<String, dynamic> oggettoFinale = {
      "categoria": oggetto["categoria"],
      "cibo": oggetto["cibo"],
      "indice": maggiore + 1,
    };
    dbLista.add(oggettoFinale);
    //print(dbLista.values.toList());
  }

  static void salvaInDaComprare(Map<String, dynamic> oggetto) {
    final List<Map<String, dynamic>> daComprare =
        dbDaComprare.values.map((e) => Map<String, dynamic>.from(e)).toList();
    List<int> valori = [];

    daComprare.forEach((item) => valori.add(item["indice"]));

    if (!valori.contains(oggetto["indice"])) {
      oggetto["quantita"] = 1;
      dbDaComprare.add(oggetto);
      print("aggiunto");
    } else {
      for (int i = 0; i < daComprare.length; i++) {
        if (daComprare[i]["indice"] == oggetto["indice"]) {
          daComprare[i]["quantita"] += 1;
          modificaOggettoDaComprare(oggetto["indice"], daComprare[i]);
        }
        ;
      }
      ;

    }
  }

  static void salvaInDaComprareMIA(Map<String, dynamic> oggetto) {
    final List<Map<String, dynamic>> daComprare =
        dbDaComprare.values.map((e) => Map<String, dynamic>.from(e)).toList();
    List<int> valori = [];

    daComprare.forEach((item) => valori.add(item["indice"]));
    if (!valori.contains(oggetto["indice"])) {
      dbDaComprare.add(oggetto);
      print("aggiunto");
    } else {
      print("già presente");
    }
  }

  static void modificaOggettoDaComprare(
    int index,
    Map<String, dynamic> oggetto,
  ) {
    final List<Map<String, dynamic>> li =
        dbDaComprare.values.map((e) => Map<String, dynamic>.from(e)).toList();

    for (int i = 0; i < li.length; i++) {
      if (li[i]["indice"] == index) {
        dbDaComprare.putAt(i, oggetto);
      }
    }
  }

  static void eliminaDaComprare(int index) {
    final List daComprare = dbDaComprare.values.toList();

    for (int i = 0; i < daComprare.length; i++) {
      if (daComprare[i]["indice"] == index) {
        dbDaComprare.deleteAt(i);
      }
    }
  }

  static void eliminaDaLista(int index) {
    final List li = dbLista.values.toList();

    for (int i = 0; i < li.length; i++) {
      if (li[i]["indice"] == index) {
        dbLista.deleteAt(i);
      }
    }
  }

  static void modificaOggetto(int index, Map<String, dynamic> oggetto) {
    final List li = dbLista.values.toList();

    for (int i = 0; i < li.length; i++) {
      if (li[i]["indice"] == index) {
        dbLista.putAt(i, oggetto);
      }
    }
  }

  static Future<void> pulisciDbLista() async {
    await dbLista.clear();
  }

  static Future<void> pulisciDbDaComprare() async {
    await dbDaComprare.clear();
  }

  static void importa(List<dynamic> oggetti) {
    //oggetti.forEach((item) {
    for (Map<String, dynamic> item in oggetti) {
      //print("item: $item");
      bool presenza = controllaDuplicati(item);
      if (presenza == false) {
        salvaInLista(item);
      }
    }
    //);
  }

  static bool controllaDuplicati(Map<String, dynamic> oggetto) {
    List listaInDb = dbLista.values.toList();

    for (var item in listaInDb) {
      if (item["cibo"] == oggetto["cibo"]) {
        return true;
      }
    }
    return false;
  }
}
