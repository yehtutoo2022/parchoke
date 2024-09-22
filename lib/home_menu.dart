import 'package:flutter/material.dart';
import 'package:par_choke_sayardaw/audio_player_screen.dart';
import 'package:par_choke_sayardaw/setting_page.dart';
import 'package:par_choke_sayardaw/video/video_list.dart';

import 'audio_page.dart';
import 'home_page.dart';
import 'model/short_video_model.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

 // final List<Widget> _screens = [];

  final List<Widget> _screens = [
    const HomePage(title: 'Home',),
    AudioListScreen(),
    ShortVideoList(),
    const SettingsPage(),
  ];



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'Articles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ondemand_video_outlined),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        backgroundColor: Colors.brown[100],
      ),
    );
  }
}

