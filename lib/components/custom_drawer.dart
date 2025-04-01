

import 'dart:developer';

import 'package:flutter/material.dart';

import '../controllers/userController.dart';


class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:  [Color(0xFF457B9D), Color(0xFF1D3557)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                'G A M',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          // ListTile(
          //   leading: Icon(Icons.person_2),
          //   title: Text('Mon profil'),
          //   onTap: () {
          //     Navigator.pushNamed(
          //       context,
          //       '/user_profile',
          //     );
          //   },
          // ),
          // const Divider(),
          // ListTile(
          //   leading: Icon(Icons.subscriptions),
          //   title: Text('Abonnemment'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/subscription_type');
          //   },
          // ),
          // const Divider(),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Parametres'),
          //   onTap: () {
          //     Navigator.pushNamed(context, '/settings');
          //   },
          // ),
          // const Divider(),

          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Déconnexion',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Center( // Centrer le titre
                      child: Icon(Icons.warning_amber_outlined,color: Colors.red,size: 50,),
                    ),
                    content: const Column(
                      mainAxisSize: MainAxisSize.min, // Adapter la taille au contenu
                      mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
                      crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement
                      children: [
                        Text(
                          'Êtes-vous sûr de vouloir vous déconnecter ?',
                          textAlign: TextAlign.center, // Centrer le texte
                        ),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.center, // Centrer les actions horizontalement
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Annuler'),
                      ),
                      ElevatedButton(
                        // onPressed: () => Navigator.of(context).pop(true),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await UserController.logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Déconnexion',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  );

                },
              );

              if (shouldLogout == true) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false, // Supprime toutes les routes existantes
                );
              }
            },
          ),

          const Divider(),

          // ListTile(
          //   leading: const Icon(Icons.delete, color: Colors.red),
          //   title: const Text(
          //     'Suppression du compte',
          //     style: TextStyle(color: Colors.red),
          //   ),
          //   onTap: () async {
          //     final shouldDelete = await showDialog<bool>(
          //
          //       context: context,
          //       builder: (context) {
          //         return AlertDialog(
          //           title: const Center( // Centrer le titre
          //             child: Icon(Icons.warning_amber_outlined,color: Colors.red,size: 50,),
          //           ),
          //           content: const Column(
          //             mainAxisSize: MainAxisSize.min, // Adapter la taille au contenu
          //             mainAxisAlignment: MainAxisAlignment.center, // Centrer le contenu verticalement
          //             crossAxisAlignment: CrossAxisAlignment.center, // Centrer horizontalement
          //             children: [
          //               Text(
          //                 'Êtes-vous sûr de vouloir supprimer votre compte ?',
          //                 textAlign: TextAlign.center, // Centrer le texte
          //               ),
          //             ],
          //           ),
          //           actionsAlignment: MainAxisAlignment.center, // Centrer les actions horizontalement
          //           actions: [
          //             TextButton(
          //               onPressed: () => Navigator.of(context).pop(false),
          //               child: const Text('Annuler'),
          //             ),
          //             ElevatedButton(
          //               // onPressed: () => Navigator.of(context).pop(true),
          //               onPressed: () async {
          //                 // On ferme le dialogue avec la valeur true
          //                 Navigator.of(context).pop(true);
          //
          //               },
          //               style: ElevatedButton.styleFrom(
          //                 backgroundColor: Colors.red,
          //               ),
          //               child: const Text(
          //                 'Supprimer',
          //                 style: TextStyle(color: Colors.white),
          //               ),
          //             ),
          //           ],
          //         );
          //
          //       },
          //     );
          //     log("delete $shouldDelete");
          //     if (shouldDelete == true) {
          //       await UserController.delete( UserService.loggedUser.id);
          //       // Redirection vers la page de login après suppression
          //       Navigator.pushNamedAndRemoveUntil(
          //         context,
          //         '/login',
          //             (Route<dynamic> route) => false,
          //       );
          //     }
          //   },
          // ),

        ],
      ),
    );
  }
}
