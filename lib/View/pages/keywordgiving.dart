import 'package:flutter/material.dart';
import 'package:ww/View/pages/keyword_story_page.dart';

class FactCheckPage extends StatefulWidget {
  const FactCheckPage({Key? key}) : super(key: key);

  @override
  State<FactCheckPage> createState() => _FactCheckPageState();
}

class _FactCheckPageState extends State<FactCheckPage> {
  final TextEditingController _keywordsController = TextEditingController();
  final List<String> _keywords = [];

  @override
  void dispose() {
    _keywordsController.dispose();
    super.dispose();
  }

  void _addKeyword() {
    final keyword = _keywordsController.text.trim();
    if (keyword.isNotEmpty) {
      setState(() {
        _keywords.add(keyword);
        _keywordsController.clear();
      });
    }
  }

  void _removeKeyword(int index) {
    setState(() {
      _keywords.removeAt(index);
    });
  }

  void _generateStory() {
    if (_keywords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one keyword")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => KeywordStoryPage(keywords: _keywords),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Create Your Story', style: TextStyle(color: Color(0xFF494013), fontFamily: 'Poppins',fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFEDE284),
        iconTheme: const IconThemeData(color: Color(0xFF494013)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Enter keywords for your story:',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _keywordsController,
                      decoration: InputDecoration(
                        hintText: 'Enter a keyword',
                        filled: true,
                        fillColor: const Color(0xFFFCF6DB),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _addKeyword(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _addKeyword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF494013),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_keywords.isNotEmpty) ...[
                const Text(
                  'Your keywords:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCF6DB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: _keywords.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE284),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _keywords[index],
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Color(0xFF494013),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Color(0xFF494013)),
                                onPressed: () => _removeKeyword(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ] else
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/search1.png', width: 150),
                        const SizedBox(height: 16),
                        const Text(
                          'Add keywords to generate a story',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xFF494013),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generateStory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF494013),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Generate Story',
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