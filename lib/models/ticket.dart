// To parse this JSON data, do
//
//     final ticket = ticketFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Ticket ticketFromJson(String str) => Ticket.fromJson(json.decode(str));

String ticketToJson(Ticket data) => json.encode(data.toJson());

class Ticket {
  int? id;
  String code;
  String numeroPlaque;
  int heuresPrevues;
  int montantTotal;
  String dateCreation;

  Ticket({
    this.id,
    required this.code,
    required this.numeroPlaque,
    required this.heuresPrevues,
    required this.montantTotal,
    required this.dateCreation,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    code: json["code"],
    numeroPlaque: json["numero_plaque"],
    heuresPrevues: json["heures_prevues"],
    montantTotal: json["montant_total"],
    dateCreation: json["date_creation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "numero_plaque": numeroPlaque,
    "heures_prevues": heuresPrevues,
    "montant_total": montantTotal,
    "date_creation": dateCreation,
  };
}
