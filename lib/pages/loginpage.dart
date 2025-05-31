import 'package:flutter/material.dart';
import 'package:sciverse/components/signinbutton.dart';
import 'package:sciverse/components/textfield.dart';
import 'package:sciverse/components/theme.dart';
import 'package:sciverse/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final usernameController = TextEditingController();

  Future<void> _saveUserName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("username", usernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppData.splash,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/sciverse_logo1.png",
                  width: 500,
                  height: 250,
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Username",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    MyTextField(
                      controller: usernameController,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Signinbutton(onTap: () async {
                      if (usernameController.text.isNotEmpty) {
                        await _saveUserName();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Homepage()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a username')),
                        );
                      }
                    },)
                  ],
                )
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }
}