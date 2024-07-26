// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './state.dart'; // Adjust the import based on your file structure

class SetCategoryBudgetWidget extends StatelessWidget {
  final String selectedCategory;
  final TextEditingController controller;
  final Function() onSave;

  SetCategoryBudgetWidget({
    required this.selectedCategory,
    required this.controller,
    required this.onSave,
  });

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
              'Set Budget for $selectedCategory',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Enter budget (PHP)',
                border: OutlineInputBorder(),
                prefixText: '₱ ', // Peso sign
              ),
              onChanged: (value) {
                // Optionally handle changes here
              },
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: () {
                final budget = double.tryParse(controller.text);
                if (budget != null && budget >= 0) {
                  // Update state
                  Provider.of<ExpenseState>(context, listen: false)
                      .setCategoryBudget(selectedCategory, budget);
                  onSave(); // Call the onSave callback if needed
                } else {
                  // Show an error if the budget is invalid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid budget')),
                  );
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.white)),
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
}
