// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Userimagepicker extends StatefulWidget {
  const Userimagepicker({
    super.key,
    required this.onPickedImage,
  });
  // ignore: prefer_typing_uninitialized_variables
  final void Function(File pickedImage) onPickedImage;

  @override
  State<Userimagepicker> createState() => _UserimagepickerState();
}

class _UserimagepickerState extends State<Userimagepicker> {
  File? _pickedImageFile;
  void _pickimage() async {
    final pickedimage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      _pickedImageFile = File(pickedimage.path);
    });
    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blueGrey,
            foregroundImage:
                _pickedImageFile != null ? FileImage(_pickedImageFile!) : null),
        TextButton.icon(
          onPressed: _pickimage,
          icon: const Icon(Icons.image),
          label: Text(
            'Image',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }

 
}
