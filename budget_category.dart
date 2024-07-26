// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class SelectBudgetCategoryWidget extends StatefulWidget {
  final String selectedCategory;
  final List<String> categories;
  final Function(String?) onChanged;

  SelectBudgetCategoryWidget({
    required this.selectedCategory,
    required this.categories,
    required this.onChanged,
  });

  @override
  _SelectBudgetCategoryWidgetState createState() => _SelectBudgetCategoryWidgetState();
}

class _SelectBudgetCategoryWidgetState extends State<SelectBudgetCategoryWidget> {
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _categories = List.from(widget.categories);
  }

  void _addNewCategory(String newCategory) {
    setState(() {
      _categories.add(newCategory);
    });
    widget.onChanged(newCategory);
  }

  @override
  Widget build(BuildContext context) {
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
              'Select Budget Category',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            DropdownButtonFormField<String>(
              value: widget.selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () => _showAddCategoryDialog(context),
              child: Text('Add New Category', style: TextStyle(color: Colors.white)),
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

  void _showAddCategoryDialog(BuildContext context) {
    final _newCategoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newCategoryController.text.isNotEmpty) {
                  _addNewCategory(_newCategoryController.text);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
            ),
          ],
        );
      },
    );
  }
}
