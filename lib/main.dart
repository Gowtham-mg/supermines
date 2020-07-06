import 'package:flutter/material.dart';
import 'home_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme.of(context).copyWith(
          color: Colors.redAccent.shade400,
        ),
        bottomAppBarTheme: BottomAppBarTheme.of(context).copyWith(
          color: Colors.redAccent.shade400,
          elevation: 5
        ),
      ),
      home: HomePage(),
    );
  }
}