import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfinalproject/Pages/Screen/food_app_home_screen.dart';
import 'package:flutterfinalproject/Pages/Screen/profile_screen.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class AppMainScreen extends StatefulWidget {
  const AppMainScreen({super.key});

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  int currentindex = 0;
  final List<Widget> _pages = [
    FoodAppHomeScreen(),
    Scaffold(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentindex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItems(Iconsax.home_1, "A", 0),
            SizedBox(width: 10),
            _buildNavItems(Iconsax.heart, "B", 1),
            SizedBox(width: 10),
            _buildNavItems(Icons.person_outline, "C", 2),
            SizedBox(width: 10),
            Stack(
              clipBehavior: Clip.none,
              children: [
                _buildNavItems(Iconsax.shopping_cart, "D", 3),
                Positioned(
                  right: -7,
                  top: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 10,
                    child: Text(
                      "0",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  right: 115,
                  top: -25,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 35,
                    child: Icon(
                      CupertinoIcons.search,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItems(IconData icon, String lable, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          currentindex = index;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: currentindex == index ? Colors.red : Colors.green,
          ),
          SizedBox(height: 3),
          CircleAvatar(
            radius: 3,
            backgroundColor: currentindex == index
                ? Colors.red
                : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
