import 'package:intl/intl.dart';

class DateConverter {
  final DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
  final DateFormat stringFormat = DateFormat('MMM dd, yyyy');

  String convertUTC(String utc) {
    DateTime temp = dateFormat.parse(utc);

    return stringFormat.format(temp);
  }
}
