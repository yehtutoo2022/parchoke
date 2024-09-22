import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:par_choke_sayardaw/home_menu.dart';
import 'package:provider/provider.dart';

import 'audio_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AudioPlayerProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override

  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Par Choke Sayartaw',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeMenu(),
      debugShowCheckedModeBanner: false,
    );
  }
}

