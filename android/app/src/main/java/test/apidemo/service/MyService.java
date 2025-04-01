package test.apidemo.service;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import com.ctk.sdk.PosApiHelper;

public class MyService extends Service {

    public static final String tag = MyService.class.getSimpleName();

    PosApiHelper posApiHelper = PosApiHelper.getInstance();

    @Override
    public void onCreate() {
        super.onCreate();
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        new Thread(() -> {
            // 🔄 Récupération des données envoyées par Flutter
            String textToPrint = intent.getStringExtra("text");
            String qrCode = intent.getStringExtra("qrCode");

            int ret = posApiHelper.PrintInit(2, 24, 24, 0x33);
            if (ret != 0) {
                Log.e(tag, "❌ Échec initialisation imprimante : code $ret");
                return;
            }

            posApiHelper.PrintSetFont((byte) 16, (byte) 16, (byte) 0x33);

            if (textToPrint != null) {
                Log.i(tag, "🖨️ Impression de texte : " + textToPrint);
                posApiHelper.PrintStr(textToPrint + "\n\n");
            }

            if (qrCode != null) {
                Log.i(tag, "🖨️ Impression de QR Code : " + qrCode);
                posApiHelper.PrintBarcode(qrCode, 240, 240, "QR_CODE");
            }

            ret = posApiHelper.PrintStart();
            if (ret == 0) {
                Log.i(tag, "✅ Impression terminée");
            } else {
                Log.e(tag, "❌ Échec de l'impression, code = " + ret);
                if (ret == -1) Log.e(tag, "📄 Papier manquant !");
                else if (ret == -2) Log.e(tag, "🔥 Température trop élevée !");
                else if (ret == -3) Log.e(tag, "⚡ Tension trop basse !");
            }
        }).start();

        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {
        stopSelf();
        super.onDestroy();
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return new MyBinder();
    }

    public class MyBinder extends android.os.Binder {
        public MyService getService() {
            return MyService.this;
        }
    }

    CallBackPrintStatus callBackPrintStatus;

    public interface CallBackPrintStatus {
        void printStatusChange(String strStatus);
    }

    public void setCallback(CallBackPrintStatus callback) {
        this.callBackPrintStatus = callback;
    }
}
