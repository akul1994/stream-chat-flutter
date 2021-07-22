import '../../stream_chat_flutter.dart';

class StreamUtils {
  /// Shortcut for user name
  static String getUserName(User user) {
    return (user.extraData?.containsKey('user_name') == true &&
            user.extraData['user_name'] != '')
        ? user.extraData['user_name']
        : user.name;
  }
}
