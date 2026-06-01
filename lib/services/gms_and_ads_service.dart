import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_api_availability/google_api_availability.dart';

class GmsAndAdsService {
  static bool isGmsAvailable = false;
  static bool isFirebaseInitialized = false;
  static String? fcmToken;
  static String? statusMessage;

  /// Starts asynchronous background initialization of GMS, Firebase and AdMob.
  /// This ensures absolutely zero startup lag or UI freezes.
  static void initializeBackground() {
    statusMessage = "Starting system checklist...";
    Future.microtask(() async {
      try {
        await initializeServices();
      } catch (e) {
        statusMessage = "Encountered initial error: $e";
        if (kDebugMode) {
          print("Error in background helper initialization: $e");
        }
      }
    });
  }

  /// Check GMS, initialize Firebase & AdMob safely
  static Future<void> initializeServices() async {
    // 1. Perform GMS check (safely handling errors)
    isGmsAvailable = await _checkGmsAvailability();
    
    if (!isGmsAvailable) {
      statusMessage = "Non-GMS Device detected. Safe Mode active.";
      if (kDebugMode) {
        print("GMS/Google Play Services are missing or unavailable. Skipping Firebase and AdMob initialization cleanly.");
      }
      return;
    }

    statusMessage = "GMS Verified. Initializing services...";
    if (kDebugMode) {
      print("GMS/Google Play Services are available. Proceeding with Firebase and AdMob initialization.");
    }

    // 2. Initialize Firebase Core
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: _currentFirebaseOptions,
        );
      }
      isFirebaseInitialized = true;
      if (kDebugMode) {
        print("Firebase successfully initialized.");
      }
      
      // Request and setup Firebase Push Notifications
      await _setupNotifications();
    } catch (e) {
      statusMessage = "Firebase error: $e";
      if (kDebugMode) {
        print("Failed to initialize Firebase: $e");
      }
    }
  }

  /// Show the preloaded interstitial ad or call the onDismissed callback if not loaded
  static void showInterstitialAd(VoidCallback onDismissed) {
    onDismissed();
  }

  /// Private helper to check GMS availability
  static Future<bool> _checkGmsAvailability() async {
    if (!Platform.isAndroid) {
      // Non-Android platforms are not constrained by Google Play Services
      return true;
    }
    try {
      final dynamic googleApiCheck = GoogleApiAvailability.instance;
      final dynamic availability = await googleApiCheck.checkPlayServicesAvailability();
      return availability.toString().contains('success');
    } catch (e) {
      if (kDebugMode) {
        print("Exception during GMS check: $e");
      }
      return false;
    }
  }

  /// Set up push notifications
  static Future<void> _setupNotifications() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permissions (especially useful for iOS & Android 13+)
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        print('User notification permission status: ${settings.authorizationStatus}');
      }

      // Get FCM token
      fcmToken = await messaging.getToken();
      if (kDebugMode) {
        print("FCM Token: $fcmToken");
      }

      // Handle background or foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('FCM Foreground: Message data: ${message.data}');
        }
        if (message.notification != null && kDebugMode) {
          print('FCM Title: ${message.notification?.title}');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error during notifications setup: $e");
      }
    }
  }

  /// Return current platform appropriate firebase options
  static FirebaseOptions get _currentFirebaseOptions {
    if (Platform.isIOS) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyBbDTLG9q0yCzXA-vzffB2hwSRoDeaXymA',
        appId: '1:629000096457:ios:ca9e524da1729a4afedb18',
        messagingSenderId: '629000096457',
        projectId: 'smart-x-academy',
        storageBucket: 'smart-x-academy.firebasestorage.app',
        iosBundleId: 'com.smartxacademy.app',
      );
    }
    return const FirebaseOptions(
      apiKey: 'AIzaSyBbDTLG9q0yCzXA-vzffB2hwSRoDeaXymA',
      appId: '1:629000096457:android:ca9e524da1729a4afedb18',
      messagingSenderId: '629000096457',
      projectId: 'smart-x-academy',
      storageBucket: 'smart-x-academy.firebasestorage.app',
    );
  }
}
