import 'package:expenses_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expenses Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: const Color(0XFF00B2E7),
          secondary: const Color(0XFFE064F7),
          tertiary: const Color(0XFFFF8D6C),
          outline: Colors.grey,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}