import 'package:demo_call_api/blocs/home_bloc/home_bloc.dart';
import 'package:demo_call_api/screens/home_loading_page.dart';
import 'package:demo_call_api/theme.dart';
import 'package:demo_call_api/widgets/bottom_loader.dart';
import 'package:demo_call_api/widgets/news_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(onScroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController
      ..removeListener(onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My News'),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: const Icon(Icons.menu),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyAppTheme.darkColor,
                MyAppTheme.lightColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoadedState) {
            return FloatingActionButton(
              backgroundColor: MyAppTheme.darkColor.withOpacity(0.6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.keyboard_double_arrow_up_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOut,
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 16),
            child: Text(
              'News',
              style: TextStyle(
                color: MyAppTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.haveError) {
                // print("BlocConsumer: Listen new error");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.error,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red[400],
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    duration: const Duration(seconds: 8),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is HomeLoadingState) {
                return const HomeLoadingPage();
              } else if (state is HomeLoadedState) {
                // print("BlocConsumer: Rebuild HomeLoadedState");
                return Expanded(
                  child: ListView.separated(
                    itemCount: state.newsList.length + 1,
                    padding: const EdgeInsets.only(bottom: 16),
                    controller: scrollController,
                    separatorBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 18),
                        width: double.infinity,
                        height: 1,
                        color: MyAppTheme.darkColor.withOpacity(0.3),
                      );
                    },
                    itemBuilder: (context, index) {
                      return index >= state.newsList.length
                          ? const BottomLoader()
                          : NewsItem(
                              newsData: state.newsList[index],
                            );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('State error'),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void onScroll() {
    if (isBottom) context.read<HomeBloc>().add(HomeFetchedEvent());
  }

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll == maxScroll;
  }
}
