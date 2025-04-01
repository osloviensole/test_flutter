
import 'package:flutter/material.dart';

Future DialogLoading(BuildContext context) => showDialog(
  barrierDismissible: false,
  context: context,
  builder: (BuildContext bc) => AlertDialog(
    //title: const Text('Chargement en cours ...', style: TextStyle(fontSize: 16)),
    //insetPadding: const EdgeInsets.symmetric(horizontal: 100),
    content: SizedBox(
        width: MediaQuery.of(context).size.width, // Dialog width
        height: 40,
        //decoration: BoxDecoration(shape: BoxShape.circle, color: blue500),
        child: const Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Chargement en cours ...",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: LinearProgressIndicator(
                backgroundColor: Colors.black,
                minHeight: 5,
                color: Colors.blue,
              ),
            ),
          ],
        )
    ),
    // actions: [
    //   TextButton(
    //       onPressed: () => Navigator.of(context).pop(),
    //       child: const Text("Annuler"),
    //   ),
    // ],
  ),
);