import 'package:flutter/material.dart';
import 'package:personal_expenses/components/expenses_card.dart';
import 'package:personal_expenses/model/expenses_model.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expense, required this.onRemoveCard});

  final List<Expense> expense;
  final void Function(Expense expense) onRemoveCard;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: expense.length,
        itemBuilder: (ctx, idx) {
          return Dismissible(
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: const Color.fromARGB(255, 190, 141, 144),
                margin: Theme.of(context).cardTheme.margin,
                child: const Icon(Icons.delete_forever_rounded),
              ),
              key: ValueKey(expense[idx]),
              onDismissed: (direction) => onRemoveCard(expense[idx]),
              child: ExpenseCard(expense[idx]));
        });
  }
}
