import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';
import 'package:stream_chat_flutter/src/utils/stream_ui_utils.dart';

/// It shows a date divider depending on the date difference
class DateDivider extends StatelessWidget {
  final DateTime dateTime;
  final bool uppercase;

  const DateDivider({
    Key? key,
    required this.dateTime,
    this.uppercase = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdAt = Jiffy(dateTime);
    final now = DateTime.now();

    String dayInfo;
    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'Today';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(Duration(days: 1)), Units.DAY)) {
      dayInfo = 'Yesterday';
    } else if (Jiffy(createdAt).isAfter(
      now.subtract(Duration(days: 7)),
      Units.DAY,
    )) {
      dayInfo = createdAt.EEEE;
    } else if (Jiffy(createdAt).isAfter(
      Jiffy(now).subtract(years: 1),
      Units.DAY,
    )) {
      dayInfo = createdAt.MMMd;
    } else {
      dayInfo = createdAt.MMMd;
    }

    if (uppercase) dayInfo = dayInfo.toUpperCase();

    return Center(
      child: Container(
        //decoration: StreamUiUtils.circle_r24,
       // color: MainAppColorHelper.blueGrayBG(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: MainAppColorHelper.blueGrayBG(),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          dayInfo,
          style: StreamChatTheme.of(context).textTheme!.footnote.copyWith(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 14
              ),
        ),
      ),
    );
  }
}
