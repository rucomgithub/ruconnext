import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:RuConnext/widgets/menu_drawer.dart';

import 'package:get/get.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<dynamic> products = [];
  Future<List<dynamic>>? getDataFuture;

  Future<List<dynamic>> getData() async {
    try {
      var response =
          await Dio().get('https://api.codingthailand.com/api/course');
      products = response.data['data'];
      return products;
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดจาก Server กรุณาลองใหม่');
    }
  }

  @override
  void initState() {
    super.initState();
    getDataFuture = getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MenuDrawer(),
        appBar: AppBar(title: const Text('Product')),
        body: FutureBuilder<List<dynamic>>(
          future: getDataFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      onTap: () {
                        Get.toNamed('/detail', arguments: {
                          'id': snapshot.data![index]['id'],
                          'title': snapshot.data![index]['title']
                        });
                      },
                      leading: ConstrainedBox(
                        constraints: const BoxConstraints(
                            maxHeight: 80,
                            maxWidth: 80,
                            minHeight: 80,
                            minWidth: 80),
                        child: Image.network(
                            '${snapshot.data![index]['picture']}',
                            fit: BoxFit.cover),
                      ),
                      title: Text('${snapshot.data![index]['title']}'),
                      subtitle: Text('${snapshot.data![index]['detail']}'),
                      trailing: Chip(
                        label: Text('${snapshot.data![index]['view']}'),
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) => const Divider()),
                  itemCount: snapshot.data!.length);
            } else if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
