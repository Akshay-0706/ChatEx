import 'package:chatex/backend/api/api.dart';
import 'package:chatex/frontend/components/custom_text_field.dart';
import 'package:chatex/global.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

import '../../../size.dart';
import '../../components/primary_btn.dart';

class WelcomeBody extends StatefulWidget {
  const WelcomeBody({super.key});

  @override
  State<WelcomeBody> createState() => _WelcomeBodyState();
}

class _WelcomeBodyState extends State<WelcomeBody> {
  final box = GetStorage();
  bool signedIn = false, signin = false;

  @override
  void initState() {
    signedIn = box.read('signedIn') ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String name = "", number = "";
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const Spacer(),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidth(40)),
              child: LottieBuilder.asset(
                "assets/extras/lottie_welcome.json",
                repeat: true,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getHeight(20)),
            child: SizedBox(
              width: getWidth(220),
              child: Text(
                "Welcome to chatEx!",
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: getWidth(22),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getHeight(20)),
            child: Text(
              "Chat with your friends, share your thoughts!\nPlease enter your name & number to continue",
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: getWidth(14),
              ),
            ),
          ),
          SizedBox(height: getHeight(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
            child: CustomTextField(
              hintText: "Name",
              isNum: false,
              isCountryCode: false,
              onChanged: (String username) => name = username,
            ),
          ),
          SizedBox(height: getHeight(20)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "+91",
                    isNum: true,
                    isCountryCode: true,
                    onChanged: () {},
                  ),
                ),
                SizedBox(width: getWidth(20)),
                Expanded(
                  flex: 4,
                  child: CustomTextField(
                    hintText: "00000 00000",
                    isNum: true,
                    isCountryCode: false,
                    onChanged: (String num) => number = num,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: getHeight(20)),
          if (!signin)
            PrimaryBtn(
              title: "Continue",
              primaryColor: themeChanger.isDarkMode
                  ? const Color(0xFF33436D)
                  : const Color(0xFF516DB6),
              secondaryColor: themeChanger.isDarkMode
                  ? const Color(0xFF40558F).withOpacity(0.8)
                  : const Color(0xFF5470BE).withOpacity(0.8),
              titleColor: Colors.white,
              padding: getWidth(20),
              hasIcon: false,
              tap: () {
                if (number.length == 10) {
                  GetStorage().write("name", name);
                  GetStorage().write("number", int.parse(number));
                  GetStorage().write("signedIn", true);
                  Navigator.pushNamed(context, "/home");
                }
              },
            ),
          if (signin)
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          SizedBox(height: getHeight(60)),
        ],
      ),
    );
  }
}
