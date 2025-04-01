// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  int? id;
  String nom;
  String prenom;
  String telephone;
  String role;
  int zoneId;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.role,
    required this.zoneId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    nom: json["nom"],
    prenom: json["prenom"],
    telephone: json["telephone"],
    role: json["role"],
    zoneId: json["zoneId"],
    isDeleted: json["isDeleted"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "prenom": prenom,
    "telephone": telephone,
    "role": role,
    "zoneId": zoneId,
    "isDeleted": isDeleted,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
