package com.sinan.lanphone

import android.content.Intent
import android.content.Context
import android.net.wifi.WifiManager
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL = "lan_phone/native"
        private const val EXTRA_CALL_ID = "call_id"
        private const val EXTRA_CALL_ACTION = "call_action"
    }

    private var pendingCallAction: Map<String, String>? = null
    private var methodChannel: MethodChannel? = null
    private var wifiMethodChannel: MethodChannel? = null
    private var multicastLock: WifiManager.MulticastLock? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Do not force the display to remain awake during ordinary app use.
        // Lock-screen/keep-screen flags are enabled only for an active call.
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        )

        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialCallAction" -> {
                    result.success(pendingCallAction)
                    pendingCallAction = null
                }
                "setShowWhenLocked" -> {
                    val enable = call.argument<Boolean>("enable") ?: true
                    if (enable) {
                        showWhenLockedOn()
                        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    } else {
                        showWhenLockedOff()
                        window.clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
                    }
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }

        wifiMethodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "lan_phone/wifi_lock"
        )
        wifiMethodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "acquireMulticastLock" -> {
                    try {
                        val wifi = applicationContext
                            .getSystemService(Context.WIFI_SERVICE) as WifiManager
                        if (multicastLock == null) {
                            multicastLock = wifi.createMulticastLock("LanPhone:Multicast").apply {
                                setReferenceCounted(false)
                            }
                        }
                        if (multicastLock?.isHeld != true) {
                            multicastLock?.acquire()
                        }
                        result.success(true)
                    } catch (error: Exception) {
                        result.error("MULTICAST_LOCK_ERROR", error.message, null)
                    }
                }
                "releaseMulticastLock" -> {
                    try {
                        if (multicastLock?.isHeld == true) {
                            multicastLock?.release()
                        }
                        result.success(true)
                    } catch (error: Exception) {
                        result.error("MULTICAST_UNLOCK_ERROR", error.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }

        pendingCallAction?.let { action ->
            methodChannel?.invokeMethod("onCallActionFromNotification", action)
            pendingCallAction = null
        }
    }

    private fun handleIntent(intent: Intent?) {
        val callId = intent?.getStringExtra(EXTRA_CALL_ID)
        val action = intent?.getStringExtra(EXTRA_CALL_ACTION)

        if (callId != null && action != null) {
            val data = mapOf(
                "callId" to callId,
                "action" to action
            )
            if (methodChannel != null) {
                methodChannel?.invokeMethod("onCallActionFromNotification", data)
            } else {
                pendingCallAction = data
            }
        }
    }

    private fun showWhenLockedOn() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }

    private fun showWhenLockedOff() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            @Suppress("DEPRECATION")
            window.clearFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
            )
        }
    }
    override fun onDestroy() {
        try {
            if (multicastLock?.isHeld == true) multicastLock?.release()
        } catch (_: Exception) {
        }
        multicastLock = null
        super.onDestroy()
    }
}

