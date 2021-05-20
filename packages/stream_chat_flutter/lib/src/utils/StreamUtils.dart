import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class StreamUtils
{
  static String getDay(DateTime dateTime) {
    if (dateTime == null) return null;
    var now = DateTime.now();

    return DateFormat.jm().format(dateTime);

    if (DateTime(dateTime.year, dateTime.month, dateTime.day) ==
        DateTime(now.year, now.month, now.day)) {
      return DateFormat.jm().format(dateTime);
    } else if (DateTime(now.year, now.month, now.day)
        .difference(dateTime)
        .inDays <
        6) {
      return DateFormat.E().format(dateTime) + ','+DateFormat.jm().format(dateTime);
    } else {
      var newFormat = DateFormat("dd/MMM/yy");
      return newFormat.format(dateTime) + ','+DateFormat.jm().format(dateTime);
      return 'on ${Jiffy(dateTime).format("MMM do")}';
    }
  }
}