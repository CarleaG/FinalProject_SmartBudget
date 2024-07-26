// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import './home.dart' as home;
import './graph.dart' as graph;
import './transaction.dart' as transaction;

class MyTabs extends StatefulWidget {
  @override
  _MyTabsState createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> transactions = [];
  double monthlyBudget = 0.0;
  bool _isDarkMode = false;

  String _userName = 'Nobaisah';
  String _userEmail = 'nobaisahkheram@gmail.com';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('You have logged out successfully!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Budget Smart'),
          content: SingleChildScrollView(
            child: Text(
              'Budget Smart is a comprehensive budgeting app designed to help you track your expenses, '
              'manage your finances, and achieve your financial goals.',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showFAQs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('FAQs'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Q: How do I add a new transaction?'),
                Text('A: Tap on the "Add" button in the Home tab.'),
                SizedBox(height: 10),
                Text('Q: How do I set a budget?'),
                Text('A: Enter your desired monthly budget in the Home tab.'),
                SizedBox(height: 10),
                Text('Q: How do I switch between dark mode and light mode?'),
                Text('A: Use the switch in the app drawer.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showLegalInformation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Legal Information'),
          content: SingleChildScrollView(
            child: Text(
              'This app is provided "as-is" without warranties of any kind. Users are advised to '
              'use the app at their own risk. The developers are not liable for any issues arising '
              'from the use of this application.',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAppInformation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Version: 1.0.0'),
                Text('Developer: Guerra, Kheram, Leido, Macalalad Company'),
                Text('Release Date: July 01, 2024'),
                Text('Contact: support@budgets.com'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    String newName = _userName;
    String newEmail = _userEmail;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  icon: Icon(Icons.person),
                ),
                onChanged: (value) {
                  newName = value;
                },
                controller: TextEditingController()..text = newName,
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  icon: Icon(Icons.email),
                ),
                onChanged: (value) {
                  newEmail = value;
                },
                controller: TextEditingController()..text = newEmail,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  _userName = newName;
                  _userEmail = newEmail;
                });
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Budget Smart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.deepPurple, Colors.purpleAccent],
                  ),
                ),
                accountName: Text(
                  _userName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  _userEmail,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('/bill_gates.jpg'), // Replace with your profile picture asset
                ),
                onDetailsPressed: _editProfile,
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('About Budget Smart'),
                onTap: _showAbout,
              ),
              ListTile(
                leading: Icon(Icons.brightness_6),
                title: Text('Dark Mode/Light Mode'),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    _toggleDarkMode();
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.gavel),
                title: Text('Legal Information'),
                onTap: _showLegalInformation,
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text('App Information'),
                onTap: _showAppInformation,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            home.Home(
              onTransactionsChanged: (newTransactions) {
                setState(() {
                  transactions = newTransactions;
                });
              },
              onBudgetChanged: (newBudget) {
                setState(() {
                  monthlyBudget = newBudget;
                });
              },
            ),
            graph.Graph(expenses: transactions),
            transaction.Transaction(
              transactions: transactions,
              categoryBudgets: {}, // Add category budgets here
              monthlyBudget: monthlyBudget,
            ),
          ],
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.deepPurple,
            labelColor: Colors.deepPurple,
            tabs: [
              Tab(icon: Icon(Icons.home)),
              Tab(icon: Icon(Icons.pie_chart)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
      ),
    );
  }
}
