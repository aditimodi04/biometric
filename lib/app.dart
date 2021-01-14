import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_demo/biometricScreen.dart';
import 'package:task_demo/loginScreen.dart';

final ThemeData kDefaultTheme = new ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[600],
  buttonColor: Colors.blue[500],
  buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.accent),
  accentColor: Colors.white,
  primaryColorBrightness: Brightness.dark,
  primaryTextTheme: TextTheme(title: TextStyle(color: Colors.white)),
  accentIconTheme: IconThemeData(color: Colors.white),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData.fallback().copyWith(color: Colors.grey[800]),
);

class MyApplication extends StatelessWidget {
  MyApplication();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biometric App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
      },
      theme: kDefaultTheme,
    );
  }
}
