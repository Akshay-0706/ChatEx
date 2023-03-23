import 'package:chatex/backend/database/contacts.dart';
import 'package:chatex/frontend/chat/components/body.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key, required this.contact});
  final Users contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBody(contact: contact),
    );
  }
}
