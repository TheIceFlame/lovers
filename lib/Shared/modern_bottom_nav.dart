import 'package:flutter/material.dart';
import 'package:lover/Widgets/home_screen.dart';

class ModernBottomNav extends StatefulWidget {
  const ModernBottomNav({Key? key}) : super(key: key);

  @override
  State<ModernBottomNav> createState() => _ModernBottomNavState();
}

class _ModernBottomNavState extends State<ModernBottomNav> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.dashboard_rounded,
    Icons.access_time_rounded,
    Icons.crop_square_rounded,
    Icons.menu_rounded,
  ];

  final List<String> _titles = [
    'Home',
    'History',
    'Gallery',
    'Menu',
  ];

  final List<Widget> _pages = [
     HomeScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_icons.length, (index) {
              final bool isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 0,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.redAccent.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _icons[index],
                        color: isSelected ? Colors.redAccent : Colors.grey[600],
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            _titles[index],
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      body: _pages[_selectedIndex]
    );
  }
}
