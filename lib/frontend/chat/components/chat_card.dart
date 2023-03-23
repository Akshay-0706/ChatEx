import 'package:chatex/backend/database/message.dart';
import 'package:chatex/global.dart';
import 'package:chatex/size.dart';
import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class ChatList extends StatelessWidget {
  const ChatList({
    Key? key,
    required this.chats,
    required this.box,
    required this.pallete, required this.scrollController,
  }) : super(key: key);

  final List<Message> chats;
  final GetStorage box;
  final Pallete pallete;
  final ScrollController scrollController;

  bool isToday(DateTime time) {
    DateTime today = DateTime.now();
    return time.day == today.day &&
        time.month == today.month &&
        time.year == today.year;
  }

  @override
  Widget build(BuildContext context) {
    bool setDate = true;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(getWidth(20)),
        child: ListView.builder(
          itemCount: chats.length,
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            if (index > 0 &&
                chats[index].time.day == chats[index - 1].time.day &&
                chats[index].time.month == chats[index - 1].time.month &&
                chats[index].time.year == chats[index - 1].time.year) {
              setDate = false;
            } else {
              setDate = true;
            }

            return Column(
              crossAxisAlignment: chats[index].number == box.read("number")
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                if (setDate)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: pallete.primaryLight,
                        ),
                      ),
                      SizedBox(width: getWidth(20)),
                      Text(
                        isToday(chats[index].time)
                            ? "Today"
                            : DateFormat("dd MMMM yyyy")
                                .format(chats[index].time),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Nunito",
                          color: pallete.primaryLight,
                        ),
                      ),
                      SizedBox(width: getWidth(20)),
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: pallete.primaryLight,
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: getHeight(20)),
                if (chats[index].number == box.read("number"))
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: SizeConfig.width * 0.7),
                    decoration: BoxDecoration(
                      color: themeChanger.isDarkMode
                          ? const Color(0xFF32426B)
                          : pallete.primary,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(getWidth(10)),
                          bottomLeft: Radius.circular(getWidth(10)),
                          bottomRight: Radius.circular(getWidth(10))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        chats[index].message,
                        style: TextStyle(
                          color: pallete.primaryDark,
                          fontSize: getHeight(14),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: SizeConfig.width * 0.7),
                    decoration: BoxDecoration(
                      color: themeChanger.isDarkMode
                          ? const Color(0xFF2C323F)
                          : const Color(0xFFB1B6C0),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(getWidth(10)),
                          bottomLeft: Radius.circular(getWidth(10)),
                          bottomRight: Radius.circular(getWidth(10))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        chats[index].message,
                        style: TextStyle(
                          color: pallete.primaryDark,
                          fontSize: getHeight(14),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: getHeight(5)),
                Text(
                  DateFormat.jm().format(chats[index].time).toLowerCase(),
                  style: TextStyle(
                    color: pallete.primaryLight,
                    fontSize: getHeight(12),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
