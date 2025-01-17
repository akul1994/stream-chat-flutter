import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../stream_chat_theme.dart';

enum AttachmentSource {
  local,
  network,
}

extension AttachmentSourceX on AttachmentSource {
  /// The [when] method is the equivalent to pattern matching.
  /// Its prototype depends on the AttachmentSource defined.
  // ignore: missing_return
  T when<T>({
    required T Function() local,
    required T Function() network,
  }) {
    assert(() {
      if (local == null || network == null) {
        throw 'check for all possible cases';
      }
      return true;
    }());
    switch (this) {
      case AttachmentSource.local:
        return local();
      case AttachmentSource.network:
        return network();
    }
  }
}

abstract class AttachmentWidget extends StatelessWidget {
  final Size? size;
  final Message? message;
  final Attachment attachment;
  final AttachmentSource? _source;

  /// Getter for source of attachment
  AttachmentSource get source =>
      _source ??
          (attachment.file != null
              ? AttachmentSource.local
              : AttachmentSource.network);

  const AttachmentWidget({
    Key? key,
    required this.message,
    required this.attachment,
    this.size,
    AttachmentSource? source,
  })  : _source = source,
        super(key: key);
}

class AttachmentError extends StatelessWidget {
  final Size? size;

  const AttachmentError({
    Key? key,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size?.width,
        height: size?.height,
        color: StreamChatTheme.of(context).colorTheme!.accentRed.withOpacity(.1),
        child: Center(
          child: Icon(
            Icons.error_outline,
            color: StreamChatTheme.of(context).colorTheme!.black,
          ),
        ),
      ),
    );
  }
}
