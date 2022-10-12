

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var profile = {}.obs;

  Future<void> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profile.value = jsonDecode(prefs.getString('profile')!);
    // ${profile['email']}
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

}