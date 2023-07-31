import 'package:demo_call_api/blocs/home_bloc/home_bloc.dart';
import 'package:demo_call_api/repos/api_repository.dart';
import 'package:demo_call_api/repos/hive_repository.dart';
import 'package:demo_call_api/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => ApiRepository()),
        RepositoryProvider(create: (context) => HiveRepository()),
      ],
      child: BlocProvider(
        create: (context) => HomeBloc(
            RepositoryProvider.of<ApiRepository>(context),
            RepositoryProvider.of<HiveRepository>(context))
          ..add(HomeLoadingEvent()),
        child: MaterialApp(
          title: 'Call API',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
