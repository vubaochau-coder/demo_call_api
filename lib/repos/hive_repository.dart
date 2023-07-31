import 'package:demo_call_api/models/news_model.dart';
import 'package:hive/hive.dart';

class HiveRepository {
  late Box<NewsModel> newsBox;

  Future<void> init() async {
    Hive.registerAdapter(NewsModelAdapter());
    newsBox = await Hive.openBox('news');
  }

  List<NewsModel> getNews(int page) {
    final newsList = newsBox.values.where((element) => element.page == page);
    return newsList.toList();
  }

  void addNews(List<NewsModel> newsList) {
    newsBox.addAll(newsList);
  }

  Future<void> clearNews() async {
    await newsBox.clear();
  }

  Future<void> deleteNews(int page) async {
    for (var element in newsBox.values) {
      if (element.page == page) {
        await element.delete();
      }
    }
  }
}
