import 'dart:convert';

import 'package:http/http.dart' as http;
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
  List<Expense> _registeredExpenses = [];

  var expenseName;
  var expenseAmount;
  var expenseTime;
  var expenseCategory;
  final url = Uri.https(
      'tododevhub-default-rtdb.asia-southeast1.firebasedatabase.app',
      'expense.json');

  void _openModalSheet() {
    showModalBottomSheet(
        context: context,
        builder: (ctx) => ModalInput(
              onAddExpense: _addExpense,
            ));
  }

  void _addExpense(Expense expense) async {
    setState(() => _registeredExpenses.add(expense));
    for (var item in _registeredExpenses) {
      expenseName = item.name;
      expenseAmount = item.amount;
      expenseTime = item.time;
      expenseCategory = item.category.name;
    }

    await http.post(
      url,
      headers: {'Content-Type': 'aplication/json'},
      body: jsonEncode(
        {
          'name': expenseName,
          'amount': expenseAmount,
          'time': expenseTime.toString(),
          'category': expenseCategory,
        },
      ),
    );
    _loadItem();
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
    http.delete(url);
    _loadItem();
  }

  void _loadItem() async {
    final response = await http.get(url);
    // print(response.body);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Expense> listItems = [];

    for (var item in listData.entries) {
      listItems.add(
        Expense(
          name: item.value['name'],
          amount: item.value['amount'],
          time: DateTime.tryParse(item.value['time'])!,
          category: Category.others,
        ),
      );
    }
    setState(() {
      _registeredExpenses = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItem();
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
