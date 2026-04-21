import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<dynamic> submissions = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSubmissions();
  }

  Future<void> fetchSubmissions() async {
    try {
      final res = await ApiService.get('/admin/submissions');
      setState(() {
        submissions = res.data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> reviewSubmission(int id, String status, String notes) async {
    try {
      await ApiService.patch('/admin/submissions/$id', data: {
        'status': status,
        'reviewer_notes': notes,
      });
      fetchSubmissions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : submissions.isEmpty
              ? const Center(child: Text('No pending submissions'))
              : ListView.builder(
                  itemCount: submissions.length,
                  itemBuilder: (ctx, i) {
                    final s = submissions[i];
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(s['app_name']),
                        subtitle: Text('By: ${s['user']['name'] ?? '?'}\nPackage: ${s['package_name']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => reviewSubmission(s['id'], 'approved', 'Auto approved'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => reviewSubmission(s['id'], 'rejected', 'Rejected by admin'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
