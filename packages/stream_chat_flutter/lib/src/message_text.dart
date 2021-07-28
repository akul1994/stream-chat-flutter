import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/utils/StreamUtils.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'stream_chat_theme.dart';
import 'utils.dart';

enum MessageLengthState { normal, clipped, full }

class MessageText extends StatefulWidget {
  const MessageText({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.onMentionTap,
    this.onLinkTap,
  }) : super(key: key);

  final Message message;
  final void Function(User?)? onMentionTap;
  final void Function(String)? onLinkTap;
  final MessageTheme? messageTheme;

  @override
  _MessageTextState createState() => _MessageTextState();
}

class _MessageTextState extends State<MessageText> {
  var messageLengthState = MessageLengthState.normal;

  String? messageText;

  String? firstHalfText;

  String? messageToShow;

  @override
  void initState() {
    messageText =
        _replaceMentions(widget.message.text)!.replaceAll('\n', '\\\n');

    //messageText = _replaceHashtags(widget.message.text);
    messageText = _replacePlus(messageText!);
    messageText = _replaceDollar(messageText!);

    if (messageText!.length > 1000) {
      firstHalfText = messageText!.substring(0, 1000) + '...';
      messageToShow = firstHalfText;
      messageLengthState = MessageLengthState.clipped;
    } else {
      messageToShow = messageText;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minWidth: 72),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: messageToShow!,
            onTapLink: (
              String link,
              String? href,
              String title,
            ) {
              if (link.startsWith('@')) {
                final mentionedUser = widget.message.mentionedUsers.firstWhereOrNull(
                  (u) => '@${u.name}' == link,
                );

                if (widget.onMentionTap != null) {
                  widget.onMentionTap!(mentionedUser);
                } else {
                  print('tap on ${mentionedUser!.name}');
                }
              } else {
                if (widget.onLinkTap != null) {
                  widget.onLinkTap!(link);
                } else {
                  launchURL(context, link);
                }
              }
            },
            styleSheet: MarkdownStyleSheet.fromTheme(
              Theme.of(context).copyWith(
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: widget.messageTheme!.messageText!.color,
                      decoration: widget.messageTheme!.messageText!.decoration,
                      decorationColor:
                          widget.messageTheme!.messageText!.decorationColor,
                      decorationStyle:
                          widget.messageTheme!.messageText!.decorationStyle,
                      fontFamily: widget.messageTheme!.messageText!.fontFamily,
                    ),
              ),
            ).copyWith(
              a: widget.messageTheme!.messageLinks,
              p: widget.messageTheme!.messageText,
            ),
          ),
          if (messageLengthState != MessageLengthState.normal)
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
              child: InkWell(
                  onTap: () {
                    onShowMoreClick();
                  },
                  child: Text(
                    getShowMoreText(),
                    style: widget.messageTheme!.messageText!
                        .copyWith(color: Colors.blue),
                  )),
            )
        ],
      ),
    );
  }

  String? onShowMoreClick() {
    if (messageLengthState == MessageLengthState.clipped) {
      setState(() {
        messageLengthState = MessageLengthState.full;
        messageToShow = messageText;
      });
    } else {
      setState(() {
        messageLengthState = MessageLengthState.clipped;
        messageToShow = firstHalfText;
      });
    }
  }

  String getShowMoreText() {
    switch (messageLengthState) {
      case MessageLengthState.normal:
        return '';
        break;
      case MessageLengthState.clipped:
        return 'Show More';
        break;
      case MessageLengthState.full:
        return 'Show Less';
        break;
    }
  }

  String? _replaceMentions(String? text) {
    widget.message.mentionedUsers
        ?.map((u) => StreamUtils.getUserName(u))
        ?.toSet()
        ?.forEach((userName) {
      text = text!.replaceAll(
          '@$userName', '[@$userName](@${userName!.replaceAll(' ', '')})');
    });
    return text;
  }

  /*String _replaceMentions(String text) {
    widget.message.mentionedUsers?.map((u) => StreamUtils.getUserName(u))?.toSet()?.forEach((userName) {
      text = text.replaceAll(
          '@$userName', '***@${userName.replaceAll(' ', '')}***');
    });
    return text;
  }*/

  String _replaceHashtags(String text) {
    RegExp exp = new RegExp(r"\B#\w\w+");
    exp.allMatches(text).forEach((match) {
      var replText =
          '[${match.group(0)}](${match.group(0)!.replaceAll(' ', '')})'
              .toUpperCase();
      text = text.replaceAll('${match.group(0)}', replText);
    });
    return text;
  }

  String _replaceDollar(String text) {
    RegExp exp = new RegExp(r"\$(\w+)");
    exp.allMatches(text).forEach((match) {
      var replText =
          '[${match.group(0)}](${match.group(0)!.replaceAll(' ', '')})'
              .toUpperCase();
      text = text.replaceAll('${match.group(0)}', replText);
    });
    return text;
  }

  String _replacePlus(String text) {
    RegExp exp = new RegExp(r"\+(\w+)");
    exp.allMatches(text).forEach((match) {
      var replText =
          '[${match.group(0)}](${match.group(0)!.replaceAll(' ', '')})'
              .toUpperCase();
      text = text.replaceAll('${match.group(0)}', replText);
    });
    return text;
  }
}
