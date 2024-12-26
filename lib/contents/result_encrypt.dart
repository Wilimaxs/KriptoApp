import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ResultEncrypt extends StatefulWidget {
  final String kunci;
  final String? method;
  final String plaintext;
  final File? image;

  const ResultEncrypt(
      {super.key,
      required this.kunci,
      required this.method,
      required this.plaintext,
      required this.image});

  @override
  State<ResultEncrypt> createState() => _ResultEncryptState();
}

class _ResultEncryptState extends State<ResultEncrypt> {
  File? _selectedImage;
  bool _isLoading = true;
  final String _placeholderImageUrl = 'https://via.placeholder.com/400x200';

  @override
  void initState() {
    super.initState();
    _initializePlaceholderImage();
  }

  Future<void> _initializePlaceholderImage() async {
    try {
      final response = await http.get(Uri.parse(_placeholderImageUrl));
      if (response.statusCode == 200) {
        final tempDir = await getTemporaryDirectory();
        final tempImageFile = File('${tempDir.path}/temp_image.png');
        await tempImageFile.writeAsBytes(response.bodyBytes);

        if (mounted) {
          setState(() {
            _selectedImage = tempImageFile;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading placeholder image: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _downloadImage() async {
    if (_selectedImage == null) return;

    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        _showSnackBar('Storage directory not available');
        return;
      }

      final savedImage = await _selectedImage!.copy(
          '${directory.path}/downloaded_image_${DateTime.now().millisecondsSinceEpoch}.png');

      if (mounted) {
        _showSnackBar('Image saved to: ${savedImage.path}');
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
      if (mounted) {
        _showSnackBar('Failed to download image');
      }
    }
  }

  Future<void> _shareImage() async {
    if (_selectedImage == null) return;

    try {
      await Share.shareXFiles(
        [XFile(_selectedImage!.path)],
        text: 'Sharing image',
      );
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (mounted) {
        _showSnackBar('Failed to share image');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    print('Plain text = ${widget.plaintext}');
    print('Kunci = ${widget.kunci}');
    print('Methode = ${widget.method}');
    print('Gambarnya = ${widget.image}');

    return Scaffold(
      backgroundColor: const Color(0xFF8B83FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'encrypt');
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25),
            bottomLeft: Radius.circular(25),
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        backgroundColor: const Color(0xFF19F5B7),
        title: const Text(
          'Encrypt Succesful!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Chooser User Image
            Row(
              children: [
                const Text(
                  'Result',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _downloadImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF6860D7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.file_download_outlined,
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _shareImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFF6860D7),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.share,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            // image field
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
            ),
            const SizedBox(height: 30),
            // button submit check
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0xFF6860D7),
                  ),
                ),
                child: const Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'encrypt');
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    const Color(0xFF6860D7),
                  ),
                ),
                child: const Text(
                  'Encrypt Another Image?',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
