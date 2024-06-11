import 'package:flutter/material.dart';
import 'package:smartcart_app/pages/new_list_page.dart';
import 'package:smartcart_app/pages/shopping_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping List',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: HomePage(),
      routes: {
        '/shopping_list': (context) => ShoppingListPage(category: 'Belanja Bulanan'),
        '/new_list': (context) => NewListPage(),
        
      },
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, Tina',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Mau belanja apa hari ini?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ShoppingList(),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/new_list'); // Mengarahkan ke halaman NewListPage
                    },
                    child: Text('Buat Daftar'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  BottomNavigationBar(
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Beranda',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Akun',
                      ),
                    ],
                    onTap: (index) {
                      if (index == 1) {
                        Navigator.pushNamed(context, '/profile');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingList extends StatelessWidget {
  final List<String> shoppingCategories = [
    'Belanja Bulanan',
    'Belanja Skincare',
    'Travelling',
    'HobiKU',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: shoppingCategories.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            tileColor: category == 'Belanja Bulanan' ? Colors.orange : Colors.orange.shade100,
            title: Text(category),
            trailing: Icon(Icons.more_vert),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingListPage(category: category),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
