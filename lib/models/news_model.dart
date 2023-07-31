import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: 1)
class NewsModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String summary;

  @HiveField(3)
  final String modifiedAt;

  @HiveField(4)
  final String imgURL;

  @HiveField(5)
  final int page;

  NewsModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.modifiedAt,
    required this.imgURL,
    required this.page,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json, int page) {
    return NewsModel(
      id: json['storyId'],
      title: json['title'],
      summary: json['summary'],
      modifiedAt: json['modifiedAt'],
      imgURL: json['image'],
      page: page,
    );
  }
}
