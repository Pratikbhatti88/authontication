import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPicker extends StatefulWidget {

  UserPicker(this.imagePicksave);
   final void Function(dynamic pickedimage) imagePicksave;

  @override
  _UserPickerState createState() => _UserPickerState();
}

class _UserPickerState extends State<UserPicker> {
  File? _pickedImage;

  void _takePicture() async {
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = File(imageFile!.path);
    });

    widget.imagePicksave(imageFile);
   // widget.imagePickFn(imageFile.path as File);
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _pickedImage!=null?FileImage(_pickedImage!):null,
          radius: 30,
        ),
        TextButton.icon(onPressed: _takePicture, icon: Icon(Icons.image), label: Text('Add Image')),

      ],
    );
  }
}
