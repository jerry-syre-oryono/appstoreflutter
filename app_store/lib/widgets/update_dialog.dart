import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/update_provider.dart';

class UpdateDialog extends StatefulWidget {
  final String versionName;
  final String changelog;
  final String apkUrl;
  final String fileHash;
  final bool isForce;

  const UpdateDialog({
    super.key,
    required this.versionName,
    required this.changelog,
    required this.apkUrl,
    required this.fileHash,
    required this.isForce,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _downloading = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.system_update, color: Colors.teal),
          const SizedBox(width: 8),
          Text('Update Available v${widget.versionName}'),
        ],
      ),
      content: _downloading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 8),
                Text('Downloading... ${(_progress * 100).toInt()}%'),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('What\'s new:'),
                const SizedBox(height: 8),
                Text(widget.changelog),
              ],
            ),
      actions: [
        if (!widget.isForce && !_downloading)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
        if (!_downloading)
          ElevatedButton(
            onPressed: () async {
              setState(() => _downloading = true);
              final updateProvider = Provider.of<UpdateProvider>(context, listen: false);
              await updateProvider.downloadAndInstall(
                context,
                widget.apkUrl,
                widget.fileHash,
                widget.isForce,
                (p) => setState(() => _progress = p),
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Update Now'),
          ),
      ],
    );
  }
}
