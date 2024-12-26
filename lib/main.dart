import 'package:enkridekrib_app/contents/decrypt.dart';
import 'package:enkridekrib_app/contents/encrypt.dart';
import 'package:enkridekrib_app/contents/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'enkripsi app',
      initialRoute: DashboardPage.routeName,
      routes: {
        DashboardPage.routeName: (context) => const DashboardPage(),
        EncryptProcess.routeName: (context) => const EncryptProcess(),
        DecryptProcess.routeName: (context) => const DecryptProcess(),
      },
    );
  }
}
