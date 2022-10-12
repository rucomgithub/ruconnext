import 'package:flutter/material.dart';
import 'package:RuConnext/pages/about_page.dart';
import 'package:RuConnext/pages/detail_page.dart';
import 'package:RuConnext/pages/home_page.dart';
import 'package:RuConnext/pages/login_page.dart';
import 'package:RuConnext/pages/news_page.dart';
import 'package:RuConnext/pages/product_page.dart';
import 'package:RuConnext/pages/website_page.dart';
import 'package:get/get.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? token;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //check token ว่ามีจริงมั้ย หรือหมดอายุหรือไม่
  SharedPreferences prefs = await SharedPreferences.getInstance();
  token = prefs.getString('token');

  await Firebase.initializeApp();
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter RU',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          canvasColor: const Color(0xffe8eaf6),
          textTheme: const TextTheme(
            headline1:
                TextStyle(fontSize: 40, color: Color.fromRGBO(84, 88, 89, 1.0)),
          )),
      // home: const MyHomePage(),
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => token == null ? const LoginPage() : const MyHomePage()),
        GetPage(name: '/home', page: () => const MyHomePage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/about', page: () => const AboutPage()),
        GetPage(name: '/product', page: () => const ProductPage()),
        GetPage(name: '/detail', page: () => const DetailPage()),
        GetPage(name: '/news', page: () => const NewsPage()),
        GetPage(name: '/website', page: () => const WebsitePage()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
