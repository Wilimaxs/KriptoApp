import 'dart:io';

import 'package:enkridekrib_app/contents/result_decrypt.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DecryptProcess extends StatefulWidget {
  const DecryptProcess({super.key});

  static const routeName = 'decrypt';

  @override
  State<DecryptProcess> createState() => __DecryptProcessState();
}

class __DecryptProcessState extends State<DecryptProcess> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController controllerkunci = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF8B83FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'home');
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
          'Decrypt your image here',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // input user for key
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  width: width,
                  height: 67,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB4AEFF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: TextFormField(
                    controller: controllerkunci,
                    decoration: const InputDecoration(
                      label: Text(
                        'Insert your key here',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Chooser User Image
                Row(
                  children: [
                    const Text(
                      'Choose your image',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        try {
                          final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );

                          if (image != null) {
                            setState(() {
                              _selectedImage = File(image.path);
                            });
                          }
                        } catch (e) {
                          // Handle any errors silently or show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Failed to pick image'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0XFFD9D9D9),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.insert_photo_outlined,
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
                  height: 200, // Set appropriate height
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _selectedImage != null
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
                      if (controllerkunci.text.isEmpty ||
                          _selectedImage == null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Peringatan'),
                            content: const Text(
                                'Semua data harus diisi sebelum melanjutkan.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Menutup popup
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultDecrypt(
                              kunci: controllerkunci.text,
                              image: _selectedImage,
                            ),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xFF6860D7),
                      ),
                    ),
                    child: const Text(
                      'Decrypt!',
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
          ),
        ),
      ),
    );
  }
}
