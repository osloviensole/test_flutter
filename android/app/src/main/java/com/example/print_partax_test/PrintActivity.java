package com.example.print_partax_test;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import test.demo.MyApplication;

public class PrintActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Récupérer le texte envoyé depuis Flutter
        String textToPrint = getIntent().getStringExtra("text");
        String qrCodeData = getIntent().getStringExtra("qrCode");

        if (textToPrint != null) {
            Log.i("PrintActivity", "📄 Texte reçu pour impression : " + textToPrint);
            printText(textToPrint);
        }

        if (qrCodeData != null) {
            Log.i("PrintActivity", "📷 QR Code reçu pour impression : " + qrCodeData);
            printQrCode(qrCodeData);
        }

        // Fermer l'activité après l'impression
        finish();
    }

    /**
     * Fonction pour imprimer du texte
     */
    public void printText(String text) {
        try {
            if (MyApplication.app.printerOpt != null) {
                MyApplication.app.printerOpt.PrnInit();
                MyApplication.app.printerOpt.PrnStr(text);
                MyApplication.app.printerOpt.PrnStart();
                Log.i("PrintActivity", "✅ Impression réussie : \n" + text);
            } else {
                Log.e("PrintActivity", "❌ Erreur : L'imprimante n'est pas connectée.");
            }
        } catch (Exception e) {
            Log.e("PrintActivity", "❌ Erreur d'impression : " + e.getMessage());
        }
    }

    /**
     * Fonction pour imprimer un QR Code
     */
    public void printQrCode(String data) {
        try {
            if (MyApplication.app.printerOpt != null) {
                MyApplication.app.printerOpt.PrnInit();
                MyApplication.app.printerOpt.PrnBarcode(data, 250, 250, "QR_CODE");
                MyApplication.app.printerOpt.PrnStart();
                Log.i("PrintActivity", "✅ QR Code imprimé : " + data);
            } else {
                Log.e("PrintActivity", "❌ Erreur : L'imprimante n'est pas connectée.");
            }
        } catch (Exception e) {
            Log.e("PrintActivity", "❌ Erreur impression QR Code : " + e.getMessage());
        }
    }
}
