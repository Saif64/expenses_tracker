import 'package:flutter/material.dart';
import 'package:personal_expenses/model/expenses_model.dart';

class ModalInput extends StatefulWidget {
  const ModalInput({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<ModalInput> createState() => _ModalInputState();
}

class _ModalInputState extends State<ModalInput> {
  final _textController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _pickedDate;
  var _selectedCategory = Category.others;

  void _datePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: first,
      lastDate: now,
    );
    setState(() {
      _pickedDate = pickedDate;
    });
  }

  void _onSubmitExpense() {
    final amountGiven = double.tryParse(_amountController.text);
    final isAmountInvalid = amountGiven == null || amountGiven <= 0;

    if (_textController.text.trim().isEmpty ||
        isAmountInvalid ||
        _pickedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: const Text(
                  'Please input the title, amount or date correctly',
                ),
                title: const Text('invalid Input'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Okay'),
                  ),
                ],
              ));
      return;
    }
    widget.onAddExpense(
      Expense(
        name: _textController.text,
        amount: amountGiven,
        time: _pickedDate!,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            maxLength: 50,
            decoration: const InputDecoration(
              icon: Icon(Icons.exit_to_app_rounded),
              label: Text('Name'),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black,
                  style: BorderStyle.solid,
                ),
              ),
            ),
            keyboardType: TextInputType.name,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money_outlined),
                    label: Text('Amount'),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _pickedDate == null
                          ? 'No Selected Date'
                          : format.format(_pickedDate!),
                    ),
                    IconButton(
                        onPressed: _datePicker,
                        icon: const Icon(Icons.calendar_month_rounded))
                  ],
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton(
                padding: const EdgeInsets.symmetric(vertical: 10),
                icon: const Icon(Icons.ads_click_rounded),
                value: _selectedCategory,
                items: Category.values.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text(e.name.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: _onSubmitExpense,
                child: const Text('Save Expense'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
