import 'package:flutter/material.dart';
import 'package:RuConnext/global_state/auth_controller.dart';
import 'package:get/get.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Obx(() {
            return UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage:
                      Image.network('${authController.profile['photoUrl']}')
                          .image,
                ),
                accountName: Text('${authController.profile['displayName']}'),
                accountEmail: Text('${authController.profile['email']}'));
          }),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('หน้าหลัก'),
            onTap: () {
              Get.offNamedUntil('/', (route) => false);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.gif_box_rounded),
            title: const Text('สินค้า'),
            onTap: () {
              Get.offNamedUntil('/product', (route) => false);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
