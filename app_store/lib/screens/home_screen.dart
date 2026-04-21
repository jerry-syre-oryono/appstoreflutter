import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/apps_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/animated_button.dart';
import 'app_detail_screen.dart';
import 'admin_panel.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tapCount = 0;
  Timer? _timer;

  void _onSecretTap(BuildContext context) {
    _tapCount++;
    if (_tapCount == 5) {
      _tapCount = 0;
      _timer?.cancel();
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (auth.isAdmin) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanel()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin access denied')),
        );
      }
    } else {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 2), () => _tapCount = 0);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppsProvider>(context, listen: false).fetchApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appsProvider = Provider.of<AppsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () => _onSecretTap(context),
          child: const Text('App Store'),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
          ),
        ],
      ),
      body: appsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : appsProvider.apps.isEmpty
              ? const Center(child: Text('No apps available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: appsProvider.apps.length,
                  itemBuilder: (context, index) {
                    final app = appsProvider.apps[index];
                    return AnimatedButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AppDetailScreen(app: app)),
                        );
                      },
                      child: GlassCard(
                        child: ListTile(
                          leading: app.iconUrl != null
                              ? Image.network(app.iconUrl!, width: 50, height: 50)
                              : const Icon(Icons.android, size: 50),
                          title: Text(app.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(app.packageName),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
