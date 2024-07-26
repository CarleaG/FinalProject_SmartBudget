// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class SelectDateWidget extends StatelessWidget {
  final Function(DateTime) onChanged;

  SelectDateWidget({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    return Card(
      color: Colors.deepPurple,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Date',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate) {
                  selectedDate = picked;
                  onChanged(selectedDate);
                }
              },
              child: Text('Choose Date'),
            ),
          ],
        ),
      ),
    );
  }
}
