import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciverse/components/buttonish.dart';
import 'package:sciverse/models/navigationprovider.dart';
import 'package:sciverse/pages/explore.dart';
import 'package:sciverse/pages/home.dart';
import 'package:sciverse/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '3d_home.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key,required});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String _savedUsername = '';

  @override
  void initState() {
    super.initState();
    _loadUsername(); // Load saved username when the page initializes
  }

  // Load username from SharedPreferences
  Future<void> _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedUsername = prefs.getString('username') ?? 'Guest';
    });
  }

  // List of pages for the BottomNavigationBar
  final List<Widget> _pages = [
    const Home(),
    // Explore(cameras: ,),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Welcome, $_savedUsername'),
        actions: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: (){
                print("avatar tapped");
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: AssetImage('assets/placeholder.jpg'),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('username');
                Navigator.pushReplacementNamed(context, '/login'); // Adjust to your login route
              },
            ),
          ],
        ),
      ),
      body: _pages[navigationProvider.selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationProvider.selectedIndex, // Sync with Provider
        onTap: (index) {
          navigationProvider.setIndex(index); // Update Provider state
        },
        selectedItemColor: Colors.blueGrey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.adf_scanner_rounded),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}