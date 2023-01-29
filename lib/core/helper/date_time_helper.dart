import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDateTime(
    DateTime dateTime, {
    String format = 'hh:mm a - dd MMM yyyy',
    String? languageCode,
  }) {
    final DateFormat formatter = DateFormat(format);
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  

  
  static String? timeToString(DateTime? time) {
    return time!.millisecondsSinceEpoch.toString().substring(0, 10);
  }
}
