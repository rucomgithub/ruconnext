import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int totalResults = 0;
  List<dynamic> articles = [];
  int page = 1;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 700));
    // if failed,use refreshFailed()
    setState(() {
      articles.clear();
      page = 1;
    });
    getData();
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(const Duration(milliseconds: 500));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (page < (totalResults / 5).ceil()) {
      if (mounted) {
        setState(() {
          page = ++page;
        });
      }
      getData();
      _refreshController.loadComplete();
    } else {
      _refreshController.resetNoData();
      _refreshController.loadNoData();
    }
  }

  Future<void> getData() async {
    try {
      var response = await Dio().get(
          'https://newsapi.org/v2/top-headlines?country=th&apiKey=ab0d4aca4cea481e8157d31c68eb2b23&page=$page&pageSize=5');
      setState(() {
        totalResults = response.data['totalResults'];
        articles.addAll(response.data['articles']); //concat array (List)
      });
    } catch (e) {
      throw Exception('เกิดข้อผิดพลาดจาก Server กรุณาลองใหม่');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: totalResults > 0 ? Text('ทั้งหมด $totalResults ข่าว') : null),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("กำลังโหลดข้อมูล...");
            } else if (mode == LoadStatus.loading) {
              body = const CircularProgressIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("ไม่สามารถโหลดข้อมูลได้ กรุณาลองอีกครั้ง");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("ไม่พบข้อมูลแล้ว...");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
          itemBuilder: (context, index) => Card(
            child: InkWell(
              onTap: () {
                  Get.toNamed('/website', arguments: {
                    'url': articles[index]['url'],
                    'name': articles[index]['source']['name']
                  });
              },
              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: '${articles[index]['urlToImage']}',
                    progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text('${articles[index]['title']}', style: const TextStyle(fontSize: 12)), 
                  )
                ],
              ),
            )
          ),
          itemCount: articles.length,
        ),
      ),
    );
  }
}
