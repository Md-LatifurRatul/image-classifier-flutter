import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  late final ImageLabelerOptions _labelerOptions;
  late final ImageLabeler _imageLabeler;

  File? get image => _image;

  ImageLabeler get imageLabeler => _imageLabeler;

  ImagePickerProvider() {
    _labelerOptions = ImageLabelerOptions(confidenceThreshold: 0.6);
    _imageLabeler = ImageLabeler(options: _labelerOptions);
  }

  Future<void> pickImage() async {
    try {
      final XFile? selectedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (selectedImage != null) {
        _image = File(selectedImage.path);
        performImageLabeling();
        notifyListeners();
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  Future<void> captureImage() async {
    try {
      final XFile? capturedImage = await _imagePicker.pickImage(
        source: ImageSource.camera,

        imageQuality: 80,
        maxWidth: 1000,
      );
      if (capturedImage != null) {
        _image = File(capturedImage.path);
        performImageLabeling();
        notifyListeners();
      }
    } catch (e) {
      log('Error capturing image with camera: $e');
    }
  }

  Future<void> performImageLabeling() async {
    if (_image == null) {
      log('No image selected for labeling. Skipping.');
      return;
    }
    log('Attempting to perform image labeling...');

    try {
      final InputImage inputImage = InputImage.fromFile(_image!);
      final List<ImageLabel> labels = await _imageLabeler.processImage(
        inputImage,
      );

      if (labels.isEmpty) {
        log('No labels detected for the image.');
        return;
      }

      log('Detected Labels:');
      for (ImageLabel label in labels) {
        final String text = label.label;
        final int index = label.index;
        final double confidence = label.confidence;
        log("Label: $text, Confidence: ${confidence.toStringAsFixed(2)}");
      }
    } catch (e) {
      log('Error during image labeling: $e');
    }
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }
}
