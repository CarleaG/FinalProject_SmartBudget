// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  final List<Map<String, dynamic>> expenses;

  Graph({required this.expenses});

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String hoveredCategory = '';
  double hoveredAmount = 0.0;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> categoryAmounts = _calculateCategoryAmounts(widget.expenses);
    final currencyFormatter = NumberFormat.currency(locale: 'en_PH', symbol: '₱');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FadeTransition(
                    opacity: _animation,
                    child: PieChart(
                      PieChartData(
                        sections: _getPieChartSections(categoryAmounts, currencyFormatter),
                        centerSpaceRadius: 40.0,
                        sectionsSpace: 2,
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                hoveredCategory = '';
                                hoveredAmount = 0.0;
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              final touchedSection = pieTouchResponse.touchedSection!.touchedSection;
                              hoveredCategory = touchedSection?.title ?? '';
                              hoveredAmount = touchedSection?.value ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              hoveredCategory.isEmpty ? '' : 'Category: $hoveredCategory\nTotal: ${currencyFormatter.format(hoveredAmount)}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            _buildLegend(categoryAmounts),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections(Map<String, double> categoryAmounts, NumberFormat currencyFormatter) {
    return categoryAmounts.keys.map((category) {
      final isTouched = categoryAmounts.keys.toList().indexOf(category) == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: _getColorForCategory(category),
        value: categoryAmounts[category] ?? 0.0,
        title: category,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
        badgeWidget: Text(
          currencyFormatter.format(categoryAmounts[category]),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        badgePositionPercentageOffset: 1.2,
      );
    }).toList();
  }

  Map<String, double> _calculateCategoryAmounts(List<Map<String, dynamic>> expenses) {
    Map<String, double> categoryAmounts = {};

    expenses.forEach((expense) {
      String category = expense['category'];
      double amount = expense['amount'] ?? 0.0;

      categoryAmounts[category] = (categoryAmounts[category] ?? 0.0) + amount;
    });

    return categoryAmounts;
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Food and Drinks':
        return Colors.blueAccent;
      case 'Shopping':
        return Colors.orangeAccent;
      case 'Housing':
        return Colors.greenAccent;
      case 'Transportation':
        return Colors.redAccent;
      case 'Utilities':
        return Colors.purpleAccent;
      case 'Groceries':
        return Colors.yellowAccent;
      case 'Savings':
        return Colors.tealAccent;
      case 'Debts':
        return Colors.brown;
      case 'Allowances':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Widget _buildLegend(Map<String, double> categoryAmounts) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: categoryAmounts.keys.map((category) {
            return Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: _getColorForCategory(category),
                ),
                SizedBox(width: 8),
                Text(
                  category,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
