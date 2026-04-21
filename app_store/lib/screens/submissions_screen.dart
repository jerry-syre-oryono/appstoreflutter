import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'submit_app_screen.dart';

class SubmissionsScreen extends StatefulWidget {
  const SubmissionsScreen({super.key});

  @override
  State<SubmissionsScreen> createState() => _SubmissionsScreenState();
}

class _SubmissionsScreenState extends State<SubmissionsScreen> {
  List<dynamic> submissions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    try {
      final res = await ApiService.get('/submissions');
      setState(() {
        submissions = res.data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Submissions')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : submissions.isEmpty
              ? const Center(child: Text('No submissions yet'))
              : ListView.builder(
                  itemCount: submissions.length,
                  itemBuilder: (ctx, i) {
                    final s = submissions[i];
                    return ListTile(
                      title: Text(s['app_name']),
                      subtitle: Text('Status: ${s['status']}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmitAppScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
