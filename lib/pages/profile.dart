import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciverse/components/themeprovider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
                child: Text(themeProvider.isDarkMode ? 'Light Theme' : 'Dark Theme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}