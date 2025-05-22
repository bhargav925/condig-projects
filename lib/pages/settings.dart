import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String userName = '';
  String userStatus = 'AT COLLEGE';
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
      profileImageUrl = prefs.getString('profileImage');
    });
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Color iconColor = Colors.grey,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor, size: 28),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Section
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                child: profileImageUrl == null ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
              ),
              title: Text(userName, style: const TextStyle(fontSize: 18)),
              subtitle: const Text('AT COLLEGE'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.qr_code, color: Colors.green),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const Divider(),

            // Account
            _buildSettingItem(
              icon: Icons.key,
              title: 'Account',
              subtitle: 'Security notifications, change email',
            ),

            // Privacy
            _buildSettingItem(
              icon: Icons.lock,
              title: 'Privacy',
              subtitle: 'Block contacts, disappearing messages',
            ),

            // Avatar
            _buildSettingItem(
              icon: Icons.face,
              title: 'Avatar',
              subtitle: 'Create, edit, profile photo',
            ),

            // Lists
            _buildSettingItem(
              icon: Icons.group,
              title: 'Lists',
              subtitle: 'Manage people and groups',
            ),

            // Chats
            _buildSettingItem(
              icon: Icons.chat,
              title: 'Chats',
              subtitle: 'Theme, wallpapers, chat history',
            ),

            // Notifications
            _buildSettingItem(
              icon: Icons.notifications,
              title: 'Notifications',
              subtitle: 'Message, group & call tones',
            ),

            // Storage and data
            _buildSettingItem(
              icon: Icons.data_usage,
              title: 'Storage and data',
              subtitle: 'Network usage, auto-download',
            ),

            // App language
            _buildSettingItem(
              icon: Icons.language,
              title: 'App language',
              subtitle: 'English (device\'s language)',
            ),

            // Help
            _buildSettingItem(
              icon: Icons.help_outline,
              title: 'Help',
              subtitle: 'Help centre, contact us, privacy policy',
            ),

            // Invite a friend
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildSettingItem(
                icon: Icons.people,
                title: 'Invite a friend',
                subtitle: '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
