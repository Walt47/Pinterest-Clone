import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/pages/homepage.dart';

class SelectorScreen extends StatefulWidget {
  const SelectorScreen({super.key});

  @override
  State<SelectorScreen> createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  int selectedIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const Center(
        child: Text("Search Page",
            style: TextStyle(fontSize: 24, color: Colors.black))),
    const Center(
        child: Text("Messages Page",
            style: TextStyle(fontSize: 24, color: Colors.black))),
    const Center(
        child: Text("Profile Page",
            style: TextStyle(fontSize: 24, color: Colors.black))),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, color: Colors.black),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded, color: Colors.black),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_fill, color: Colors.black),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill, color: Colors.black),
            label: "",
          ),
        ],
      ),
    );
  }
}
