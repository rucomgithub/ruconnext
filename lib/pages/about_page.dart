import 'package:flutter/material.dart';
import 'package:RuConnext/global_state/auth_controller.dart';
import 'package:get/get.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เกี่ยวกับเรา')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetX<AuthController>(builder: (controller) {
              return Column(
                children: [
                  Text('Email: ${controller.profile['email']}'),
                  Image.network('${controller.profile['photoUrl']}')
                ],
              );
            }),
            Image.asset('assets/images/building.png'),
            SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('สำนักคอมพิวเตอร์ ม.รามคำแหง',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const Divider(),
                  const Text(
                      'ปณิธาน คือ มุ่งนำเทคโนโลยีสมัยใหม่ไปประยุกต์กับงานอย่างเหมาะสม เพื่อส่งเสริมการผลิตบัณฑิตให้มีคุณภาพ และมีความรู้คู่คุณธรรม'),
                  const Divider(),
                  Row(
                    children: [
                      const Expanded(
                          child: Icon(Icons.sunny, color: Colors.orange)),
                      Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('admin@ru.ac.th'),
                              Text(
                                  '282 ถนนรามคำแหง แขวงหัวหมาก เขตบางกะปิ กรุงเทพมหานคร 10240')
                            ],
                          ))
                    ],
                  ),
                  const Divider(),
                  Wrap(
                    spacing: 5,
                    children: List.generate(
                        20,
                        (index) => Chip(
                              label: Text('${index + 1}'),
                              avatar: const Icon(Icons.calendar_today),
                              backgroundColor: Colors.orange[200],
                            )),
                  ),
                  const Divider(),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/me.png'),
                            radius: 40),
                        const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/me.png'),
                            radius: 40),
                        const CircleAvatar(
                            backgroundImage: AssetImage('assets/images/me.png'),
                            radius: 40),
                        SizedBox(
                          width: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Icon(Icons.home),
                              Icon(Icons.face),
                              Icon(Icons.nature),
                            ],
                          ),
                        )
                      ])
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
