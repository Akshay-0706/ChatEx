import 'dart:convert';

import 'package:chatex/backend/database/contacts.dart';
import 'package:get_storage/get_storage.dart';

class Store {
  final box = GetStorage();
  List<Users> contacts = [];

  List<Users> getContacts() {
    String storedContacts = box.read("contacts");
    contacts = jsonDecode(storedContacts);
    return contacts;
  }

  void addContact(String name, String photoUrl, int number) {
    contacts.add(Users(name, photoUrl, number));
    box.write("contacts", jsonEncode(contacts));
  }

  void deleteContact(int number) {
    contacts.removeWhere((element) => element.number == number);
    box.write("contacts", jsonEncode(contacts));
  }
}
