import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sciverse/components/themeprovider.dart';
import 'package:sciverse/models/navigationprovider.dart';
import 'package:sciverse/pages/splashscreen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Splashscreen(),
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
          );
        }
      ),
    );
  }
}
