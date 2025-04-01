package com.example.print_partax_test

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import test.apidemo.service.MyService  // ⚠️ Adapter au bon package de ton service

class MainActivity : FlutterActivity() {
    private val CHANNEL = "printer_sdk"  // Canal Flutter <-> Kotlin

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "printText" -> {
                    val text = call.argument<String>("text")
                    if (text != null) {
                        val intent = Intent(this, MyService::class.java)
                        intent.putExtra("text", text)
                        startService(intent)  // 🔁 Appelle le Service
                        result.success("Service d'impression texte lancé")
                    } else {
                        result.error("ARGUMENT_ERROR", "Texte invalide", null)
                    }
                }
                "printQrCode" -> {
                    val data = call.argument<String>("data")
                    if (data != null) {
                        val intent = Intent(this, MyService::class.java)
                        intent.putExtra("qrCode", data)
                        startService(intent)  // 🔁 Appelle le Service
                        result.success("Service d'impression QR Code lancé")
                    } else {
                        result.error("ARGUMENT_ERROR", "QR Code invalide", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
