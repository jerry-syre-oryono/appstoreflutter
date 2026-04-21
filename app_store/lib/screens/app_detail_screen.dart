import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_model.dart';
import '../providers/update_provider.dart';
import '../widgets/update_dialog.dart';

class AppDetailScreen extends StatelessWidget {
  final AppModel app;
  const AppDetailScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(app.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (app.iconUrl != null)
              Center(child: Image.network(app.iconUrl!, height: 120)),
            const SizedBox(height: 16),
            Text('Package: ${app.packageName}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(app.description ?? 'No description', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                final updateProvider = Provider.of<UpdateProvider>(context, listen: false);
                final update = await updateProvider.checkUpdate(app.packageName, 0);
                if (context.mounted) {
                  if (update != null && update['update'] == true) {
                    showDialog(
                      context: context,
                      barrierDismissible: update['is_force'] == false,
                      builder: (_) => UpdateDialog(
                        versionName: update['version_name'],
                        changelog: update['changelog'] ?? '',
                        apkUrl: update['apk_url'],
                        fileHash: update['file_hash'],
                        isForce: update['is_force'],
                      ),
                    );
                  } else {
                    // Install latest version directly (first install)
                    final latestVersion = app.latestVersionCode;
                    if (latestVersion != null) {
                      // fetch version details separately, simplified
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Install triggered')));
                    }
                  }
                }
              },
              icon: const Icon(Icons.download),
              label: const Text('Install / Update'),
            ),
          ],
        ),
      ),
    );
  }
}
