import 'package:demo_call_api/models/news_model.dart';
import 'package:dio/dio.dart';

class ApiRepository {
  final String url = "http://54.226.141.124/intern/news?page=";
  final dio = Dio();

  Future<List<NewsModel>> fetchData(int page) async {
    try {
      var response = await dio.get(url + page.toString());

      final data = response.data as List;
      List<NewsModel> result = [];

      for (var ele in data) {
        result.add(NewsModel.fromJson(ele, page));
      }

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
