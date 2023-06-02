import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
var format = DateFormat.yMMMMd();

enum Category {
  food,
  others,
  work,
  travel,
}

const iconBasedOnCategory = {
  Category.food: Icons.food_bank_rounded,
  Category.others: Icons.devices_other_rounded,
  Category.travel: Icons.travel_explore_rounded,
  Category.work: Icons.work_history_rounded,
};

class Expense {
  final String id;
  final String name;
  final double amount;
  final DateTime time;
  final Category category;

  String get formattedTime {
    return format.format(time);
  }

  Expense({
    required this.name,
    required this.amount,
    required this.time,
    required this.category,
  }) : id = uuid.v4(); // assigns random ID
}

class ExpenseBucket {
  final Category category;
  final List<Expense> expenses;

  ExpenseBucket({required this.category, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
      : expenses = allExpense
            .where((element) => element.category == category)
            .toList();

  double get totalExpense {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
