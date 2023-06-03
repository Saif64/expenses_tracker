import 'package:flutter/material.dart';
import 'package:personal_expenses/model/expenses_model.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard(this.expense, {super.key});

  final Expense expense;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  bool isPressedIcon = false;

  void addToFav() {
    setState(() {
      isPressedIcon = !isPressedIcon;
    });
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.expense.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                    onPressed: addToFav,
                    icon: isPressedIcon == true
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border))
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('${widget.expense.amount.toStringAsFixed(2)} BDT'),
                const Spacer(),
                Row(
                  children: [
                    Icon(iconBasedOnCategory[widget.expense.category]),
                    const SizedBox(width: 10),
                    Text(
                      widget.expense.formattedTime,
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
