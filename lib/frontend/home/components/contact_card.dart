import 'package:chatex/backend/database/users.dart';
import 'package:chatex/frontend/chat/chat.dart';
import 'package:chatex/frontend/components/custom_page_route.dart';
import 'package:chatex/size.dart';
import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    Key? key,
    required this.contacts,
    required this.pallete,
    required this.index,
  }) : super(key: key);

  final List<User> contacts;
  final Pallete pallete;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (index == 0) SizedBox(height: getHeight(20)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
          child: InkWell(
            onTap: () {
              Navigator.push(context,
                  CustomPageRoute(context, Chat(contact: contacts[index])));
            },
            child: Container(
              decoration: BoxDecoration(
                color: pallete.background,
                borderRadius: BorderRadius.circular(getWidth(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: pallete.primaryDark)),
                      child: SvgPicture.asset(
                        "assets/icons/avatar.svg",
                        width: getWidth(45),
                      ),
                    ),
                    SizedBox(width: getWidth(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contacts[index].name,
                          style: TextStyle(
                            color: pallete.primaryDark,
                            fontSize: getHeight(18),
                          ),
                        ),
                        Text(
                          "+91 ${contacts[index].number}",
                          style: TextStyle(
                            color: pallete.primaryLight,
                            fontSize: getHeight(14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: getHeight(10)),
      ],
    );
  }
}
