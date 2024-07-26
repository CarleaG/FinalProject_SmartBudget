// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';

class ExpenseState with ChangeNotifier {
  double _monthlyBudget = 0.0;
  List<Map<String, dynamic>> _expenses = [];
  Map<String, double> _categoryBudgets = {};
  bool _isDarkMode = false;

  double get monthlyBudget => _monthlyBudget;
  List<Map<String, dynamic>> get expenses => _expenses;
  Map<String, double> get categoryBudgets => _categoryBudgets;
  bool get isDarkMode => _isDarkMode;

  List<String> categories = [
    'Food and Drinks',
    'Shopping',
    'Housing',
    'Transportation',
    'Utilities',
    'Groceries',
    'Savings',
    'Debts',
    'Allowances',
  ];

  void setMonthlyBudget(double budget) {
    _monthlyBudget = budget;
    notifyListeners();
  }

  void setCategoryBudget(String category, double budget) {
    if (budget >= 0) {
      _categoryBudgets[category] = budget;
      notifyListeners();
    }
  }

  double getCategoryBudget(String category) {
    return _categoryBudgets[category] ?? 0.0;
  }

  void addExpense(Map<String, dynamic> expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  double getTotalExpensesByCategory(String category) {
    return _expenses.fold(0.0, (sum, item) {
      return sum + (item['category'] == category ? item['amount'] : 0.0);
    });
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
