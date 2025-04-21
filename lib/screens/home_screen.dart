import 'dart:math';
import 'package:expenses_tracker/screens/add_expense.dart';
import 'package:expenses_tracker/screens/main_screen.dart';
import 'package:expenses_tracker/screens/stats.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  late Color selectedItem = Theme.of(context).colorScheme.primary;
  Color unselectedItem = Colors.grey;

  final GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30)
        ),
        child: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              index = value;
            });
          },

          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 3,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_rounded,
                color: index == 0 ? selectedItem : unselectedItem,
              ),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.auto_graph_rounded,
                color: index == 1 ? selectedItem : unselectedItem,
              ),
              label: 'Stats'
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute<bool>(
              builder: (BuildContext context) => const AddExpense(),
            ),
          );

          if (result == true && index == 0) {
            final mainScreenState = context.findAncestorStateOfType<MainScreenState>();
            mainScreenKey.currentState?.refreshData();
          }
        },
        shape: const CircleBorder(),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.tertiary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(Icons.add),
        ),
      ),
      body: index == 0
        ? MainScreen(key: mainScreenKey)
        : const StatsScreen()
    );
  }
}