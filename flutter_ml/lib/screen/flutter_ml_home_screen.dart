import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml/controller/image_picker_provider.dart';
import 'package:flutter_ml/utils/model_loader.dart';
import 'package:flutter_ml/widgets/display_image_labels.dart';
import 'package:flutter_ml/widgets/select_image_card.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:provider/provider.dart';

class FlutterMlHomeScreen extends StatefulWidget {
  const FlutterMlHomeScreen({super.key});

  @override
  State<FlutterMlHomeScreen> createState() => _FlutterMlHomeScreenState();
}

class _FlutterMlHomeScreenState extends State<FlutterMlHomeScreen> {
  @override
  void initState() {
    super.initState();

    ModelLoader.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = context.watch<ImagePickerProvider>();
    final File? selectedImage = imageProvider.image;
    final imageCallActions = context.read<ImagePickerProvider>();
    final List<ImageLabel> detectedLabels = imageProvider.labels;
    final bool isProcessing = imageProvider.isProcessing;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Recognizer"),
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
                  : Card(
                    margin: const EdgeInsets.all(13),
                    color: Colors.grey,
                    child: Container(
                      width: screenSize.width,
                      height: screenSize.height * 0.35,
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
                  ),
              const SizedBox(height: 8),
              SelectImageCard(imageCallActions: imageCallActions),
              // const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {
              //     imageCallActions.pickImage();
              //   },
              //   onLongPress: () {
              //     imageCallActions.captureImage();
              //   },
              //   child: Text("choose/Capture"),
              // ),
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
                DisplayImageLabels(
                  selectedImage: selectedImage,
                  detectedLabels: detectedLabels,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
