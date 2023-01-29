import 'package:bloc/bloc.dart';
import 'package:circle_task/core/data/enum/dashboard_filter.dart';
import 'package:circle_task/core/data/model/chart_item.dart';
import 'package:circle_task/core/data/repository/dashboard_chart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._dashboardChartRepository) : super(HomeInitialState()) {
    on<HomeInitiateEvent>(_homeInitiateEvent);
    on<HomeLoadEvent>(_homeLoadEvent);
  }
  DashboardChartRepository _dashboardChartRepository;
  void _homeInitiateEvent(HomeInitiateEvent event, Emitter<HomeState> emit) {
    emit(HomeInitialState());
  }

  Future<void> _homeLoadEvent(HomeLoadEvent event, Emitter<HomeState> emit) async {
    try {
      emit(HomeLoadingState());
      List<ChartItem> chartItems = await _dashboardChartRepository.getChartData(
        filter: event.filter,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(HomeReadyState(chartList: chartItems));
    } catch (error) {
      rethrow;
    }
  }
}
