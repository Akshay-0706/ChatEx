import 'package:chatex/backend/database/contacts.dart';
import 'package:chatex/backend/database/message.dart';
import 'package:chatex/size.dart';
import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'chat_card.dart';
import 'chat_header.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key, required this.contact});
  final Users contact;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final box = GetStorage();

  late TextEditingController controller;
  late ScrollController scrollController;

  final List<Message> chats = [
    Message("Hello bro", DateTime.now(), 4534759),
    Message("Hello bro", DateTime.now(), 4534759),
    Message("Hello bro", DateTime.now(), 4534759),
    Message("Hi there", DateTime.now(), 7715940266),
    Message("Hi there", DateTime.now(), 7715940266),
    Message("Hi there", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
    Message("Hello!", DateTime.now(), 4534759),
    Message("Good morning", DateTime.now(), 7715940266),
  ];

  @override
  void initState() {
    controller = TextEditingController();
    scrollController = ScrollController();
    super.initState();
  }

  void addMessage(String message, bool fromMe) {
    setState(() {
      chats.add(Message(message, DateTime.now(),
          fromMe ? box.read("number") : widget.contact.number));
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pallete pallete = Pallete(context);
    String message = "";
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: getHeight(20)),
          ChatHeader(contact: widget.contact, pallete: pallete),
          ChatList(
            chats: chats,
            box: box,
            pallete: pallete,
            scrollController: scrollController,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: getWidth(20), right: getWidth(20), bottom: getWidth(20)),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF32426B), width: 2),
                  borderRadius: BorderRadius.circular(getWidth(20)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF32426B).withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(5, 5))
                  ]),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        maxLines: 3,
                        minLines: 1,
                        style: TextStyle(color: pallete.primaryDark),
                        onChanged: (value) {
                          message = value;
                        },
                        cursorColor: pallete.primaryDark,
                        cursorRadius: const Radius.circular(8),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a message",
                          counterText: "",
                          hintStyle: TextStyle(
                            color: pallete.primaryLight,
                            fontSize: getHeight(16),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: getWidth(10)),
                    GestureDetector(
                      onTap: () {
                        if (message.isNotEmpty) {
                          addMessage(message, true);
                          controller.text = "";
                        }
                      },
                      child:
                          Icon(Icons.send_rounded, color: pallete.primaryDark),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
