import 'package:demo_call_api/theme.dart';
import 'package:demo_call_api/widgets/news_loading_item.dart';
import 'package:flutter/material.dart';

class HomeLoadingPage extends StatelessWidget {
  const HomeLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        itemCount: 6,
        separatorBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
            width: double.infinity,
            height: 1,
            color: MyAppTheme.darkColor.withOpacity(0.3),
          );
        },
        itemBuilder: (context, index) {
          return const NewsLoadingItem();
        },
      ),
    );
  }
}
