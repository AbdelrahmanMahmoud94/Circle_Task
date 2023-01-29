// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:circle_task/core/bloc/bloc/home_bloc.dart' as _i5;
import 'package:circle_task/core/data/api/dashboard_chart_api.dart' as _i3;
import 'package:circle_task/core/data/repository/dashboard_chart_repository.dart'
    as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of main-scope dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  gh.factory<_i3.DashboardChartApi>(() => _i3.DashboardChartApi());
  gh.factory<_i4.DashboardChartRepository>(
      () => _i4.DashboardChartRepository(gh<_i3.DashboardChartApi>()));
  gh.factory<_i5.HomeBloc>(
      () => _i5.HomeBloc(gh<_i4.DashboardChartRepository>()));
  return getIt;
}
