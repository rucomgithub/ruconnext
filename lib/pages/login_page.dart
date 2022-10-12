import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _googleSingIn = GoogleSignIn();

  Future<void> login(Map<dynamic, dynamic>? formValue) async {
    // print(formValue);
    var user = await _googleSingIn.signIn();
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var profile = {
        'displayName': user.displayName,
        'email': user.email,
        'photoUrl': user.photoUrl
      };
      await prefs.setString('profile', jsonEncode(profile));

      //get token from server
      var response = await Dio().post(
          'https://api.codingthailand.com/api/login',
          data: {'email': 'ake@gmail.com', 'password': '123456'});
      // print(response.data);
      await prefs.setString('token', jsonEncode(response.data));

      //ไปที่หน้า home
      Get.offNamedUntil('/home', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orange],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 30, 15, 15),
                    child: Column(
                      children: [
                        Image.asset('assets/images/logo.png', height: 80),
                        const SizedBox(height: 40),
                        FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.always,
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                name: 'email',
                                maxLines: 1,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'ป้อนข้อมูลอีเมล์ด้วย'),
                                  FormBuilderValidators.email(
                                      errorText: 'รูปแบบอีเมล์ไม่ถูกต้อง'),
                                ]),
                              ),
                              const SizedBox(height: 30),
                              FormBuilderTextField(
                                name: 'password',
                                maxLines: 1,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: 'ป้อนข้อมูลรหัสผ่านด้วย'),
                                  FormBuilderValidators.minLength(3,
                                      errorText:
                                          'รหัสผ่านต้อง 3 ตัวอักษรขึ้นไป')
                                ]),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              height: 50,
                              color: Colors.blueGrey,
                              textColor: Colors.white,
                              child: const Text('เข้าระบบ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              onPressed: () {
                                _formKey.currentState!.save();
                                if (_formKey.currentState!.validate()) {
                                  // print(_formKey.currentState!.value);
                                  login(_formKey.currentState!.value);
                                }
                              },
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GoogleAuthButton(
                          onPressed: () {
                            login(null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
