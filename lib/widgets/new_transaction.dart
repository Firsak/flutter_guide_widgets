import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './adaptiveButton.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  NewTransaction(this.addNewTransactionHandler, {Key? key}) : super(key: key);

  final Function addNewTransactionHandler;

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    final enteredTitle = _titleController.text;
    final double? enteredAmount;
    _amountController.text.isEmpty
        ? enteredAmount = -1
        : enteredAmount = double.parse(_amountController.text);

    if (enteredAmount <= 0 || enteredTitle.isEmpty || _selectedDate == null) {
      return;
    }

    widget.addNewTransactionHandler(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
                // onChanged: (value) {
                //   titleInput = value;
                // },
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                // keyboardType: TextInputType.number,
                // onChanged: (value) => amountInput = value,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No date chosen!'
                          : 'Picket date: ${DateFormat.yMd().format(_selectedDate as DateTime)}'),
                    ),
                    AdaptiveButton('Choose date!', _presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _submitData(),
                child: const Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Theme.of(context).textTheme.button?.color,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
