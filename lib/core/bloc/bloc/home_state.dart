part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeReadyState extends HomeState {
  HomeReadyState({this.chartList});
  final List<ChartItem>? chartList;
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}
