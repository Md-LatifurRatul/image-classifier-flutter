import 'package:flutter/material.dart';
import 'package:flutter_ml/screen/flutter_ml_home_screen.dart';

class FlutterMLApp extends StatelessWidget {
  const FlutterMLApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter ML App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(color: Colors.black12),
            backgroundColor: Colors.lightGreen,
            shape: StadiumBorder(),
          ),
        ),
      ),
      home: const FlutterMlHomeScreen(),
    );
  }
}
