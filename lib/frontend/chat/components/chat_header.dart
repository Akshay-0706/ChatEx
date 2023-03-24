import 'package:chatex/backend/database/users.dart';
import 'package:chatex/size.dart';
import 'package:chatex/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    Key? key,
    required this.contact,
    required this.pallete,
  }) : super(key: key);

  final User contact;
  final Pallete pallete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(8),
            splashColor: pallete.primary.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).primaryColorDark,
                size: getHeight(26),
              ),
            ),
          ),
          SizedBox(width: getWidth(10)),
          SvgPicture.asset(
            "assets/icons/avatar.svg",
            width: getWidth(40),
          ),
          SizedBox(width: getWidth(10)),
          Text(
            contact.name,
            style: TextStyle(
              color: pallete.primaryDark,
              fontSize: getHeight(18),
            ),
          ),
        ],
      ),
    );
  }
}
