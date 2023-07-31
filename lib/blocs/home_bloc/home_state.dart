part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  final bool haveError;
  final String error;
  const HomeState({required this.haveError, required this.error});

  @override
  List<Object> get props => [haveError, error];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState({required super.haveError, required super.error});
}

class HomeLoadedState extends HomeState {
  final List<NewsModel> newsList;
  final int currentPage;

  const HomeLoadedState({
    required this.newsList,
    required this.currentPage,
    required super.error,
    required super.haveError,
  });

  @override
  List<Object> get props => [newsList, currentPage, haveError, error];
}
