// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  final List<Map<String, dynamic>> transactions;
  final Map<String, double> categoryBudgets;
  final double monthlyBudget;

  Transaction({
    required this.transactions,
    required this.categoryBudgets,
    required this.monthlyBudget,
  });

  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<Map<String, dynamic>> filteredTransactions = [];
  DateTime? selectedDate;
  String selectedCategory = 'All';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredTransactions = widget.transactions;
  }

  void _filterTransactions() {
  setState(() {
    filteredTransactions = widget.transactions.where((transaction) {
      final matchesCategory = selectedCategory == 'All' || transaction['category'] == selectedCategory;
      final matchesDate = selectedDate == null || transaction['date'].isSameDay(selectedDate!);
      final matchesSearch = transaction['description'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                            transaction['category'].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCategory && matchesDate && matchesSearch;
    }).toList();
  });
}


  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _filterTransactions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Transactions Summary',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              _buildSearchBar(),
              SizedBox(height: 20.0),
              _buildFilters(),
              SizedBox(height: 20.0),
              _buildTransactionList(),
              SizedBox(height: 20.0),
              _buildSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Search Transactions',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              searchQuery = value;
              _filterTransactions();
            });
          },
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Transactions',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: [
                DropdownMenuItem(value: 'All', child: Text('All')),
                DropdownMenuItem(value: 'Food and Drinks', child: Text('Food and Drinks')),
                DropdownMenuItem(value: 'Shopping', child: Text('Shopping')),
                DropdownMenuItem(value: 'Housing', child: Text('Housing')),
                DropdownMenuItem(value: 'Transportation', child: Text('Transportation')),
                DropdownMenuItem(value: 'Utilities', child: Text('Utilities')),
                DropdownMenuItem(value: 'Groceries', child: Text('Groceries')),
                DropdownMenuItem(value: 'Savings', child: Text('Savings')),
                DropdownMenuItem(value: 'Debts', child: Text('Debts')),
                DropdownMenuItem(value: 'Allowances', child: Text('Allowances')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                  _filterTransactions();
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction List',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            if (filteredTransactions.isNotEmpty)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Description')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Date')),
                  ],
                  rows: filteredTransactions.map((transaction) {
                    return DataRow(cells: [
                      DataCell(Text(transaction['category'])),
                      DataCell(Text(transaction['description'])),
                      DataCell(Text(transaction['amount'].toString())),
                      DataCell(Text(transaction['date'].toString().split(' ')[0])),
                    ]);
                  }).toList(),
                ),
              ),
            if (filteredTransactions.isEmpty)
              Text('No transactions found.', style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    double totalExpenses = filteredTransactions.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });

    double remainingBudget = widget.monthlyBudget - totalExpenses;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Total Expenses: ₱${totalExpenses.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Remaining Budget: ₱${remainingBudget.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: widget.monthlyBudget > 0 ? totalExpenses / widget.monthlyBudget : 0.0,
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(
                totalExpenses <= widget.monthlyBudget ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 8.0),
            if (remainingBudget < 0)
              Text(
                'You have exceeded your budget!',
                style: TextStyle(fontSize: 16.0, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
