import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _pickedImageBytes;
  bool _pickingImage = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthController>().currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _addressController.text = user.address;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    setState(() => _pickingImage = true);
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        setState(() => _pickedImageBytes = bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not pick image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      setState(() => _pickingImage = false);
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      final userController = context.read<UserController>();

      await userController.updateProfile(
        authController,
        _nameController.text,
        _addressController.text,
        _phoneController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserController>().isLoading;
    final user = context.watch<AuthController>().currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.arrow_back_ios_new, size: 14, color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Text('Edit Profile', textAlign: TextAlign.center,
                        style: GoogleFonts.playfairDisplay(
                            fontSize: 22, fontWeight: FontWeight.w700, fontStyle: FontStyle.italic, color: Colors.black)),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ── Avatar Picker ───────────────────────────────
                      GestureDetector(
                        onTap: _pickingImage ? null : _pickImage,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 54,
                              backgroundColor: const Color(0xFFE5D9CC),
                              backgroundImage: _pickedImageBytes != null
                                  ? MemoryImage(_pickedImageBytes!) as ImageProvider
                                  : null,
                              child: _pickedImageBytes == null
                                  ? Text(
                                      user?.name.substring(0, 1).toUpperCase() ?? '?',
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                                    )
                                  : null,
                            ),
                            if (_pickingImage)
                              const CircularProgressIndicator(color: Colors.white),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD2BCA8),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                                ),
                                child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Tap to change photo',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.black38)),
                      const SizedBox(height: 28),

                      // ── Form Fields in white card ───────────────────
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                        child: Column(
                          children: [
                            CustomTextField(
                              label: 'Full Name',
                              hint: 'Enter your name',
                              controller: _nameController,
                              validator: (val) => val == null || val.isEmpty ? 'Name is required' : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Phone Number',
                              hint: 'Enter your phone number',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: 'Shipping Address',
                              hint: 'Enter your address',
                              controller: _addressController,
                              keyboardType: TextInputType.multiline,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD2BCA8),
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text('SAVE CHANGES',
                                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
