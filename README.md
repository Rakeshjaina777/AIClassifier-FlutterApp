# 🧠 AIClassifier FlutterApp

**AIClassifier FlutterApp** is a cross-platform Flutter application that uses **TensorFlow Lite** to perform real-time **image classification** directly on your device. Powered by a pre-trained **MobileNet model**, this app allows users to select or capture an image and get AI-generated predictions with confidence scores — all without needing an internet connection.

---

## 📸 Features

- ✅ On-device image classification with **TFLite**
- 📷 Pick images from **gallery** or **camera**
- 🧠 Built with a **quantized MobileNet v1** model
- 🎯 Displays **top 5 predictions** with confidence levels
- 🌙 **Dark-themed**, clean Material UI
- 💡 Follows **MVVM architecture** with **Riverpod** state management
- 📂 Clean and scalable folder structure

---

## 🏗️ Folder Structure

```
lib/
│
├── main.dart                         # App entry point
├── core/                             # Constants and utilities
├── data/                             # Classifier logic & label loader
│   ├── classifier/
│   │   ├── image_classifier.dart
│   │   └── label_loader.dart
├── model/                            # Recognition model
│   └── recognition.dart
├── view/                             # UI screens
│   └── screens/
│       └── home_screen.dart
├── view_model/                       # State management (Riverpod)
│   └── classifier_view_model.dart
├── widgets/                          # Reusable UI components
│   └── result_card.dart
└── services/                         # Image picker logic
    └── image_service.dart
```

---

## 🚀 Getting Started

### 📦 Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.0.0
  tflite_flutter: ^0.10.0
  image_picker: ^1.0.0
  image: ^4.0.17
```

### 📁 Assets

Create an `assets/` directory and place the following files:

- `mobilenet_v1_1.0_224_quant.tflite`
- `labels_mobilenet_quant_v1_224.txt`

Then add to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/mobilenet_v1_1.0_224_quant.tflite
    - assets/labels_mobilenet_quant_v1_224.txt
```

---

## 🧪 How It Works

1. Loads the TFLite model and label file from assets
2. Takes an image from the camera or gallery
3. Resizes and processes the image
4. Runs inference using `tflite_flutter`
5. Displays top-5 label predictions with confidence

---

 ## 📸 Screenshots



---

## 🔐 Git Authentication Note

GitHub has removed password authentication over HTTPS. To push code:

- Use a **Personal Access Token (PAT)** or
- Switch to **SSH-based authentication**

Read: [GitHub Authentication Changes](https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/)

---

## 🛠 Built With

- [Flutter](https://flutter.dev)
- [TensorFlow Lite](https://www.tensorflow.org/lite)
- [Riverpod](https://riverpod.dev)
- [Image Picker](https://pub.dev/packages/image_picker)
- [TFLite Flutter Plugin](https://pub.dev/packages/tflite_flutter)

---

## 📃 License

This project is open source under the [MIT License](LICENSE).

---

## 💬 Author

👨‍💻 Developed by **Rakesh Jain**  
📫 Reach me at: [GitHub](https://github.com/Rakeshjaina777)
