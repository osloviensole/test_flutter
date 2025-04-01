import 'package:flutter/services.dart';
import 'package:mobile_parktax/models/ticketExit.dart';
import '../models/ticket.dart';

class PrinterService {

  static const MethodChannel _channel = MethodChannel('printer_sdk');

  /// 📌 Fonction pour imprimer un ticket avec QR Code
  static Future<void> printTicket(Ticket ticket) async {
    try {
      // ✅ Format du ticket
      String ticketContent = "\t========================\n\n\n"
          "\t      TICKET STATIONNEMENT      \n"
          "\t========================\n\n"
          "\t📅 Date debut : ${ticket.dateCreation}\n"
          "\t🚗 Numero Plaque: ${ticket.numeroPlaque}\n"
          "\t⏳ Duree: ${ticket.heuresPrevues} heure(s)\n"
          "\t💵 Prix: ${ticket.montantTotal} FC\n\n"
          "\t📌 SCANNEZ LE QR CODE\n"
          "\t========================";

      // ✅ Imprimer le texte du ticket
      await _channel.invokeMethod('printText', {"text": ticketContent});
      // ✅ Imprimer le QR Code
      await _channel.invokeMethod('printQrCode', {"data": ticket.code});
      // ✅ Ajouter un message final
      await _channel.invokeMethod('printText',
          {"text": "\n MERCI - A BIENTOT\n========================\n\n\n\n\n\n\n"});
    } on PlatformException catch (e) {
      print("❌ Erreur impression QR Code : ${e.message}");
    }
  }

  static Future<void> printTicketExit(TicketExit ticketExit) async {
    try {
      // ✅ Format du ticket
      String ticketExitContent = "\t========================\n\n\n"
          "\t      TICKET STATIONNEMENT      \n"
          "\t========================\n\n"
          "\t🚗 ${ticketExit.message}\n\n"
          "\t📅 Date debut : ${ticketExit.dateDebut}\n"
          "\t📅 Date fin : ${ticketExit.dateFin}\n"
          "\t🚗 Numero Plaque: ${ticketExit.plaque}\n"
          "\t🚗 Prix: ${ticketExit.montant} FC\n\n"

          "\t MERCI - A BIENTOT\n========================\n\n\n\n\n\n\n\n\n\n";

      // ✅ Imprimer le texte du ticket
      await _channel.invokeMethod('printText', {"text": ticketExitContent});
    } on PlatformException catch (e) {
      print("❌ Erreur impression QR Code : ${e.message}");
    }
  }
}
