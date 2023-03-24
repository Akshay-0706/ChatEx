import 'dart:async';

import 'package:chatex/backend/api/api.dart';
import 'package:chatex/backend/database/users.dart';
import 'package:chatex/backend/database/message.dart';
import 'package:chatex/size.dart';
import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'chat_card.dart';
import 'chat_header.dart';

class ChatBody extends StatefulWidget {
  const ChatBody({super.key, required this.contact});
  final User contact;

  @override
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final box = GetStorage();

  late TextEditingController controller;
  late ScrollController scrollController;
  late Timer timer;

  List<Message> chats = [];

  void getMessages() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print("Getting messages...");
      Api.getMessages((widget.contact.number + box.read("number")).toString())
          .then((value) {
        setState(() {
          chats = value;
        });
      });
    });
  }

  @override
  void initState() {
    controller = TextEditingController();
    scrollController = ScrollController();
    Api.getMessages((widget.contact.number + box.read("number")).toString())
        .then((value) {
      setState(() {
        chats = value;
      });
    });
    getMessages();
    super.initState();
  }

  void sendMessage(String message) {
    print(DateTime.now());
    DateTime current = DateTime.now();
    int number = box.read("number");
    setState(() {
      chats.add(Message(message, current, number));
      Future.delayed(
          const Duration(milliseconds: 200),
          () => scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(seconds: 1),
              curve: Curves.fastOutSlowIn));
    });
    Api.sendMessage(message, current.toString(), number.toString(),
        (widget.contact.number + number).toString());
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Pallete pallete = Pallete(context);
    Future.delayed(
        const Duration(milliseconds: 200),
        () => scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 1),
            curve: Curves.fastOutSlowIn));
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
                          sendMessage(message);
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
