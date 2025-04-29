import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SummaryPage extends StatefulWidget {
  final String texto;

  const SummaryPage({super.key, required this.texto});

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String summary = '';
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchSummaryData();
  }

  /// Fetches summary data using Gemini API
  Future<void> fetchSummaryData() async {
    const String apiKey = 'AIzaSyBjq6XvW_BSe70pA6pqOKwKrbuP8H--6YY'; // Replace with your actual Gemini API key
    const String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": "Provide a concise summary of the following text in 3-4 sentences: ${widget.texto}"}
          ]
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        // Extracting the generated text from Gemini API response
        String generatedText = responseData['candidates'][0]['content']['parts'][0]['text'];

        setState(() {
          summary = generatedText;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch summary from Gemini API');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color.fromARGB(255, 254, 238, 153),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Text Summary',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold, color: Color(0xFF494013),),),
        backgroundColor: Color.fromARGB(255, 254, 238, 153),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red, fontSize: 16)))
                : SingleChildScrollView(
                    child: Center(
                      
                      child: Card(
                        color: const Color(0xFFF5EEBF),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Summary',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal[800],
                                ),
                              ),
                              const Divider(thickness: 1.5),
                              const SizedBox(height: 10),
                              Text(
                                //textAlign: TextAlign.center,
                                summary,
                                style: const TextStyle(
                                 // fontFamily: 'Poppins',
                                  fontSize: 18,
                                  height: 1.5,
                                  fontStyle: FontStyle.italic
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}