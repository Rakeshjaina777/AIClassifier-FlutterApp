// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:flutter/services.dart';
// import 'package:image/image.dart' as img;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter AI Image Classifier (tflite_flutter)',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
// class _MyHomePageState extends State<MyHomePage> {
//   late Interpreter _interpreter;
//   late List<String> _labels;
//   File? _image;
//   bool _isLoading = false;
//   bool _isModelReady = false;  // Track whether model is ready
//   List<Map<String, dynamic>> _recognitions = [];
//   final ImagePicker picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeModelAndLabels();
//   }
//
//   Future<void> _initializeModelAndLabels() async {
//     try {
//       await _loadModel();
//       await _loadLabels();
//       setState(() {
//         _isModelReady = true;  // Set model ready flag
//       });
//     } catch (e, stacktrace) {
//       debugPrint("Initialization error: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     }
//   }
//
//   // Load the TFLite model from assets
//   Future<void> _loadModel() async {
//     try {
//       _interpreter = await Interpreter.fromAsset('mobilenet_v1_1.0_224_quant.tflite');
//       debugPrint("Model loaded successfully");
//     } catch (e, stacktrace) {
//       debugPrint("Error loading model: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     }
//   }
//
//   // Load labels from the asset file
//   Future<void> _loadLabels() async {
//     try {
//       String labelsData = await rootBundle.loadString('assets/labels_mobilenet_quant_v1_224.txt');
//       _labels = labelsData.split('\n').where((element) => element.trim().isNotEmpty).toList();
//       debugPrint("Labels loaded successfully. Total labels: ${_labels.length}");
//     } catch (e, stacktrace) {
//       debugPrint("Error loading labels: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     }
//   }
//
//   // Function to pick an image from the gallery
//   Future<void> _getImageFromGallery() async {
//     if (!_isModelReady) {
//       debugPrint("Model is not ready yet.");
//       return;  // Don't proceed if the model is not ready
//     }
//
//     try {
//       final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         debugPrint("Image picked from gallery: ${pickedFile.path}");
//         setState(() {
//           _image = File(pickedFile.path);
//         });
//         await _classifyImage(_image!);
//       } else {
//         debugPrint("No image selected from gallery");
//       }
//     } catch (e, stacktrace) {
//       debugPrint("Error picking image from gallery: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     }
//   }
//
//   // Function to pick an image from the camera
//   Future<void> _getImageFromCamera() async {
//     if (!_isModelReady) {
//       debugPrint("Model is not ready yet.");
//       return;  // Don't proceed if the model is not ready
//     }
//
//     try {
//       final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
//       if (pickedFile != null) {
//         debugPrint("Image captured from camera: ${pickedFile.path}");
//         setState(() {
//           _image = File(pickedFile.path);
//         });
//         await _classifyImage(_image!);
//       } else {
//         debugPrint("No image captured from camera");
//       }
//     } catch (e, stacktrace) {
//       debugPrint("Error picking image from camera: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     }
//   }
//
//   // Function to preprocess the image, run inference, and process the output
//   Future<void> _classifyImage(File image) async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     try {
//       debugPrint("Reading image bytes");
//       final imageBytes = await image.readAsBytes();
//       debugPrint("Decoding image");
//       final oriImage = img.decodeImage(imageBytes);
//       if (oriImage == null) {
//         debugPrint("Error: Decoded image is null");
//         return;
//       }
//
//       debugPrint("Resizing image to 224x224");
//       final resizedImage = img.copyResize(oriImage, width: 224, height: 224);
//
//       // Prepare input tensor with shape [1, 224, 224, 3]
//       debugPrint("Preparing input tensor");
//       var input = List.generate(1, (_) =>
//           List.generate(224, (_) =>
//               List.generate(224, (_) => List.filled(3, 0))
//           )
//       );
//
//       for (int i = 0; i < 224; i++) {
//         for (int j = 0; j < 224; j++) {
//           final pixel = resizedImage.getPixel(j, i);
//           final r = img.getRed(pixel);
//           final g = img.getGreen(pixel);
//           final b = img.getBlue(pixel);
//           input[0][i][j][0] = r;
//           input[0][i][j][1] = g;
//           input[0][i][j][2] = b;
//         }
//       }
//       debugPrint("Input tensor prepared");
//
//       // Prepare the output buffer
//       debugPrint("Preparing output buffer");
//       var output = List.generate(1, (_) => List.filled(_labels.length, 0));
//       debugPrint("Output buffer size: ${output[0].length}");
//
//       debugPrint("Running inference");
//       _interpreter.run(input, output);
//       debugPrint("Inference completed");
//
//       // Dequantize the output
//       double scale = 1.0; // Replace with your model's output scale if different
//       int zeroPoint = 0;  // Replace with your model's output zero point if different
//
//       // Process the output and extract predictions
//       List<Map<String, dynamic>> recognitions = [];
//       for (int i = 0; i < output[0].length; i++) {
//         double confidence = (output[0][i] - zeroPoint) * scale;
//         recognitions.add({
//           'label': _labels[i],
//           'confidence': confidence,
//         });
//       }
//       recognitions.sort((a, b) => b['confidence'].compareTo(a['confidence']));
//       debugPrint("Top recognitions: ${recognitions.take(5).toList()}");
//
//       setState(() {
//         _recognitions = recognitions.take(5).toList();
//       });
//     } catch (e, stacktrace) {
//       debugPrint("Error during classification: $e");
//       debugPrint("Stacktrace: $stacktrace");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AI Image Classifier (tflite_flutter)'),
//       ),
//       body: SingleChildScrollView(
//         child: Center(
//           child: Column(
//             children: [
//               if (_image != null) ...[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.file(_image!),
//                 ),
//                 SizedBox(height: 20),
//                 _isLoading
//                     ? CircularProgressIndicator()
//                     : Column(
//                   children: _recognitions.map((recog) {
//                     return Text(
//                       'Label: ${recog['label']} - Confidence: ${recog['confidence'].toStringAsFixed(3)}',
//                     );
//                   }).toList(),
//                 ),
//               ],
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isModelReady ? _getImageFromGallery : null,  // Disable if model is not ready
//                 child: Text('Pick Image from Gallery'),
//               ),
//               ElevatedButton(
//                 onPressed: _isModelReady ? _getImageFromCamera : null,  // Disable if model is not ready
//                 child: Text('Take Image with Camera'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'dart:io';
//
// import 'package:tflite_flutter/tflite_flutter.dart';
//
// class Classifier {
//   late Interpreter _interpreter;
//
//   Classifier() {
//     _loadModel();
//   }
//
//   void _loadModel() async {
//     _interpreter = await Interpreter.fromAsset('assets/dog_cat_model.tflite');
//   }
//
//   String classifyImage(File image) {
//     var inputImage = _preprocessImage(image);
//     List<List<double>> output = List.generate(1, (_) => List.filled(2, 0.0));
//     _interpreter.run(inputImage, output);
//     return _postprocessOutput(output);
//   }
//
//
//   List<List<double>> _preprocessImage(File image) {
//     // Implement image preprocessing (resize, normalize, etc.)
//     // This depends on your model's input requirements
//     return [[1.0, 0.0]]; // Placeholder
//   }
//
//   String _postprocessOutput(List<List<double>> output) {
//     // Implement output postprocessing
//     // This depends on your model's output format
//     return output[0][0] > output[0][1] ? 'Dog' : 'Cat';
//   }
// }