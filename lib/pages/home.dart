import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatapp/Login Signup/login.dart';
import 'package:chatapp/pages/settings.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  final bool isPinSetup;
  const HomeScreen({
    super.key,
    required this.isLoggedIn,
    required this.isPinSetup,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
    });
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Color(0xFF075E54),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            color: const Color(0xFF075E54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined),
            color: const Color(0xFF075E54),
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              try {
                final XFile? photo = await picker.pickImage(
                  source: ImageSource.camera,
                );
                if (photo != null) {
                  // Handle the captured image
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Image captured: ${photo.path}')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error accessing camera')),
                  );
                }
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF075E54)),
            onSelected: (value) {
              switch (value) {
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  break;
              }
            },
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'new_group',
                    child: Text('New group'),
                  ),
                  const PopupMenuItem(
                    value: 'new_community',
                    child: Text('New community'),
                  ),
                  const PopupMenuItem(
                    value: 'new_broadcast',
                    child: Text('New broadcast'),
                  ),
                  const PopupMenuItem(
                    value: 'linked_devices',
                    child: Text('Linked devices'),
                  ),
                  const PopupMenuItem(value: 'starred', child: Text('Starred')),
                  const PopupMenuItem(
                    value: 'payments',
                    child: Text('Payments'),
                  ),
                  const PopupMenuItem(
                    value: 'read_all',
                    child: Text('Read all'),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $userName!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'You are successfully logged in',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: () {},
            backgroundColor: const Color.fromARGB(246, 196, 59, 238),
            mini: true,
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {},
            backgroundColor: const Color.fromARGB(246, 196, 59, 238),
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 0), // Add padding above bottom nav bar
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF075E54),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chats'),
          BottomNavigationBarItem(icon: Icon(Icons.update), label: 'Updates'),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Communities',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.call), label: 'Calls'),
        ],
      ),
    );
  }
}
