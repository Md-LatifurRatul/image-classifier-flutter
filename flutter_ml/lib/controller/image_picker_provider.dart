import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml/utils/model_loader.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {
  File? _image;
  final ImagePicker _imagePicker = ImagePicker();
  // late final ImageLabelerOptions _labelerOptions;
  late final ImageLabeler _imageLabeler;
  List<ImageLabel> _labels = [];
  bool _isProcessing = false;

  File? get image => _image;
  List<ImageLabel> get labels => _labels;

  ImageLabeler get imageLabeler => _imageLabeler;
  bool get isProcessing => _isProcessing;

  ImagePickerProvider() {
    loadModel();

    // _labelerOptions = ImageLabelerOptions(confidenceThreshold: 0.6);
    // _imageLabeler = ImageLabeler(options: _labelerOptions);
  }

  Future<void> loadModel() async {
    final modelPath = await ModelLoader.getModelPath(
      'assets/ml/fruits_model.tflite',
    );
    final options = LocalLabelerOptions(
      confidenceThreshold: 0.8,
      modelPath: modelPath,
    );
    _imageLabeler = ImageLabeler(options: options);
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
        await performImageLabeling();
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
        await performImageLabeling();
        notifyListeners();
      }
    } catch (e) {
      log('Error capturing image with camera: $e');
    }
  }

  Future<void> performImageLabeling() async {
    if (_image == null) {
      log('No image selected for labeling. Skipping.');
      _labels = [];
      notifyListeners();
      return;
    }
    _isProcessing = true;
    notifyListeners();

    log('Attempting to perform image labeling...');

    try {
      final InputImage inputImage = InputImage.fromFile(_image!);
      final List<ImageLabel> detectedLabels = await _imageLabeler.processImage(
        inputImage,
      );

      _labels = detectedLabels;

      if (_labels.isEmpty) {
        log('No labels detected for the image.');
        return;
      }

      // for (ImageLabel label in _labels) {
      //   final String text = label.label;
      //   final int index = label.index;
      //   final double confidence = label.confidence;
      //   log("Label: $text, Confidence: ${confidence.toStringAsFixed(2)}");

      // }
    } catch (e) {
      log('Error during image labeling: $e');
      _labels = [];
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearImage() {
    _image = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }
}
