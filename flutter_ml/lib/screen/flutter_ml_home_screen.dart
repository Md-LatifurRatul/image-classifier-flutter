import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml/controller/image_picker_provider.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:provider/provider.dart';

class FlutterMlHomeScreen extends StatelessWidget {
  const FlutterMlHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImagePickerProvider>();
    final File? selectedImage = imageProvider.image;
    final imageCallActions = context.read<ImagePickerProvider>();
    final List<ImageLabel> detectedLabels = imageProvider.labels;
    final bool isProcessing = imageProvider.isProcessing;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Selection"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedImage == null
                  ? Icon(
                    Icons.image_outlined,
                    size: 150,
                    color: Colors.grey[400],
                  )
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
              const SizedBox(height: 10),
              Text(
                'Detection Results:',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              if (isProcessing)
                const CircularProgressIndicator()
              else
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 80),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child:
                      selectedImage == null
                          ? Text(
                            'Pick an image to see labels.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          )
                          : detectedLabels.isEmpty
                          ? Text(
                            'No labels detected for this image.',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                detectedLabels.map((label) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Text(
                                      'Label: ${label.label}, Confidence: ${label.confidence.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
