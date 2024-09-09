import 'package:flutter/material.dart';
import 'package:headchef/pages/order_list_page.dart'; // Đảm bảo đúng đường dẫn

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome Head Chef'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF4CAF50),
              ),
              accountName: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      'HC',
                      style: TextStyle(fontSize: 20.0),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Head Chef',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'headchef@gmail.com',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              accountEmail: null,
            ),
            ListTile(
              leading: Icon(Icons.home, color: Color(0xFF4CAF50)),
              title: Text('Home'),
              onTap: () {
                // Navigate to home page
              },
            ),
            ListTile(
              leading: Icon(Icons.list, color: Color(0xFF4CAF50)),
              title: Text('Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant, color: Color(0xFF4CAF50)),
              title: Text('Restaurants'),
              onTap: () {
                // Navigate to restaurants page
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Color(0xFF4CAF50)),
              title: Text('Settings'),
              onTap: () {
                // Navigate to settings page
              },
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF4CAF50)),
              title: Text('About Me'),
              onTap: () {
                // Navigate to about page
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[200],
      ),
    );
  }
}
