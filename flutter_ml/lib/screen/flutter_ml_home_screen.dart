import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml/controller/image_picker_provider.dart';
import 'package:provider/provider.dart';

class FlutterMlHomeScreen extends StatelessWidget {
  const FlutterMlHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImagePickerProvider>();
    final File? selectedImage = imageProvider.image;
    final imageCallActions = context.read<ImagePickerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Selection"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            selectedImage == null
                ? Icon(Icons.image_outlined, size: 150, color: Colors.grey[400])
                : Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    selectedImage,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            Center(child: Text("Could not load image.")),
                  ),
                ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                imageCallActions.pickImage();
              },
              onLongPress: () {
                imageCallActions.captureImage();
              },
              child: Text("choose/Capture"),
            ),
          ],
        ),
      ),
    );
  }
}
