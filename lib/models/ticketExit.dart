// To parse this JSON data, do
//
//     final ticketExit = ticketExitFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

TicketExit ticketExitFromJson(String str) => TicketExit.fromJson(json.decode(str));

String ticketExitToJson(TicketExit data) => json.encode(data.toJson());

class TicketExit {
  String message;
  String dateDebut;
  String dateFin;
  int montant;
  String plaque;

  TicketExit({
    required this.message,
    required this.dateDebut,
    required this.dateFin,
    required this.montant,
    required this.plaque,
  });

  factory TicketExit.fromJson(Map<String, dynamic> json) => TicketExit(
    message: json["message"],
    dateDebut: json["date_debut"],
    dateFin: json["date_fin"],
    montant: json["montant"],
    plaque: json["plaque"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "date_debut": dateDebut,
    "date_fin": dateFin,
    "montant": montant,
    "plaque": plaque,
  };
}
