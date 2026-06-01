import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> initialize() async {
    // Check if we already initialized or if in test environment (already guarded in main, but let's be safe)
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // 2. Get Token
    String? token = await _fcm.getToken();
    if (kDebugMode) {
      print("========= FCM TOKEN =========");
      print(token);
      print("=============================");
    }

    // 3. Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print('Message also contained a notification: ${message.notification?.title}');
        }
        // You could show a local notification here or an in-app dialog
      }
    });

    // 4. Handle Notification Click (when app is in background but opened via notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationClick(message);
    });

    // 5. Handle Notification Click (when app was terminated and opened via notification)
    RemoteMessage? initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationClick(initialMessage);
    }
  }

  void _handleNotificationClick(RemoteMessage message) {
    if (kDebugMode) {
      print('Notification clicked with data: ${message.data}');
    }
    
    // Example: Navigate based on screen parameter in data
    String? screen = message.data['screen'];
    if (screen == 'profile') {
      navigatorKey.currentState?.pushNamed('/profile');
    } else if (screen == 'settings') {
       navigatorKey.currentState?.pushNamed('/settings');
    }
  }
}
