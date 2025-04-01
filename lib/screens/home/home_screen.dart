import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_parktax/controllers/ticketController.dart';
import 'package:mobile_parktax/models/ticketExit.dart';
import 'package:mobile_parktax/screens/home/qr_scanner_screen.dart';
import '../../api/result_api.dart';
import '../../components/custom_drawer.dart';
import '../../components/dialog_loading.dart';
import '../../core/theme.dart';
import '../../models/ticket.dart';
import '../../services/printer_service.dart'; // ✅ Import du service

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? _lastPressedAt;
  bool _isDrawerOpen = false;
  late Ticket _ticket;
  late TicketExit _ticketExit;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        if (_isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }

        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text("Appuyez à nouveau pour quitter"),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }

        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tableau de Bord",
            style: gamThemeData.textTheme.titleLarge,
          ),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        drawer: CustomDrawer(),
        onDrawerChanged: (isOpened) {
          setState(() {
            _isDrawerOpen = isOpened;
          });
        },
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gamThemeData.primaryColor.withAlpha(220),
                gamThemeData.primaryColor.withAlpha(180),
                gamThemeData.colorScheme.secondary.withAlpha(100),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          // On ajoute un SingleChildScrollView ou un Expanded pour éviter l’overflow
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              // On centre horizontalement le contenu
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                // Titre "Bienvenue !" centré

                Text(
                  "Bienvenue !",
                  style: gamThemeData.textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),

                // Texte sur le parking et la technologie
                Text("Utilisez cet outil pour consulter les tickets, imprimer les factures et suivre les entrées et sorties.",
                  style: gamThemeData.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),

                // Grille des boutons (Scanner, Impression, etc.)
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildDashboardTile(
                        context,
                        Icons.qr_code_scanner,
                        "Signaler\nDépart",
                        () async {
                          final scannedData = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
                          );
                          if (scannedData != null) {
                            await ticketExit(code: scannedData);
                          }
                        },
                      ),
                      _buildDashboardTile(
                        context,
                        Icons.directions_car,
                        "Enregistrer\nArrivée",
                            () {
                              PrinterService.printTicket(Ticket(code: "code", numeroPlaque: "numeroPlaque", heuresPrevues: 1, montantTotal: 1500, dateCreation: "dateCreation"));
                          // _showDialog(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📌 Appelle `PrinterService` pour imprimer un ticket
  void _printTicket() {
    PrinterService.printTicket(_ticket);
  }

  void _printTicketExit() {
    PrinterService.printTicketExit(_ticketExit);
  }

  Widget _buildDashboardTile(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            color: gamThemeData.colorScheme.surface.withAlpha(240).withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 55, color: gamThemeData.primaryColor),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: gamThemeData.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   title,
              //   style: gamThemeData.textTheme.bodyLarge,
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  _validateTicket({required String numeroPlaque, required int heuresPrevues}) async {
    log("# HomeScreen < _validateTicket : start");

    DialogLoading(context);
    ResultApi result = await Ticketcontroller.create(
      numeroPlaque: numeroPlaque,
      heuresPrevues: heuresPrevues,
    );
    Navigator.pop(context);

    if (result.code == 201) {
      _ticket = result.data[0]; // ✅ Stocke le ticket
      String message = result.data[1];

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(message),
        ),
      );

      // ✅ Imprime immédiatement après la création
      _printTicket();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(result.data),
        ),
      );
    }
  }

  ticketExit({required String code}) async {
    log("# HomeScreen < ticketExit : start");

    DialogLoading(context);
    ResultApi result = await Ticketcontroller.ticketExit(code: code);
    Navigator.pop(context);

    if (result.code == 200) {
      _ticketExit = result.data;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(_ticketExit.message),
        ),
      );

      // ✅ Imprime immédiatement après la sortie
      _printTicketExit();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(result.data),
        ),
      );
    }
  }

  void _showDialog(BuildContext context) {
    TextEditingController plaqueController = TextEditingController();
    TextEditingController timeController = TextEditingController(); // ✅ Champ pour entrer la durée

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Entrer la plaque et la durée",
            textAlign: TextAlign.center,
            style: gamThemeData.textTheme.displayLarge?.copyWith(
              fontSize: 20,
              color: gamThemeData.colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Veuillez saisir la plaque et la durée en heures.",
                textAlign: TextAlign.center,
                style: gamThemeData.textTheme.bodyMedium?.copyWith(
                  color: gamThemeData.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Champ de saisie de la plaque
              TextField(
                controller: plaqueController,
                textAlign: TextAlign.center,
                style: gamThemeData.textTheme.bodyLarge?.copyWith(
                  color: gamThemeData.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: "ABC123",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: gamThemeData.colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: gamThemeData.colorScheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Champ pour entrer la durée en heures
              TextField(
                controller: timeController,
                keyboardType: TextInputType.number, // ✅ Permet seulement les nombres
                textAlign: TextAlign.center,
                style: gamThemeData.textTheme.bodyLarge?.copyWith(
                  color: gamThemeData.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: "2, 3, 4",
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: gamThemeData.colorScheme.primary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: gamThemeData.colorScheme.primary, width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: gamThemeData.colorScheme.onSurface.withOpacity(0.7),
              ),
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () async {
                String plaque = plaqueController.text.trim();
                String enteredTime = timeController.text.trim();

                // ✅ Vérifier que la durée est un nombre valide
                if (enteredTime.isEmpty || int.tryParse(enteredTime) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Veuillez entrer une durée valide en heures"),
                    ),
                  );
                  return;
                }

                Navigator.pop(context);

                print("✅ plaque : $plaque");
                print("✅ Durée sélectionnée : $enteredTime heures");

                await _validateTicket(
                  numeroPlaque: plaque,
                  heuresPrevues: int.parse(enteredTime),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: gamThemeData.colorScheme.secondary,
                foregroundColor: gamThemeData.colorScheme.onSecondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: Text(
                "Valider",
                style: gamThemeData.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
