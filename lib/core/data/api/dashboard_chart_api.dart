import 'package:circle_task/core/helper/date_time_helper.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class DashboardChartApi {
  Dio dio = Dio();

  Future<dynamic> getChartData({
    required String filter,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      String params = "";
      if (startDate != null) {
        params += "period1=${DateTimeHelper.timeToString(startDate)}";
        params += "&period2=${DateTimeHelper.timeToString(endDate)}";
      } else {
        params += "&interval=$filter";
      }
      params += "&events=history&crumb=5YTX%2FgVGBmg";
      Response response = await dio.get('https://query1.finance.yahoo.com/v7/finance/download/SPUS?$params');

      return response.data;
    } catch (error) {
      rethrow;
    }
  }
}
