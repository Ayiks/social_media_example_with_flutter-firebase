import 'package:familicious/views/chat/chat_view.dart';
import 'package:familicious/views/favourites/favourite_view.dart';
import 'package:familicious/views/profile/profile_view.dart';
import 'package:familicious/views/timeline/timeline_view.dart';
import 'package:flutter/material.dart';
import 'package:unicons/unicons.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  List<Widget> _views = [
    const TimeLineView(),
    const ChatView(),
    FavouriteView(),
    ProfileView()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _views,
        index: _currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).iconTheme.color,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(UniconsLine.history), label: 'Timeline'),
          BottomNavigationBarItem(
              icon: Icon(UniconsLine.comment_dots), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(UniconsLine.heart), label: 'Favourites'),
          BottomNavigationBarItem(
              icon: Icon(UniconsLine.user), label: 'Profile'),
        ],
      ),
    );
  }
}
