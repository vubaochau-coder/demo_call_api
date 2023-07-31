import 'package:demo_call_api/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class NewsLoadingItem extends StatelessWidget {
  const NewsLoadingItem({super.key});

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
            child: Shimmer.fromColors(
              baseColor: MyAppTheme.baseShimmer,
              highlightColor: MyAppTheme.hightlightShimmer,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 11,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: MyAppTheme.baseShimmer,
                  highlightColor: MyAppTheme.hightlightShimmer,
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 16, bottom: 4),
                    color: Colors.white,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: MyAppTheme.baseShimmer,
                  highlightColor: MyAppTheme.hightlightShimmer,
                  child: Container(
                    height: 14,
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 4, bottom: 4),
                    color: Colors.white,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: MyAppTheme.baseShimmer,
                  highlightColor: MyAppTheme.hightlightShimmer,
                  child: Container(
                    height: 14,
                    width: 64,
                    color: Colors.white,
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
