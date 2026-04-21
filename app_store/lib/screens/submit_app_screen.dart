import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SubmitAppScreen extends StatefulWidget {
  const SubmitAppScreen({super.key});

  @override
  State<SubmitAppScreen> createState() => _SubmitAppScreenState();
}

class _SubmitAppScreenState extends State<SubmitAppScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _packageController = TextEditingController();
  final _descController = TextEditingController();
  final String? _apkUrl = null;
  final String? _tempPath = null;
  bool _uploading = false;

  Future<void> _uploadApk() async {
    setState(() => _uploading = true);
    // In real app, use file picker to get APK file
    // For demo, assume you have a file picker. We'll simulate with a dummy file.
    // You need to implement file_picker or similar.
    // Here's a placeholder:
    // final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['apk']);
    // if (result != null) {
    //   File file = File(result.files.single.path!);
    //   String fileName = result.files.single.name;
    //   FormData formData = FormData.fromMap({
    //     'apk': await MultipartFile.fromFile(file.path, filename: fileName),
    //   });
    //   final response = await ApiService.upload('/submissions/upload-apk', formData);
    //   setState(() {
    //     _apkUrl = response.data['apk_url'];
    //     _tempPath = response.data['temp_path'];
    //     _uploading = false;
    //   });
    // }
    setState(() => _uploading = false);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() && _apkUrl != null) {
      try {
        await ApiService.post('/submissions', data: {
          'app_name': _nameController.text,
          'package_name': _packageController.text,
          'description': _descController.text,
          'apk_url': _apkUrl,
          'temp_path': _tempPath,
        });
        if (mounted) Navigator.pop(context);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Submission sent')));
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submit New App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'App Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _packageController, decoration: const InputDecoration(labelText: 'Package Name'), validator: (v) => v!.isEmpty ? 'Required' : null),
              TextFormField(controller: _descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploading ? null : _uploadApk,
                child: _uploading ? const CircularProgressIndicator() : const Text('Select & Upload APK'),
              ),
              if (_apkUrl != null) const Text('APK uploaded', style: TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Submit for Review')),
            ],
          ),
        ),
      ),
    );
  }
}
