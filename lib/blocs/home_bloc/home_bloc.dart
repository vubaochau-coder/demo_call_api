import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:demo_call_api/models/news_model.dart';
import 'package:demo_call_api/repos/api_repository.dart';
import 'package:demo_call_api/repos/hive_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ApiRepository newsRepository;
  final HiveRepository hiveRepository;
  HomeBloc(this.newsRepository, this.hiveRepository)
      : super(const HomeLoadingState(error: '', haveError: false)) {
    on<HomeLoadingEvent>(homeLoading);
    on<HomeFetchedEvent>(
      homeFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  FutureOr<void> homeLoading(
      HomeLoadingEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState(error: '', haveError: false));

    await hiveRepository.init();

    List<NewsModel> locals = hiveRepository.getNews(1);

    if (locals.isNotEmpty) {
      emit(HomeLoadedState(
        newsList: locals,
        currentPage: 1,
        haveError: false,
        error: '',
      ));

      await newsRepository.fetchData(1).then((value) async {
        await hiveRepository.deleteNews(1);
        hiveRepository.addNews(value);
      }).onError((error, stackTrace) {
        emit(HomeLoadedState(
          newsList: locals,
          currentPage: 1,
          haveError: true,
          error: error.toString(),
        ));
      });
    } else {
      await newsRepository.fetchData(1).then((value) async {
        emit(HomeLoadedState(
          newsList: value,
          currentPage: 1,
          haveError: false,
          error: '',
        ));

        hiveRepository.addNews(value);
      }).onError((error, stackTrace) {
        emit(HomeLoadingState(haveError: true, error: error.toString()));
      });
    }
  }

  FutureOr<void> homeFetched(
      HomeFetchedEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoadedState) {
      final currentState = state as HomeLoadedState;

      int currentPage = currentState.currentPage;
      int nextPage = currentPage + 1;

      List<NewsModel> currentNews = List.from(currentState.newsList);

      List<NewsModel> locals = hiveRepository.getNews(nextPage);

      if (locals.isNotEmpty) {
        final datas = List.of(currentNews)..addAll(locals);

        // print('HomeBloc: Fetch from local successful');

        emit(HomeLoadedState(
            newsList: datas,
            currentPage: nextPage,
            haveError: false,
            error: ''));

        await newsRepository.fetchData(nextPage).then((value) async {
          // print('HomeBloc: Save new data successful');

          await hiveRepository.deleteNews(nextPage);
          hiveRepository.addNews(value);
        }).onError((error, stackTrace) {
          // print('HomeBloc: Save new data error');
          emit(HomeLoadedState(
            newsList: datas,
            currentPage: nextPage,
            haveError: true,
            error: error.toString(),
          ));
        });
      } else {
        await newsRepository.fetchData(nextPage).then((value) async {
          // print('HomeBloc: Fetch from api successful');

          final datas = List.of(currentNews)..addAll(value);
          emit(HomeLoadedState(
            newsList: datas,
            currentPage: nextPage,
            haveError: false,
            error: '',
          ));

          hiveRepository.addNews(value);
        }).onError((error, stackTrace) {
          // print('HomeBloc: Fetch from api error');

          emit(HomeLoadedState(
            newsList: currentNews,
            currentPage: currentPage,
            error: error.toString(),
            haveError: true,
          ));
        });
      }
    }
  }
}
