import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WordOfDayApp());
}

class WordOfDayApp extends StatelessWidget {
  const WordOfDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word of the Day',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5EEBF),
          primary: const Color.fromARGB(255, 222, 227, 121), // Complementary darker shade
          secondary: const Color(0xFFD1C98E), // Medium shade
          surface: const Color(0xFFF5EEBF), // Your specified beige color
          background: const Color(0xFFFDF9E2), // Lighter version for background
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:  Color(0xFF494013),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const WordOfDayPage(),
    );
  }
}

class WordOfDayPage extends StatefulWidget {
  const WordOfDayPage({super.key});

  @override
  State<WordOfDayPage> createState() => _WordOfDayPageState();
}

class _WordOfDayPageState extends State<WordOfDayPage> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String _word = "";
  String _partOfSpeech = "";
  String _definition = "";
  String _example = "";
  String _phonetic = "";
  String _errorMessage = "";
  String _currentDate = "";
  String _lastFetchDate = "";
  late AnimationController _controller;
  late Animation<double> _animation;
  
  // Replace with your actual API Key if needed
  final String _apiKey = "AIzaSyBjq6XvW_BSe70pA6pqOKwKrbuP8H--6YY"; 
  final String _apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent";

  // List of interesting words to use as fallbacks
  final List<Map<String, String>> _fallbackWords = [
    {
      "word": "serendipity",
      "partOfSpeech": "noun",
      "definition": "The occurrence and development of events by chance in a happy or beneficial way",
      "example": "A fortunate stroke of serendipity came my way when I least expected it",
      "phonetic": "/ˌsɛrənˈdɪpɪti/"
    },
    {
      "word": "mellifluous",
      "partOfSpeech": "adjective",
      "definition": "Sweet or musical; pleasant to hear",
      "example": "The mellifluous tones of her voice captivated the entire audience",
      "phonetic": "/məˈlɪfluəs/"
    },
    {
      "word": "ephemeral",
      "partOfSpeech": "adjective",
      "definition": "Lasting for a very short time",
      "example": "The ephemeral beauty of cherry blossoms makes them all the more precious",
      "phonetic": "/ɪˈfɛm(ə)rəl/"
    },
    {
      "word": "ubiquitous",
      "partOfSpeech": "adjective",
      "definition": "Present, appearing, or found everywhere",
      "example": "Mobile phones have become ubiquitous in modern society",
      "phonetic": "/juːˈbɪkwɪtəs/"
    },
    {
      "word": "panacea",
      "partOfSpeech": "noun",
      "definition": "A solution or remedy for all difficulties or diseases",
      "example": "Exercise is not a panacea for all health problems, but it certainly helps",
      "phonetic": "/ˌpanəˈsiːə/"
    },
    {
      "word": "quintessential",
      "partOfSpeech": "adjective",
      "definition": "Representing the most perfect or typical example of a quality or class",
      "example": "The small cafe is the quintessential Parisian dining experience",
      "phonetic": "/ˌkwɪntɪˈsɛnʃ(ə)l/"
    },
    {
      "word": "cacophony",
      "partOfSpeech": "noun",
      "definition": "A harsh, discordant mixture of sounds",
      "example": "The cacophony of the construction site made it impossible to concentrate",
      "phonetic": "/kəˈkɒfəni/"
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _getCurrentDate();
    _loadWordOfDay();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _getCurrentDate() {
    final now = DateTime.now();
    setState(() {
      _currentDate = "${_getMonthName(now.month)} ${now.day}, ${now.year}";
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  Future<void> _loadWordOfDay() async {
    setState(() {
      _isLoading = true;
      _errorMessage = ""; // Clear previous errors
    });

    try {
      final today = "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";

      // If we already fetched a word today, use it
      if (_lastFetchDate == today && _word.isNotEmpty) {
        setState(() => _isLoading = false);
        _controller.forward(from: 0.0);
        return;
      }
      
      await _fetchWordFromGemini();

      if (_word.isNotEmpty) {
        _lastFetchDate = today;
        _controller.forward(from: 0.0);
      }
    } catch (e) {
      setState(() => _errorMessage = "Failed to load word: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _useFallbackWord() {
    // Get a random word from our fallback list
    final random = Random();
    final fallbackWord = _fallbackWords[random.nextInt(_fallbackWords.length)];
    
    setState(() {
      _word = fallbackWord["word"]!;
      _partOfSpeech = fallbackWord["partOfSpeech"]!;
      _definition = fallbackWord["definition"]!;
      _example = fallbackWord["example"]!;
      _phonetic = fallbackWord["phonetic"]!;
    });
  }

  Future<void> _fetchWordFromGemini() async {
    final requestBody = {
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Generate a word of the day in JSON format with an uncommon but interesting English word. Choose words that are elegant, sophisticated, or intellectually stimulating. Include word, part of speech, definition, example sentence, and phonetic pronunciation. Format as valid JSON: {\"word\": \"\", \"partOfSpeech\": \"\", \"definition\": \"\", \"example\": \"\", \"phonetic\": \"\"}"
            }
          ]
        }
      ],
      "generationConfig": {
        "temperature": 0.7, // Increased from 0.3 to add more variety
        "topK": 40,
        "topP": 0.95,
        "maxOutputTokens": 1024,
      }
    };

    try {
      final uri = Uri.parse('$_apiUrl?key=$_apiKey');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        
        if (responseData.containsKey('candidates') && 
            responseData['candidates'].isNotEmpty) {
          final String textResponse =
              responseData['candidates'][0]['content']['parts'][0]['text'];
          
          final match = RegExp(r'\{.*\}', dotAll: true).firstMatch(textResponse);

          if (match != null) {
            final jsonStr = match.group(0)!;
            
            try {
              final wordData = jsonDecode(jsonStr);
              setState(() {
                _word = wordData['word'] ?? "";
                _partOfSpeech = wordData['partOfSpeech'] ?? "";
                _definition = wordData['definition'] ?? "";
                _example = wordData['example'] ?? "";
                _phonetic = wordData['phonetic'] ?? "";
              });
            } catch (e) {
              _useFallbackWord();
            }
          } else {
            _useFallbackWord();
          }
        } else {
          _useFallbackWord();
        }
      } else {
        _useFallbackWord();
      }
    } catch (e) {
      _useFallbackWord();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF9E2), // Lighter beige background
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 254, 238, 153), // Darker complementary color
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        elevation: 0,
        title: const Text('Word of the Day', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22,color:  Color(0xFF494013),
      )),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _lastFetchDate = ""; // Clear the date to force refresh
              _loadWordOfDay();
            },
            tooltip: 'Get New Word',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Fetching today's word...",
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? _buildErrorView()
              : _buildWordView(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, 
                  color: Theme.of(context).colorScheme.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  "Oops! Something went wrong",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.black87),
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadWordOfDay,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again', 
                    style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordView() {
    return FadeTransition(
      opacity: _animation,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date display with decorative line
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1,
                    width: 40,
                    color: Colors.grey[400],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _currentDate,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 40,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Main word card
              Card(
                child: Column(
                  children: [
                    // Word header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EEBF),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _word.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: Color(0xFF8B7D3A),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _phonetic,
                            style: TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B7D3A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF8B7D3A).withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              _partOfSpeech,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF8B7D3A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Definition and example
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Definition section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.menu_book,
                                color: Theme.of(context).colorScheme.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "DEFINITION",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Color(0xFF8B7D3A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _definition,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Example section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.format_quote,
                                color: Theme.of(context).colorScheme.primary,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "EXAMPLE",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Color(0xFF8B7D3A),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5EEBF).withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFF5EEBF),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Text(
                                        _example,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontStyle: FontStyle.italic,
                                          height: 1.5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // New word button
              ElevatedButton.icon(
                onPressed: () {
                  _lastFetchDate = ""; // Clear the date to force refresh
                  _loadWordOfDay();
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Discover New Word', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ),
              
              const SizedBox(height: 24),
              
              // Info text
              Text(
                "Expand your vocabulary daily with elegant and fascinating words",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}