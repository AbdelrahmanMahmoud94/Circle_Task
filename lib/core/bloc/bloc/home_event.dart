part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitiateEvent extends HomeEvent {
  HomeInitiateEvent();
  @override
  List<Object> get props => <Object>[];
}

class HomeLoadEvent extends HomeEvent {
  HomeLoadEvent({
    required this.filter,
    this.startDate,
    this.endDate,
  });
  DashboardFilter filter;
  DateTime? startDate;
  DateTime? endDate;
  List<Object> get props => <Object>[
        filter,
        startDate!,
        endDate!,
      ];
}
