import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerExampleState createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ButtonBar(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () async => _pickImageFromCamera(),
              tooltip: 'Shoot picture',
            ),
            IconButton(
              icon: const Icon(Icons.photo),
              onPressed: () async => _pickImageFromGallery(),
              tooltip: 'Pick from gallery',
            ),
          ],
        ),
        if (_imageFile == null) const Placeholder() else Image.file(_imageFile!),
      ],
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }
}
