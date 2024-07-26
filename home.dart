// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, unnecessary_to_list_in_spreads, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './set_budget.dart';
import './budget_category.dart';
import './expense_details.dart';
import './state.dart';

class Home extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onTransactionsChanged;
  final Function(double) onBudgetChanged;

  Home({required this.onTransactionsChanged, required this.onBudgetChanged});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedCategory = 'Food and Drinks';
  TextEditingController expenseDescriptionController = TextEditingController();
  TextEditingController expenseAmountController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final expenseState = Provider.of<ExpenseState>(context);
    double setMonthlyBudget = expenseState.monthlyBudget;
    double totalBudgetAllocated = expenseState.categoryBudgets.values.fold(0, (sum, budget) => sum + budget);

    double budgetProgress = setMonthlyBudget > 0
        ? totalBudgetAllocated / setMonthlyBudget
        : 0.0;

    List<Map<String, dynamic>> expenses = expenseState.expenses;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Budget Management',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // Select Date
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.deepPurple,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Date:',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                        SizedBox(height: 8.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          child: Text(
                            "${selectedDate.toLocal()}".split(' ')[0],
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                // Set Monthly Budget
                SetMonthlyBudgetWidget(
                  budget: setMonthlyBudget,
                  onChanged: (value) {
                    setMonthlyBudget = double.tryParse(value) ?? 0.0;
                    widget.onBudgetChanged(setMonthlyBudget);
                    expenseState.setMonthlyBudget(setMonthlyBudget);
                  },
                  onSave: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Monthly budget saved!')),
                    );
                  },
                ),
                SizedBox(height: 20.0),

                // Progress Indicator
                LinearProgressIndicator(
                  value: budgetProgress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.deepPurple,
                  minHeight: 20.0,
                ),
                SizedBox(height: 8.0),
                Text(
                  'Total Budget Allocated: ₱${totalBudgetAllocated.toStringAsFixed(2)} / ₱${setMonthlyBudget.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 20.0),

                // Select Budget Category
                SelectBudgetCategoryWidget(
                  selectedCategory: selectedCategory,
                  categories: expenseState.categories,
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                SizedBox(height: 20.0),

                // Set Budget for Category
                SetCategoryBudgetWidget(
                  selectedCategory: selectedCategory,
                  onSave: (categoryBudget) {
                    double newTotal = totalBudgetAllocated - expenseState.getCategoryBudget(selectedCategory) + categoryBudget;
                    if (categoryBudget > 0 && newTotal <= setMonthlyBudget) {
                      expenseState.setCategoryBudget(selectedCategory, categoryBudget);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Category budget saved!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Total budget for all categories must not exceed the total monthly budget.')),
                      );
                    }
                  },
                ),
                SizedBox(height: 20.0),

                // Expense Details
                ExpenseDetailsWidget(
                  descriptionController: expenseDescriptionController,
                  amountController: expenseAmountController,
                  onAddExpense: () {
                    double amount = double.tryParse(expenseAmountController.text) ?? 0.0;
                    double currentCategoryExpense = expenseState.getTotalExpensesByCategory(selectedCategory);
                    double categoryBudget = expenseState.getCategoryBudget(selectedCategory);
                    
                    if (amount > 0 && (currentCategoryExpense + amount) <= categoryBudget) {
                      Map<String, dynamic> newExpense = {
                        'category': selectedCategory,
                        'description': expenseDescriptionController.text,
                        'amount': amount,
                        'date': selectedDate,
                      };

                      expenseState.addExpense(newExpense);
                      expenseDescriptionController.clear();
                      expenseAmountController.clear();
                      widget.onTransactionsChanged(expenseState.expenses);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Expense amount exceeds allocated budget for category.')),
                      );
                    }
                  },
                ),
                SizedBox(height: 20.0),

                // Expense List
                _buildExpenseList(expenses),

                // Budget Legend
                SizedBox(height: 20.0),
                Text(
                  'Budget Categories:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8.0),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ...expenseState.categoryBudgets.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(entry.key),
                                Text('₱${entry.value.toStringAsFixed(2)}'),
                              ],
                            ),
                          );
                        }).toList(),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Budget for All Categories',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₱${totalBudgetAllocated.toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseList(List<Map<String, dynamic>> expenses) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expenses',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                ],
                rows: expenses.map((expense) {
                  return DataRow(cells: [
                    DataCell(Text(expense['category'])),
                    DataCell(Text(expense['description'])),
                    DataCell(Text('₱${expense['amount'].toString()}')),
                    DataCell(Text(expense['date'].toString().split(' ')[0])),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
