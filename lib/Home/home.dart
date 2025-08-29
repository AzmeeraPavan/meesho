// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:myntra/Home/tab_bar.dart';
import 'package:myntra/pages/beauty_health_page/beauty_health_page.dart';
import 'package:myntra/pages/electronics/electronics.dart';
import 'package:myntra/pages/homek/homek.dart';
import 'package:myntra/pages/kids/kids.dart';
import 'package:myntra/pages/men/men.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myntra/pages/women/women.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load last selected tab
  final prefs = await SharedPreferences.getInstance();
  int lastTab = prefs.getInt('lastTab') ?? 0;
  runApp(MyApp(initialTabIndex: lastTab));
}

class MyApp extends StatelessWidget {
  final int initialTabIndex;

  const MyApp({super.key, required this.initialTabIndex});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Top Navigation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: TopNavScaffold(
        logo: SizedBox(
          // height: 40,
          child: SvgPicture.asset('assets/images/meeshoLogo.svg'),
        ),
        categories: [
          "Women Ethnic",
          "Men",
          "Kids",
          "Beauty & Health",
          "Home & Kitchen",
          "Electronics",
        ],
        pages: [
          WomenPage(),
          MenPage(),
          KidsPage(),
          ButifyPage(),
          HomekPage(),
          ElectronicsPage(),
        ],
        initialTabIndex: initialTabIndex, // ✅ Pass initial tab index
      ),
    );
  }
}
