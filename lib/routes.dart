import 'package:chatex/frontend/home/home.dart';
import 'package:chatex/frontend/welcome/welcome.dart';
import 'package:flutter/material.dart';

import 'frontend/splash/splash.dart';

Map<String, WidgetBuilder> routes = {
  "/": (context) => const Splash(),
  "/welcome": (context) => const Welcome(),
  "/home": (context) => const Home(),
};
