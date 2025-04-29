import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:ww/View/pages/textscreen.dart';

class RecogniseImage extends StatefulWidget {
  final File imagee;

  const RecogniseImage({
    super.key,
    required this.imagee,
  });

  @override
  State<RecogniseImage> createState() => _RecogniseImageState();
}

class _RecogniseImageState extends State<RecogniseImage> {
  late TextRecognizer textRecognizer;
  String textt = "";

  @override
  void initState() {
    super.initState();
    textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    Future.microtask(() => dotextrecognition());
  }

  Future<void> dotextrecognition() async {
    final InputImage inputImage = InputImage.fromFile(widget.imagee);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    setState(() {
      textt = recognizedText.text;
    });

    print(textt);
  }

  @override
  void dispose() {
    textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEBF),
        appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Recognized Text',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold, color: Color(0xFF494013),),),
        backgroundColor: const Color(0xFFF5EEBF),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 70),
              Center(
                child: Image.file(widget.imagee),
              ),
              const SizedBox(height: 130),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: const Icon(Icons.arrow_forward_rounded, size: 40),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextScreen(text: textt),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
