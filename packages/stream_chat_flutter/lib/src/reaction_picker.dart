import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';

import '../stream_chat_flutter.dart';
import 'extension.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker_paint.png)
///
/// It shows a reaction picker
///
/// Usually you don't use this widget as it's one of the default widgets used by [MessageWidget.onMessageActions].

class ReactionPicker extends StatefulWidget {
  const ReactionPicker({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.reactionIcons,
  }) : super(key: key);

  final Message message;
  final MessageTheme? messageTheme;
  final List<ReactionIcon>? reactionIcons;

  @override
  _ReactionPickerState createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker>
    with TickerProviderStateMixin {
  List<EzAnimation> animations = [];

  Map<String, int>? reactionScores;

  @override
  void initState() {
    reactionScores = widget.message.reactionScores;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reactionIcons =
        widget.reactionIcons ?? StreamChatTheme.of(context).reactionIcons!;

    return Material(
      borderRadius: BorderRadius.circular(24),
      color: StreamChatTheme.of(context).colorTheme!.white,
      // clipBehavior: Clip.hardEdge,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: reactionIcons
            .map<Widget>((reactionIcon) {
              final ownReactionIndex = widget.message.ownReactions?.indexWhere(
                      (reaction) => reaction.type == reactionIcon.type) ??
                  -1;
              var index = reactionIcons.indexOf(reactionIcon);

              var count = getReactionScore(reactionIcon.type);

              return Container(
                width: 40,
                height: 40,
                //color : MainAppColorHelper.orange(),
                child: RawMaterialButton(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  // clipBehavior: Clip.none,
                  // shape: ContinuousRectangleBorder(
                  //   borderRadius: BorderRadius.circular(16),
                  // ),
                  child: reactionIcon.emoji == null
                      ? StreamSvgIcon(
                          assetName: reactionIcon.assetName,
                          width: 18,
                          height: 18,
                          color: MainAppColorHelper.orange(),
                          // (!highlightOwnReactions ||
                          //         reaction.user.id == StreamChat.of(context).user.id)
                          //     ? StreamChatTheme.of(context).colorTheme.accentBlue
                          //     : StreamChatTheme.of(context)
                          //         .colorTheme
                          //         .black
                          //         .withOpacity(.5),
                        )
                      : Text(
                          reactionIcon.emoji!,
                          style: TextStyle(fontSize: 16),
                        ),
                  onPressed: () {
                    if (ownReactionIndex != -1) {
                      removeReaction(
                        context,
                        widget.message.ownReactions![ownReactionIndex],
                      );
                    } else {
                      sendReaction(
                        context,
                        reactionIcon.type!,
                      );
                    }
                  },
                ),
              );
            })
            .insertBetween(SizedBox(
              width: 0,
            ))
            .toList(),
      ),
    );

    //TODO : Emoi animation code

    if (animations.isEmpty && reactionIcons.isNotEmpty) {
      reactionIcons.forEach((element) {
        animations.add(
          EzAnimation.tween(
            Tween(begin: 0.0, end: 1.0),
            Duration(milliseconds: 500),
            curve: Curves.easeInOutBack,
          ),
        );
      });

      triggerAnimations();
    }

    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeInOutBack,
        duration: Duration(milliseconds: 500),
        builder: (context, val, wid) {
          return Transform.scale(
            scale: val,
            child: Material(
              borderRadius: BorderRadius.circular(24),
              color: StreamChatTheme.of(context).colorTheme!.white,
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: reactionIcons
                      .map<Widget>((reactionIcon) {
                        final ownReactionIndex = widget.message.ownReactions
                                ?.indexWhere((reaction) =>
                                    reaction.type == reactionIcon.type) ??
                            -1;
                        var index = reactionIcons.indexOf(reactionIcon);

                        var count = getReactionScore(reactionIcon.type);

                        return ConstrainedBox(
                          constraints: BoxConstraints.tightFor(
                            height: 24,
                            width: 24,
                          ),
                          child: RawMaterialButton(
                            elevation: 0,
                            padding: const EdgeInsets.all(0),
                            clipBehavior: Clip.none,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            constraints: BoxConstraints.tightFor(
                              height: 24,
                              width: 24,
                            ),
                            child: AnimatedBuilder(
                                animation: animations[index],
                                builder: (context, val) {
                                  return Transform.scale(
                                    alignment: Alignment.center,
                                    scale: animations[index].value,
                                    child: Stack(
                                      children: [
                                        reactionIcon.emoji == null
                                            ? StreamSvgIcon(
                                                assetName:
                                                    reactionIcon.assetName,
                                                width: 18,
                                                height: 18,
                                                color:
                                                    MainAppColorHelper.orange(),
                                                // (!highlightOwnReactions ||
                                                //         reaction.user.id == StreamChat.of(context).user.id)
                                                //     ? StreamChatTheme.of(context).colorTheme.accentBlue
                                                //     : StreamChatTheme.of(context)
                                                //         .colorTheme
                                                //         .black
                                                //         .withOpacity(.5),
                                              )
                                            : Text(
                                                reactionIcon.emoji!,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                        Visibility(
                                          visible: count > 1 ? true : false,
                                          child: Positioned(
                                              left: 10,
                                              top: 9,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.white),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.all(1.5),
                                                    child: Text(
                                                      count.toString(),
                                                      style: TextStyle(
                                                          fontSize: 8,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))),
                                        ),
                                      ],
                                    ),
                                    // child: StreamSvgIcon(
                                    //   assetName: reactionIcon.assetName,
                                    //   height: max(
                                    //     0,
                                    //     animations[index].value * 24.0,
                                    //   ),
                                    //   width: max(
                                    //     0,
                                    //     animations[index].value * 24.0,
                                    //   ),
                                    //   color: ownReactionIndex != -1
                                    //       ? MainAppColorHelper.orange()
                                    //       : Theme.of(context)
                                    //           .iconTheme
                                    //           .color
                                    //           .withOpacity(.5),
                                    // ),
                                  );
                                }),
                            onPressed: () {
                              if (ownReactionIndex != -1) {
                                removeReaction(
                                  context,
                                  widget
                                      .message.ownReactions![ownReactionIndex],
                                );
                              } else {
                                sendReaction(
                                  context,
                                  reactionIcon.type!,
                                );
                              }
                            },
                          ),
                        );
                      })
                      .insertBetween(SizedBox(
                        width: 16,
                      ))
                      .toList(),
                ),
              ),
            ),
          );
        });
  }

  void triggerAnimations() async {
    for (var a in animations) {
      a.start();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void pop() async {
    for (var a in animations) {
      a.stop();
    }
    Navigator.of(context).pop();
  }

  /// Add a reaction to the message
  void sendReaction(BuildContext context, String reactionType) {
    StreamChannel.of(context).channel.sendReaction(
          widget.message,
          reactionType,
          enforceUnique: false,
        );
    pop();
  }

  /// Remove a reaction from the message
  void removeReaction(BuildContext context, Reaction reaction) {
    StreamChannel.of(context).channel.deleteReaction(widget.message, reaction);
    pop();
  }

  int getReactionScore(String? type) {
    if (reactionScores != null && reactionScores!.isNotEmpty) {
      return reactionScores![type!] ?? 0;
    }
    return 0;
  }

  @override
  void dispose() {
    for (var a in animations) {
      a.dispose();
    }
    super.dispose();
  }
}
