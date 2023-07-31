import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_call_api/models/news_model.dart';
import 'package:demo_call_api/theme.dart';
import 'package:demo_call_api/utils/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsItem extends StatelessWidget {
  final NewsModel newsData;
  const NewsItem({super.key, required this.newsData});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.only(right: 10),
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: newsData.imgURL,
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: MyAppTheme.hightlightShimmer,
                        image: const DecorationImage(
                          image: AssetImage(
                            'images/exclamation.png',
                          ),
                          fit: BoxFit.scaleDown,
                          opacity: 0.3,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: MyAppTheme.baseShimmer,
                      highlightColor: MyAppTheme.hightlightShimmer,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 6,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyAppTheme.badgeColor,
                    ),
                    child: Image.asset(
                      'images/news.png',
                      width: 14,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 11,
            child: Column(
              children: [
                Text(
                  newsData.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: MyAppTheme.darkColor,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                // const Spacer(),
                const SizedBox(height: 2),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final remainingHeight = constraints.biggest.height;
                      final maxLines = (remainingHeight / (12 * 1.2)).floor();
                      return Text(
                        newsData.summary,
                        maxLines: maxLines,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MyAppTheme.darkColor,
                          fontSize: 12,
                          height: 1.2,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 2),
                  child: Text(
                    DateConverter().convertUTC(newsData.modifiedAt),
                    style: TextStyle(
                      color: MyAppTheme.darkColor,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
