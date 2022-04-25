import 'package:flutter/material.dart';
import 'package:loki/database.dart';
import 'package:loki/pages/home_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper.initialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loki',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green
      ),
      home: const HomeScreen(),
    );
  }
}
