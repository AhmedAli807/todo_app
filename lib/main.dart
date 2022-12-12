import 'package:flutter/material.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/preferences_helper.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
await PreferencesHelper.instance.init();
  await PreferencesHelper.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

