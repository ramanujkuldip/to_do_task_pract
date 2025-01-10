import 'package:intl/intl.dart';

class Utils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static convertTimeStampToDateTime(int timeStamp) {
    return DateFormat("dd/MM/yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp));
  }

  static convertDateTimeToTimeStamp(String date) {
    return DateFormat("dd/MM/yyyy").parse(date).millisecondsSinceEpoch;
  }
}
