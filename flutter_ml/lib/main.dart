import 'package:flutter/material.dart';
import 'package:flutter_ml/app.dart';
import 'package:flutter_ml/controller/image_picker_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ImagePickerProvider(),
      child: const FlutterMLApp(),
    ),
  );
}
