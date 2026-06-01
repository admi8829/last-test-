import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you use other Firebase services in the background, initialize Firebase here.
  // Note: Firebase.initializeApp is already handled in main or GmsAndAdsService 
  // for different platform scenarios, but for a truly robust background handler:
  // await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  Future<void> initialize() async {
    // Check if we already initialized or if in test environment
    if (Platform.environment.containsKey('FLUTTER_TEST')) return;

    try {
      // 0. Ensure Firebase is initialized
      if (Firebase.apps.isEmpty) {
        if (kDebugMode) print("NotificationService: Firebase not initialized. Skipping.");
        return;
      }

      try {
      // 1. Initialize Local Notifications for Foreground
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // For iOS, these are basic permissions
      const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();

      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          // Handle local notification click
          if (response.payload != null) {
            if (kDebugMode) print("Local notification payload: ${response.payload}");
          }
        },
      );

      // Create the channel on Android
      if (Platform.isAndroid) {
        await _localNotifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);
      }

      // 2. Request Permissions
      NotificationSettings settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }

      // 3. Get Token
      // FCM token might fail on non-GMS devices or if setup is incorrect
      try {
        String? token = await _fcm.getToken();
        if (kDebugMode) {
          print("========= FCM TOKEN =========");
          print(token);
          print("=============================");
        }
      } catch (e) {
        if (kDebugMode) print("FCM Token Error: $token");
      }

      // 4. Handle Foreground Messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (kDebugMode) {
          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
        }

        // If notification exists, show it using local notifications
        if (notification != null && !Platform.environment.containsKey('FLUTTER_TEST')) {
          _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android?.smallIcon ?? '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: message.data.toString(),
          );

          if (kDebugMode) {
            print('Message also contained a notification: ${notification.title}');
          }
        }
      });

      // Handle background messages via the top-level handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // 5. Handle Notification Click (when app is in background but opened via notification)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleNotificationClick(message);
      });

      // 6. Handle Notification Click (when app was terminated and opened via notification)
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationClick(initialMessage);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing NotificationService: $e");
      }
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
