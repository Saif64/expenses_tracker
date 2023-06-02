import 'package:flutter/material.dart';
import 'package:personal_expenses/model/expenses_model.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              expense.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                Text('${expense.amount.toStringAsFixed(2)} BDT'),
                const Spacer(),
                Row(
                  children: [
                    Icon(iconBasedOnCategory[expense.category]),
                    const SizedBox(width: 10),
                    Text(
                      expense.formattedTime,
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
