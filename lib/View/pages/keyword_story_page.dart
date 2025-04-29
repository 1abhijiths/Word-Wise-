import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KeywordStoryPage extends StatefulWidget {
  final List<String> keywords;

  const KeywordStoryPage({Key? key, required this.keywords}) : super(key: key);

  @override
  State<KeywordStoryPage> createState() => _KeywordStoryPageState();
}

class _KeywordStoryPageState extends State<KeywordStoryPage> {
  bool _isLoading = true;
  String _story = '';
  Map<String, String> _wordDefinitions = {};
  int _retryCount = 0;
  final int _maxRetries = 3;
  
  @override
  void initState() {
    super.initState();
    _generateStoryWithGemini();
  }

  Future<String> _getKeywordDefinition(String keyword) async {
    try {
      final apiKey = 'API KEY';
      final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';
      
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": "Provide a comprehensive definition for the word '$keyword'. "
                    "Include its general meaning, possible contexts, and a brief example of usage. "
                    "The definition should be detailed and informative, suitable for someone wanting to understand the word deeply."
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final definition = data['candidates'][0]['content']['parts'][0]['text'] as String;
        return definition.trim();
      } else {
        throw Exception('Failed to get definition: ${response.statusCode}');
      }
    } catch (e) {
      return 'Unable to retrieve definition for $keyword.';
    }
  }

  Future<void> _generateStoryWithGemini() async {
    setState(() {
      _isLoading = true;
      _retryCount = 0;
    });

    try {
      final apiKey = 'API KEY';
      final apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey';
      
      final keywordsString = widget.keywords.join(', ');
      
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text": "Generate a creative short story (300-500 words) that naturally incorporates the following keywords: $keywordsString. "
                    "Ensure the keywords are used in a meaningful and contextual manner."
              }
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.7,
          "topK": 40,
          "topP": 0.95,
          "maxOutputTokens": 1024,
        }
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timed out. Please try again.');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final generatedText = data['candidates'][0]['content']['parts'][0]['text'] as String;
        
        // Set the story
        setState(() {
          _story = generatedText;
        });
        
        // Fetch definitions for each keyword
        final definitions = <String, String>{};
        for (final keyword in widget.keywords) {
          final definition = await _getKeywordDefinition(keyword);
          definitions[keyword] = definition;
        }
        
        setState(() {
          _wordDefinitions = definitions;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to generate story');
      }
    } catch (e) {
      _addMockStoryAndDefinitions();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to generate story: $e. Using sample content.")),
      );
    }
  }

  void _addMockStoryAndDefinitions() {
    // Create a mock story using the keywords
    final keywordsString = widget.keywords.join(', ');
    _story = "Once upon a time, in a world filled with ${widget.keywords.join(' and ')}, an adventure began. "
        "The story uses all your keywords: $keywordsString. "
        "Each keyword plays an important role in this narrative, creating a unique and engaging experience. "
        "Tap on any highlighted keyword to learn more about its meaning and significance in the story.";
    
    // Create mock definitions for each keyword
    final mockDefinitions = <String, String>{};
    for (final keyword in widget.keywords) {
      mockDefinitions[keyword] = "A key term representing an important concept in the story.";
    }
    
    setState(() {
      _wordDefinitions = mockDefinitions;
      _isLoading = false;
    });
  }

  void _showDefinition(String keyword) {
    final definition = _wordDefinitions[keyword] ?? "No definition available";
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(keyword, style: const TextStyle(
          fontFamily: 'Poppins', 
          fontWeight: FontWeight.bold,
          color: Color(0xFFFCF6DB), // Light cream/yellowish text
        )),
        content: SingleChildScrollView(
          child: Text(definition, style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFFFCF6DB), // Light cream/yellowish text
          )),
        ),
        backgroundColor: const Color(0xFF5D4037), // Brown background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(
              color: Color(0xFFEDE284), // Yellowish button text
              fontFamily: 'Poppins',
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText() {
    if (_story.isEmpty) return const SizedBox();
    
    List<TextSpan> spans = [];
    String remainingText = _story;
    
    // Sort keywords by length (descending) to handle overlapping matches properly
    final sortedKeywords = [...widget.keywords]..sort((a, b) => b.length.compareTo(a.length));
    
    while (remainingText.isNotEmpty) {
      int? earliestMatchStart;
      int? earliestMatchEnd;
      String? matchedKeyword;
      
      // Find the earliest keyword match in the remaining text
      for (final keyword in sortedKeywords) {
        final regex = RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: false);
        final match = regex.firstMatch(remainingText);
        
        if (match != null) {
          if (earliestMatchStart == null || match.start < earliestMatchStart) {
            earliestMatchStart = match.start;
            earliestMatchEnd = match.end;
            matchedKeyword = keyword;
          }
        }
      }
      
      if (matchedKeyword != null && earliestMatchStart != null && earliestMatchEnd != null) {
        // Add text before the keyword
        if (earliestMatchStart > 0) {
          spans.add(TextSpan(
            text: remainingText.substring(0, earliestMatchStart),
            style: const TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xFF5D4037), // Brown text for story
            ),
          ));
        }
        
        // Add the highlighted keyword
        final keywordToHighlight = matchedKeyword;
        spans.add(TextSpan(
          text: remainingText.substring(earliestMatchStart, earliestMatchEnd),
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF3E2723), // Dark brown text for keyword
            fontWeight: FontWeight.bold,
            backgroundColor: Color(0xFFEDE284), // Yellow highlight
          ),
          recognizer: TapGestureRecognizer()..onTap = () => _showDefinition(keywordToHighlight),
        ));
        
        // Update remaining text
        remainingText = remainingText.substring(earliestMatchEnd);
      } else {
        // No more matches, add the rest of the text
        spans.add(TextSpan(
          text: remainingText,
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF5D4037), // Brown text for story
          ),
        ));
        break;
      }
    }
    
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF494013)),
                      SizedBox(height: 20),
                      Text(
                        'Generating your story...',
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: const Text(
                        'Your Story',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF494013),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap on highlighted keywords to see definitions',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCF6DB),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: _buildHighlightedText(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _generateStoryWithGemini,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF494013),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Generate New Story',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
