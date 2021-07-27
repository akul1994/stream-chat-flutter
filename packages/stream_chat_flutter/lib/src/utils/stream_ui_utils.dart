import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';

class StreamUiUtils {
  static BoxDecoration? getMsgBubbleDecor(bool reverse, bool isCall) {
    if (!isCall) {
      return null;
    }

    // return BoxDecoration(
    //     borderRadius: BorderRadius.circular(8),
    //     border: Border.all(width: 2, color: MainAppColorHelper.black()));

    if (!reverse) {
      return BoxDecoration(
      border: Border(
        right: BorderSide(width: 8.0, color: MainAppColorHelper.black()),
      ));
    } else {
      return BoxDecoration(
          border: Border(
        left: BorderSide(width: 8.0, color: MainAppColorHelper.black()),
      ));
    }
  }

  static Decoration circle_r24 = BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(24),
  );

  static Decoration cardShadow(Color? bgColor) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: <BoxShadow>[
        BoxShadow(
            color: Colors.black12,
            blurRadius: 16.0,
            offset: Offset(0.0, 14.0),
            spreadRadius: -9),
      ],
    );
  }
}
