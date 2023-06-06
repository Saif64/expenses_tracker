import 'package:flutter/material.dart';
import 'package:personal_expenses/components/chart.dart';
import 'package:personal_expenses/components/expenses_list.dart';
import 'package:personal_expenses/components/modal_input.dart';

import 'model/expenses_model.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      name: 'Iphone 14 pro Max',
      amount: 150000,
      time: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      name: 'Rent',
      amount: 25000,
      time: DateTime.now(),
      category: Category.others,
    ),
  ];

  void _openModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => ModalInput(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) {
    setState(() => _registeredExpenses.add(expense));
  }

  void _removeExpense(Expense expense) {
    final removedIndex = _registeredExpenses.indexOf(expense);
    setState(() => _registeredExpenses.remove(expense));

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${expense.name}'),
        action: SnackBarAction(
          label: 'undo',
          onPressed: () => setState(() {
            _registeredExpenses.insert(removedIndex, expense);
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayWidth = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text(
        'No Item added yet',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expense: _registeredExpenses,
        onRemoveCard: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.money_off_rounded),
              Text(
                'Trackify',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )),
      body: displayWidth < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpenses),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpenses)),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openModalSheet,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
