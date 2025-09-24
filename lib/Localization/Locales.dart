import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("it", LocaleDate.IT),
  MapLocale("en", LocaleDate.EN),
];

mixin LocaleDate {
  static const String title = "title";
  static const String lista = "lista";
  static const String impostazioni = "impostazioni";
  static const String categoria = "categoria";
  static const String nome = "nome";
  static const String tema = "tema";
  static const String esporta = "esporta";
  static const String importa = "importa";
  static const String elimina = "elimina";
  static const String lingua = "lingua";
  static const String raggruppa = "raggruppa";
  static const String conferma = "conferma";
  static const String annulla = "annulla";
  static const String cambiaLingua = "cambiaLingua";
  static const String aggiungi = "aggiungi";
  static const String aggiungiPulsante = "aggiungiPulsante";
  static const String modificaPulsante = "modificaPulsante";
  static const String eliminazione = "eliminazione";
  static const String eliminazioneTesto = "eliminazioneTesto";

  static const Map<String, dynamic> IT = {
    title: "Da Comprare",
    lista: "Lista",
    impostazioni: "Impostazioni",
    categoria: "Categoria",
    nome: "Nome",
    tema: "Tema Scuro",
    esporta: "Esporta Lista",
    importa: "Importa Lista",
    elimina: "Elimina tutti i dati",
    lingua: "Lingua",
    raggruppa: "Raggruppa per categorie",
    conferma: "Conferma",
    annulla: "Annulla",
    cambiaLingua: "Cambia Lingua",
    aggiungi: "Aggiungi Cibo",
    aggiungiPulsante: "Aggiungi",
    modificaPulsante: "Modifica",
    eliminazione: "Conferma eliminazione",
    eliminazioneTesto: "Sei sicuro di voler eliminare il cibo?",
  };

  static const Map<String, dynamic> EN = {
    title: "To Buy",
    lista: "List",
    impostazioni: "Settings",
    categoria: "Category",
    nome: "Name",
    tema: "Dark Theme",
    esporta: "Export List",
    importa: "Import List",
    elimina: "Delete all data",
    lingua: "Languages",
    raggruppa: "Organize by category",
    conferma: "Confirm",
    annulla: "Deny",
    cambiaLingua: "Change Language",
    aggiungi: "Add Food",
    aggiungiPulsante: "Add",
    modificaPulsante: "Modify",
    eliminazione: "Confirm deletion",
    eliminazioneTesto: "Are you sure to delete this food?",
  };
}
