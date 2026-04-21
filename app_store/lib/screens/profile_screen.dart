import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'submissions_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          ListTile(title: Text('Name: ${auth.user?.name ?? ''}')),
          ListTile(title: Text('Email: ${auth.user?.email ?? ''}')),
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(value: theme.isDarkMode, onChanged: (_) => theme.toggleTheme()),
          ),
          ListTile(
            title: const Text('My Submissions'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SubmissionsScreen())),
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await auth.logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
