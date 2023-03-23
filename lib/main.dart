import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'global.dart';
import 'routes.dart';
import 'theme.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();

  @override
  void initState() {
    themeChanger.isDarkMode = themeChanger.currentTheme() == ThemeMode.system
        ? WidgetsBinding.instance.window.platformBrightness == Brightness.dark
        : themeChanger.currentTheme() == ThemeMode.dark;

    final window = WidgetsBinding.instance.window;

    if (box.read("theme") == "Light") {
      themeChanger.changeThemeMode("Light");
    }

    if (box.read("theme") == "Dark") {
      themeChanger.changeThemeMode("Dark");
    }

    window.onPlatformBrightnessChanged = () {
      setState(() {
        themeChanger.isDarkMode =
            themeChanger.currentTheme() == ThemeMode.system
                ? WidgetsBinding.instance.window.platformBrightness ==
                    Brightness.dark
                : themeChanger.currentTheme() == ThemeMode.dark;
      });

      if (themeChanger.theme == "Auto") {
        setState(() {
          themeChanger.changeThemeMode("Auto");
        });
      }
    };

    themeChanger.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'chatEx',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      routes: routes,
    );
  }
}
