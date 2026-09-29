import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/web_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const WebScreen(),
    );
  }
}
