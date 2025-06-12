import 'package:flutter/material.dart';
import 'package:flutter_ml/controller/image_picker_provider.dart';

class SelectImageCard extends StatelessWidget {
  const SelectImageCard({super.key, required this.imageCallActions});

  final ImagePickerProvider imageCallActions;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      color: Colors.limeAccent.shade400,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Icon(Icons.image, size: 50),
              onTap: () {
                imageCallActions.pickImage();
              },
            ),

            InkWell(
              child: Icon(Icons.camera, size: 50),
              onTap: () {
                imageCallActions.captureImage();
              },
            ),
          ],
        ),
      ),
    );
  }
}
