import 'package:flutter/material.dart';
import 'package:ww/View/pages/summary.dart';
import 'package:ww/View/pages/vocab.dart'; // Add this import

class TextScreen extends StatefulWidget {
  final String text;
  const TextScreen({super.key, required this.text});
  
  @override
  State<TextScreen> createState() => _TextScreenState();
}

const String texto = "";

class _TextScreenState extends State<TextScreen> {
  @override
  void initState() {
    super.initState();
    printText();
  }
  
  void printText() {
    print(widget.text);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 254, 238, 153),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Extracted Text',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFF494013),),),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 254, 238, 153),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color:  const Color(0xFFF5EEBF),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Text(

                  widget.text,
                  style: const TextStyle(fontSize: 20.0,fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EEBF).withOpacity(0.6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Button for Vocabulary
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF494013),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VocabularyScreen(texto: widget.text),
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Vocabulary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 100),
                  // Button for Summary
                  Column(
                    children: [
                      InkWell(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFF494013),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SummaryPage(texto: widget.text),
                            ),
                          );
                        }
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Summary',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}