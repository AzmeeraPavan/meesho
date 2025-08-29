import 'package:flutter/material.dart';
import 'package:myntra/Home/home.dart';
import 'package:myntra/pages/product_details/cart_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load last page index from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  int lastPage = prefs.getInt('lastPage') ?? 0; // default to page 0 (Page1)

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel(), lazy: false),
      ],
      child: MyApp(initialTabIndex: lastPage),
    ),
  );
}
