import 'package:familicious/views/auth/create_account_view.dart';
import 'package:familicious/views/auth/login_view.dart';
import 'package:familicious/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Familicious',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(249, 251, 252, 1),
        cardColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black),
        caption: TextStyle(color: Colors.black)),
        inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            labelStyle: TextStyle(color: Colors.black)),
            buttonTheme: const ButtonThemeData(colorScheme: ColorScheme.dark(primary: Colors.white),
            textTheme: ButtonTextTheme.primary)
      ),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.grey.shade900,
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.black,
            elevation: 0,
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          textTheme:
              const TextTheme(bodyText1: TextStyle(color: Colors.white),
              caption: TextStyle(color: Colors.white)),
               inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            labelStyle: TextStyle(color: Colors.white70)),
             buttonTheme: const ButtonThemeData(colorScheme: ColorScheme.light(primary: Colors.black),
              textTheme: ButtonTextTheme.primary)),
      themeMode: ThemeMode.system,
      home:  HomeView(),
    );
  }
}
