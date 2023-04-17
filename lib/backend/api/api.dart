import 'dart:convert';

import 'package:chatex/backend/database/converter.dart';
import 'package:chatex/backend/database/message.dart';
import 'package:chatex/backend/database/users.dart';
import 'package:chatex/const.dart';
import 'package:http/http.dart' as http;

class Api {
  static Future<List<User>> registerUser(String num) async {
    final response = await http.get(Uri.parse("${Global.link}/register/$num"));

    if (response.statusCode == 200) {
      if (response.body.toString() == "True") {
        return [];
      } else {
        return Converter.toUsers(jsonDecode(response.body));
      }
    } else {
      throw Exception(
          "Error in registering user, status code: ${response.statusCode}");
    }
  }

  static Future<String> addContact(String current, String currentName,
      String name, String number, String sumOfNums) async {
    final response = await http.get(Uri.parse(
        "${Global.link}/addcontact/$current/$currentName/$name/$number/$sumOfNums"));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          "Error in registering user, status code: ${response.statusCode}");
    }
  }

  static Future<String> sendMessage(
      String message, String time, String sender, String sumOfNums) async {
    final response = await http.get(Uri.parse(
        "${Global.link}/sendmessage/$message/$time/$sender/$sumOfNums"));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
          "Error in registering user, status code: ${response.statusCode}");
    }
  }

  static Future<List<Message>> getMessages(String sumOfNums) async {
    final response =
        await http.get(Uri.parse("${Global.link}/receivemessages/$sumOfNums"));

    if (response.statusCode == 200) {
      if (response.body == "Failed") return [];
      return Converter.toMessages(jsonDecode(response.body));
    } else {
      throw Exception(
          "Error in registering user, status code: ${response.statusCode}");
    }
  }
}
