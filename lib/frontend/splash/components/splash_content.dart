import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatex/global.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../size.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key? key,
    required this.opacity,
  }) : super(key: key);
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: getWidth(100),
          height: getWidth(100),
          child: LottieBuilder.asset(
            themeChanger.isDarkMode
                ? "assets/extras/lottie_logo_dark.json"
                : "assets/extras/lottie_logo_light.json",
            repeat: true,
          ),
        ),
        AnimatedTextKit(
          pause: const Duration(milliseconds: 0),
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText(
              "chatEx",
              speed: const Duration(milliseconds: 1500),
              textStyle: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: getHeight(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
