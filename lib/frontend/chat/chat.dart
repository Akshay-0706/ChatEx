import 'package:chatex/backend/database/users.dart';
import 'package:chatex/frontend/chat/components/body.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  const Chat({super.key, required this.contact});
  final User contact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatBody(contact: contact),
    );
  }
}
