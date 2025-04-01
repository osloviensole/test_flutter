package test.demo;

import android.app.Application;
import android.content.ComponentName;
import android.content.Intent;
import android.os.Handler;
import android.util.Log;
import android.widget.Toast;

import com.ciontek.hardware.aidl.AidlErrorCodeV2;
import com.ciontek.hardware.aidl.emv.EMVOptV2;
import com.ciontek.hardware.aidl.ped.PedOpt;
import com.ciontek.hardware.aidl.pinpad.PinpadOpt;
import com.ciontek.hardware.aidl.print.PrinterOpt;
import com.ciontek.hardware.aidl.readcard.ReadCardOptV2;
import com.ciontek.hardware.aidl.sysCard.SysCardOpt;
import com.ciontek.hardware.aidl.system.SysBaseOpt;
import com.ciontek.hardware.aidl.tax.TaxOpt;
import com.ctk.sdk.DebugLogUtil;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import pos.paylib.posPayKernel;
import pos.paylib.keypad.PinpadManage;

public class MyApplication extends Application {
    private static final String TAG = "MyApplication";

    public static MyApplication app;

    public SysBaseOpt basicOpt;
    public ReadCardOptV2 readCardOpt;
    public PinpadOpt pinPadOpt;
    public PedOpt pedOpt;
    public PrinterOpt printerOpt;
    public TaxOpt taxOpt;
    public EMVOptV2 emvOpt;
    public SysCardOpt syscardOpt;

    private posPayKernel mPosPayKernel;
    public volatile boolean isConnect;
    private Set<OnServiceConnectListener> listeners;
    private Handler handler = new Handler();

    public volatile int newTransFlag = 0;
    public boolean autoTest;

    public static byte Tdes = 0;
    public static byte KlkTdes = 1;
    public static byte AESMKSK = 2;
    public static byte TDESMKSK = 3;
    public static byte Dukpt = 4;
    public static byte AESDukpt = 5;
    public static byte TDESDukpt = 6;

    private String mcu_update_path;
    private boolean isSPNFC = true;

    @Override
    public void onCreate() {
        super.onCreate();
        app = this;
        listeners = new CopyOnWriteArraySet<>();

        Log.i(TAG, "✅ L'application démarre... Initialisation du SDK POS");
        connectPayService(false);
        sendBroadCast(1);
    }

    /**
     * Connexion au SDK POS et initialisation de `printerOpt`
     */
    public void connectPayService(boolean showToast) {
//        DebugLogUtil.e(TAG, "📡 Connexion au SDK POS...");
//        if (showToast) {
//            Toast.makeText(this, "Connexion à l'imprimante en cours...", Toast.LENGTH_SHORT).show();
//        }
        mPosPayKernel = posPayKernel.getInstance();
        mPosPayKernel.initPaySDK(this, mConnectCallback);
        checkServiceConnectivity(30000);
    }

    private posPayKernel.ConnectCallback mConnectCallback = new posPayKernel.ConnectCallback() {
        @Override
        public void onConnectPaySDK() {
            DebugLogUtil.e(TAG, "✅ Connexion au SDK POS réussie !");
            try {
                isConnect = true;
                emvOpt = mPosPayKernel.mEmvOpt;
                basicOpt = mPosPayKernel.mBasicOpt;
                pinPadOpt = mPosPayKernel.mPinpadOpt;
                readCardOpt = mPosPayKernel.mReadcardOpt;
                pedOpt = mPosPayKernel.mPedOpt;
                taxOpt = mPosPayKernel.mTaxOpt;
                printerOpt = mPosPayKernel.mPrintOpt;
                syscardOpt = mPosPayKernel.mSysCardOpt;

                if (printerOpt != null) {
                    Log.i(TAG, "✅ Imprimante POS détectée et prête.");
                } else {
                    Log.e(TAG, "❌ `printerOpt` est NULL après la connexion au SDK !");
                }

                notifyServiceConnect();
            } catch (Exception e) {
                Log.e(TAG, "❌ Erreur lors de la connexion au SDK POS : " + e.getMessage());
            }
        }

        @Override
        public void onDisconnectPaySDK() {
            DebugLogUtil.e(TAG, "⚠️ Déconnexion du SDK POS !");
            isConnect = false;
            emvOpt = null;
            basicOpt = null;
            pinPadOpt = null;
            readCardOpt = null;
            pedOpt = null;
            taxOpt = null;
            printerOpt = null;
            syscardOpt = null;

            checkServiceConnectivity(0);
        }
    };

    public void disconnectPayService() {
        DebugLogUtil.e(TAG, "🔌 Déconnexion du SDK POS...");
        if (mPosPayKernel != null) {
            mPosPayKernel.destroyPaySDK();
        }
    }

    private void checkServiceConnectivity(long delayMillis) {
        handler.postDelayed(() -> {
            if (!isConnect) {
                connectPayService(true);
            }
        }, delayMillis);
    }

    private void notifyServiceConnect() {
        handler.post(() -> {
            for (OnServiceConnectListener listener : listeners) {
                listener.onServiceConnect();
            }
        });
    }

    public void registerServiceConnectListener(OnServiceConnectListener l) {
        if (l != null) {
            listeners.add(l);
        }
    }

    public void unregisterServiceConnectListener(OnServiceConnectListener l) {
        listeners.remove(l);
    }

    private void sendBroadCast(int debugMode) {
        Intent intent1 = new Intent("security.action.set_mode_success");
        intent1.setComponent(new ComponentName("com.android.systemui", "com.android.systemui.SecurityModeReceiver"));
        intent1.putExtra("mode", debugMode);
        sendBroadcast(intent1);

        Intent intent2 = new Intent("security.action.set_mode_success");
        intent2.setComponent(new ComponentName("com.android.settings", "com.android.settings.SecurityModeReceiver"));
        intent2.putExtra("mode", debugMode);
        sendBroadcast(intent2);
    }

    public interface OnServiceConnectListener {
        void onServiceConnect();
    }

    public String getMcuUpdataPath() {
        return mcu_update_path;
    }

    public boolean getSpNfc() {
        return this.isSPNFC;
    }
}
