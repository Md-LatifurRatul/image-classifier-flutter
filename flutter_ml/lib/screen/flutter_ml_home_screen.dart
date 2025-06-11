import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FlutterMlHomeScreen extends StatefulWidget {
  const FlutterMlHomeScreen({super.key});

  @override
  State<FlutterMlHomeScreen> createState() => _FlutterMlHomeScreenState();
}

class _FlutterMlHomeScreenState extends State<FlutterMlHomeScreen> {
  File? image;
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  Future<void> pickImage() async {
    final XFile? selectedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      image = File(selectedImage.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image == null
                ? Icon(Icons.image_outlined, size: 50)
                : Image.file(image!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: Text("choose/Capture"),
            ),
          ],
        ),
      ),
    );
  }
}
