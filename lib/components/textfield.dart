//text field 
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;

  const MyTextField(
      {super.key,
        required this.controller,
       });

  @override
  Widget build(BuildContext context) {
    return //username text field  
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                //changes color when in use
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintStyle: TextStyle(
                  color: Colors.grey[500]
              )
          ),
        ),
      );
  }
}