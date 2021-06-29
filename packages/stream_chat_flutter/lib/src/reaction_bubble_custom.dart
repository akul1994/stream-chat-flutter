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
  const ReactionBubbleCustom({
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

  @override
  Widget build(BuildContext context) {
    final reactionIcons =
        this.reactionIcons ?? StreamChatTheme
            .of(context)
            .reactionIcons;
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
          child :
          Row(
                //direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                ],
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

  Widget _buildReaction(List<ReactionIcon> reactionIcons,
      Reaction reaction,
      BuildContext context,) {
    final reactionIcon = reactionIcons.firstWhere(
          (r) => r.type == reaction.type,
      orElse: () => null,
    );

    int count = getReactionScore(reaction.type);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2,vertical: 8),
      child: InkWell(
        onTap: (){
          onTap(reaction);
        },
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.all(Radius.circular(14)),
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: 4.0, vertical: 2
            ),
            decoration: BoxDecoration(
              // border: Border.all(
              //   color: borderColor,
              // ),
              color: backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: reactionIcon != null
                ? Row(children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Padding(
                    padding: EdgeInsets.all(1.5),
                    child: Text(
                      count.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
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

            ])
                : Text(
              Emojis.fire,
              style: TextStyle(fontSize: 16),
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

