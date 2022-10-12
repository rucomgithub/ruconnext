import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:RuConnext/global_state/auth_controller.dart';
import 'package:RuConnext/widgets/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late FirebaseMessaging messaging;
  final _googleSingIn = GoogleSignIn();

  void showFlutterNotification(RemoteMessage event) {
    Get.defaultDialog(
        title: '${event.notification!.title}',
        content: Text('${event.notification!.body}'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('ตกลง'))
        ]);
  }

  @override
  void initState() {
    super.initState();
    // print("init state");
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) => print('Token: $value'));

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    // ตอนผู้ใช้กดที่ notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      Get.toNamed('/news');
    });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('profile');

    await _googleSingIn.disconnect();

    Get.offNamedUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // print("build");
    return Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(
          title: Image.asset('assets/images/logo.png', height: 40),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetX<AuthController>(
                    init: AuthController(),
                    builder: (controller) {
                      return Text(
                          'สวัสดีคุณ ${controller.profile['displayName']}');
                    }),
              ],
            )),
            Expanded(
              flex: 8,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 5,
                mainAxisSpacing: 10,
                crossAxisCount: 3,
                children: <Widget>[
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/about');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text('เกี่ยวกับเรา',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/news');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.newspaper),
                          Text('ข่าวสาร',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/about');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text('เกี่ยวกับเรา',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/about');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text('เกี่ยวกับเรา',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/about');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text('เกี่ยวกับเรา',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                  OutlinedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.orange.shade300)),
                      onPressed: () {
                        Get.toNamed('/about');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          Text('เกี่ยวกับเรา',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ));
  }
}
