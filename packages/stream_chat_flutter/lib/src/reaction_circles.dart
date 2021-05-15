import 'dart:math';

import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';
import 'package:stream_chat_flutter/src/utils/stream_ui_utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionCircles extends StatelessWidget {
  const ReactionCircles({
    Key key,
    @required this.reactions,
    @required this.borderColor,
    @required this.backgroundColor,
    @required this.maskColor,
    this.reverse = false,
    this.flipTail = false,
    this.highlightOwnReactions = true,
    this.tailCirclesSpacing = 0,
    this.reactionScores,
  }) : super(key: key);

  final List<Reaction> reactions;
  final Color borderColor;
  final Color backgroundColor;
  final Color maskColor;
  final bool reverse;

  final bool flipTail;
  final bool highlightOwnReactions;
  final double tailCirclesSpacing;
  final Map<String, int> reactionScores;

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatTheme.of(context).reactionIcons;
    final totalReactions = reactions.length;
    final offset = totalReactions > 1 ? 16.0 : 2.0;



    return Row(
      children: [
        for(var i = 0;i<=5;i++)
          ...[
            _buildReaction(reactionIcons, reactions[0], context)
          ]
      ],
    );
  }

  int getReactionScore(String type) {
    if (reactionScores != null && reactionScores.isNotEmpty) {
      return reactionScores[type] ?? 0;
    }
    return 0;
  }

  Widget _buildReaction(
      List<ReactionIcon> reactionIcons,
      Reaction reaction,
      BuildContext context,
      ) {
    final reactionIcon = reactionIcons.firstWhere(
          (r) => r.type == reaction.type,
      orElse: () => null,
    );

    int count = getReactionScore(reaction.type);


    return Container(
      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 4),
      decoration: StreamUiUtils.cardShadowEmoji(Colors.white),
      child: Row(
        children: [
          Text(count.toString()),
          Text(reactionIcon.emoji)
        ],
      ),
    );


    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4.0,
      ),
      child: reactionIcon != null
          ? Stack(children: [
        reactionIcon.emoji == null
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
          reactionIcon.emoji,
          style: TextStyle(fontSize: 16),
        ),
        Visibility(
          visible: count > 1 ? true : false,
          child: Positioned(
              left: 10,
              top: 9,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ))),
        ),
      ])
          : Text(
        Emojis.fire,
        style: TextStyle(fontSize: 16),
      ),
      // : Icon(
      //     Icons.help_outline_rounded,
      //     size: 16,
      //     color: (!highlightOwnReactions ||
      //             reaction.user.id == StreamChat.of(context).user.id)
      //         ? MainAppColorHelper.orange()
      //         : StreamChatTheme.of(context)
      //             .colorTheme
      //             .black
      //             .withOpacity(.5),
      //   ),
    );
  }
}