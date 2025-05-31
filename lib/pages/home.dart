import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciverse/models/navigationprovider.dart';
import 'package:sciverse/pages/explore.dart';
import 'package:sciverse/pages/profile.dart';

import '../components/buttonish.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome 😊",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 50,
            ),
            Buttonish(
                write: "Explore",
                onTap: () {
                  navigationProvider.setIndex(1);
                }
            ),
            const SizedBox(
              height: 30,
            ),
            Buttonish(
                write: "Profile",
                onTap: () {
                  navigationProvider.setIndex(2);
                }
            ),
          ],
        ),
      ),
    );
  }
}
