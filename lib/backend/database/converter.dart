import 'package:chatex/backend/database/message.dart';
import 'package:chatex/backend/database/users.dart';

class Converter {
  static List<User> toUsers(dynamic json) {
    List<User> users = [];
    for (var user in json) {
      users.add(User(user[0], int.parse(user[1])));
    }
    return users;
  }

  static List<Message> toMessages(List<dynamic> json) {
    List<Message> messages = [];
    for (var message in json) {
      messages.add(Message(
          message[0], DateTime.parse(message[1]), int.parse(message[2])));
    }
    return messages;
  }
}
