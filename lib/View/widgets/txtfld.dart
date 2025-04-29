import 'package:flutter/material.dart';

class txfldd extends StatelessWidget {
  final String hnttxt;
  final TextEditingController controller;
  

  const txfldd({
    super.key,
    required this.hnttxt,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(30), 
          color: Colors.white,
        ),
        height: 42,
        width: 200, 
        child: TextFormField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color.fromARGB(255, 59, 54, 54),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10), 
            hintText: hnttxt,
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 59, 54, 54),
            ),
            border: InputBorder.none, 
          ),
        ),
      ),
    );
  }
}
