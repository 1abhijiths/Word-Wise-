import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ww/View/pages/recognising.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  late ImagePicker imagePicker;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final XFile? xfile = await imagePicker.pickImage(source: source);
      if (xfile != null) {
        final File image = File(xfile.path);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RecogniseImage(imagee: image)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image picking cancelled.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEBF), // Light background for modern look
      // appBar: AppBar(
      //   title: const Text('Upload Image',style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,color: Colors.black87),),
      //   backgroundColor: Color(0xFFEDE284), // Professional app bar color
      //   elevation: 0, // Remove shadow
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_search,
              size: 80,
              color: Colors.black12
            ),
            const SizedBox(height: 20),
            const Text(
              'Select an image source:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,fontFamily: 'Poppins',fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera, context),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera',style: TextStyle(fontFamily: 'Poppins'),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDE284), // Button color
                    foregroundColor: Colors.black, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery, context),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Gallery',style: TextStyle(fontFamily: 'Poppins',fontSize: 15),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDE284),  // Button color
                    foregroundColor: Colors.black87, // Text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}