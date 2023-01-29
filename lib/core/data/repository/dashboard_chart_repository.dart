import 'package:circle_task/core/data/api/dashboard_chart_api.dart';
import 'package:circle_task/core/data/enum/dashboard_filter.dart';
import 'package:circle_task/core/data/model/chart_item.dart';
import 'package:csv/csv.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardChartRepository {
  DashboardChartRepository(this._dashboardChartApi);
  final DashboardChartApi _dashboardChartApi;

  Future<List<ChartItem>> getChartData({
    required DashboardFilter filter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    String rowsAsListOfValues = await _dashboardChartApi.getChartData(
      filter: filter.value!,
      startDate: startDate,
      endDate: endDate,
    );
    List<dynamic> list = CsvToListConverter().convert(rowsAsListOfValues, eol: '\n');
    final List<ChartItem> listChart = [];
    for (int i = 1; i < list.length; i++) {
      listChart.add(ChartItem(
        date: DateTime.parse(list[i][0]),
        open: list[i][1],
        high: list[i][2],
        low: list[i][3],
        close: list[i][4],
        adjClose: list[i][5],
        volume: list[i][6],
      ));
    }

    return listChart;
  }
}
