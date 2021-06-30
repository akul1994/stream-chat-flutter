import 'dart:math';

import 'package:emojis/emoji.dart';
import 'package:emojis/emojis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/reaction_icon.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/utils/MainAppColorHelper.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ReactionBubbleCustom extends StatelessWidget {
   ReactionBubbleCustom({
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
    this.reactionIcons, this.onTap,
  }) : super(key: key);

  final List<Reaction> reactions;
  final Color borderColor;
  final Color backgroundColor;
  final Color maskColor;
  final bool reverse;
  final List<ReactionIcon> reactionIcons;

  final bool flipTail;
  final bool highlightOwnReactions;
  final double tailCirclesSpacing;
  final Map<String, int> reactionScores;

  final Function( Reaction reaction) onTap;

  int totalReactionCount = 0;

  @override
  Widget build(BuildContext context) {
    final reactionIcons =
        this.reactionIcons ?? StreamChatTheme
            .of(context)
            .reactionIcons;

    totalReactionCount = totalReactionScores();
    // Reaction r = reactions[0].copyWith(type: 'pray');
    // Reaction r1 = reactions[0].copyWith(type: 'rocket');
    // Reaction r2 = reactions[0].copyWith(type: 'bulb');
    //
    // reactions.add(r);
    // reactions.add(r1);
    // reactions.add(r2);


    final totalReactions = reactions.length;
    final offset = totalReactions > 1 ? 32.0 : 2.0;
    return Transform(
      transform: Matrix4.rotationY(reverse ? pi : 0),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap : (){onTap(reactions[0]);},
        child: Container(
           // borderRadius: BorderRadius.circular(24),
            // color: MainAppColorHelper.greyNeutral7(),
          child :
          Padding(
            padding: const EdgeInsets.symmetric(vertical : 4.0,horizontal: 4),
            child: Row(
                  //direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                //  textDirection: TextDirection.ltr,
                  children: [
                    if (true)
                      ...reactions.map((reaction) {
                        return _buildReaction(
                          reactionIcons,
                          reaction,
                          context,
                        );
                      }).toList(),
                    // SizedBox(width: 2,),
                    // Text(
                    //   totalReactionCount.toString(),
                    //   style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.black),
                    // ),
                    // SizedBox(width: 2,),
                  ],
                ),
          )
          ),
        ),
      );
  }

  int getReactionScore(String type) {
    if (reactionScores != null && reactionScores.isNotEmpty) {
      return reactionScores[type] ?? 0;
    }
    return 0;
  }

  int totalReactionScores()
  {
    var total = 0;
    reactionScores?.forEach((key, value) {
      total+=value;
    });
    return total;
  }

  Widget _buildReaction(List<ReactionIcon> reactionIcons,
      Reaction reaction,
      BuildContext context,) {
    final reactionIcon = reactionIcons.firstWhere(
          (r) => r.type == reaction.type,
      orElse: () => null,
    );

    var count = getReactionScore(reaction.type);

    return InkWell(
      onTap: (){
        onTap(reaction);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 4.0,
        ),
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 4.0, vertical: 2
            ),
            child: reactionIcon != null
                ? Row(children: [
                Text(
                count.toString(),
            style: TextStyle(
                fontSize: 14,
                color: Colors.black),
            ),
              SizedBox(width: 2),
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
                style: TextStyle(fontSize: 14),
              ),

            ])
                : Text(
              Emojis.fire,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionsTail(BuildContext context) {
    final tail = CustomPaint(
      painter: ReactionBubblePainter(
        backgroundColor,
        borderColor,
        maskColor,
        tailCirclesSpace: tailCirclesSpacing,
      ),
    );
    return Transform(
      transform: Matrix4.rotationY(flipTail ? 0 : pi),
      alignment: Alignment.center,
      child: tail,
    );
  }
}

