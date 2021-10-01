import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:status_saver/app/home_page.dart';
import 'package:status_saver/app/saved_page.dart';
import 'package:status_saver/providers/app_state.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appState.getHomePageIndex,
            onTap: (int index) {
              appState.setHomePageIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                label: 'Saved',
                icon: Icon(Icons.save_alt_outlined),
              ),
            ],
          ),
          body: PageView(
            controller: appState.pageController,
            children: [
              HomePage(),
              SavedPage(),
            ],
          ),
        );
      },
    );
  }
}
