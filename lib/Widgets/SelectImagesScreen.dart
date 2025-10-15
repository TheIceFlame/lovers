import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lover/Provider/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class SelectImagesScreen extends StatefulWidget {
  @override
  _SelectImagesScreenState createState() => _SelectImagesScreenState();
}

class _SelectImagesScreenState extends State<SelectImagesScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  List<XFile?> _selectedImages = [null, null, null, null];
  bool _loading = false;

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _selectedImages[index] = image;
      });
    }
  }


  Future<File> _compressFile(File file) async {
    final targetPath = "${file.path}_compressed.jpg";

    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60,
    );

    // Convert XFile to File
    return compressed != null ? File(compressed.path) : file;
  }

  Future<void> _saveImages() async {
    if (_selectedImages.any((img) => img == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all 4 images 💕")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // ✅ Get user info from provider
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.id;
      final userEmail = userProvider.email ?? '';

      if (userId == null) throw Exception('You must be logged in to upload images');

      List<String> uploadedUrls = [];

      for (int i = 0; i < _selectedImages.length; i++) {
        final originalFile = File(_selectedImages[i]!.path);

        // ✅ Compress the file before upload
        final compressedFile = await _compressFile(originalFile);

        final fileName =
            "${userEmail}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg";
        final path = 'uploads/$fileName';

        // ✅ Upload image to Supabase Storage
        final uploadResponse = await supabase.storage
            .from('memories')
            .upload(path, compressedFile);

        // ✅ Get public URL after upload
        final publicUrl = supabase.storage.from('memories').getPublicUrl(path);
        uploadedUrls.add(publicUrl);
      }

      // ✅ Save all uploaded URLs to Supabase users table
      await supabase.from('users').update({'images': uploadedUrls}).eq('id', userId);

      // ✅ Success message
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All images uploaded successfully 🎉")),
      );

      // ✅ Navigate to HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(userName: userProvider.name ?? ''),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading images 😢: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    final Color pink = const Color(0xFFFF6F91);
    final Color blue = const Color(0xFF4FC3F7);
    final Color navy = const Color(0xFF1C1C2E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Soft background decoration
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    pink.withOpacity(0.08),
                    blue.withOpacity(0.08),
                    Colors.white
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🌸 Title
                  Text(
                    "Memory Lane 💞",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Choose 4 pictures that capture your best memories together.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  // 📸 Grid for 4 images
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: 4,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemBuilder: (context, index) {
                        final image = _selectedImages[index];
                        return GestureDetector(
                          onTap: () => _pickImage(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: image == null
                                    ? pink.withOpacity(0.3)
                                    : Colors.transparent,
                                width: 2,
                              ),
                              image: image != null
                                  ? DecorationImage(
                                image: FileImage(File(image.path)),
                                fit: BoxFit.cover,
                              )
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(2, 3),
                                ),
                              ],
                            ),
                            child: image == null
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_a_photo_rounded,
                                      size: 48, color: pink),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Add Photo",
                                    style: TextStyle(
                                      color: navy,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : null,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 💾 Save button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _saveImages,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadowColor: pink.withOpacity(0.4),
                        elevation: 4,
                      ),
                      child: _loading
                          ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                          : const Text(
                        "Save & Continue",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    "Your photos will be private, only visible to your partner 💙",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
