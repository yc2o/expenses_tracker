import 'dart:math';

import 'package:expenses_tracker/helpers/database_helper.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditExpense extends StatefulWidget {
  final Transaction transaction;

  const EditExpense({super.key, required this.transaction});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  late String _transactionType;
  late String _name;
  late TransactionCategory _selectedCategory;
  late double _amount;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _transactionType = widget.transaction.type == 'Expense' ? 'Pengeluaran' : 'Pemasukan';
    _name = widget.transaction.name;
    _selectedCategory = widget.transaction.category;
    _amount = widget.transaction.amount;
    _selectedDate = widget.transaction.date;
    _amountController.text = _currencyFormatter.format(_amount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == -1) {
      return 'Kemarin';
    } else if (difference < -1 && difference >= -7) {
      return '${-difference} hari lalu';
    } else if (difference == 1) {
      return 'Besok';
    } else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }

  void _updateTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal maksimal adalah hari ini')),
        );
        return;
      }
    }

    if (_formKey.currentState!.validate()) {
      final updatedTransaction = Transaction(
        id: widget.transaction.id,
        name: _name,
        category: _selectedCategory,
        type: _transactionType == 'Pengeluaran' ? 'Expense' : 'Income',
        amount: _amount,
        date: _selectedDate,
      );
      await DatabaseHelper.instance.updateTransaction(updatedTransaction);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil diperbarui')),
      );
      Navigator.pop(context, true);
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.food:
        return Icons.fastfood;
      case TransactionCategory.home:
        return Icons.home;
      case TransactionCategory.pet:
        return Icons.pets;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.tech:
        return Icons.devices;
      case TransactionCategory.travel:
        return Icons.flight;
      case TransactionCategory.other:
        return Icons.category;
    }
  }

  Color _getCategoryColor(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.entertainment:
        return Colors.purple;
      case TransactionCategory.food:
        return Colors.orange;
      case TransactionCategory.home:
        return Colors.blue;
      case TransactionCategory.pet:
        return Colors.brown;
      case TransactionCategory.shopping:
        return Colors.green;
      case TransactionCategory.tech:
        return Colors.grey;
      case TransactionCategory.travel:
        return Colors.teal;
      case TransactionCategory.other:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Transaksi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(28),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    ),
                    onChanged: (value) {
                      String unformattedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                      setState(() {
                        _amount = double.tryParse(unformattedValue) ?? 0.0;
                        _amountController.value = TextEditingValue(
                          text: _currencyFormatter.format(_amount),
                          selection: TextSelection.collapsed(offset: _currencyFormatter.format(_amount).length),
                        );
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    value: _transactionType,
                    items: const [
                      DropdownMenuItem(
                        value: 'Pengeluaran',
                        child: Text('Pengeluaran'),
                      ),
                      DropdownMenuItem(
                        value: 'Pemasukan',
                        child: Text('Pemasukan'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                      labelText: 'Jenis Transaksi',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: _name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                      labelText: 'Nama',
                    ),
                    onChanged: (value) {
                      _name = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      border: Border.all(color: Colors.transparent),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              getFormattedDate(_selectedDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => _pickDate(context),
                            child: Text(
                              'Pilih Tanggal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = LinearGradient(
                                    colors: [
                                      Theme.of(context).colorScheme.primary,
                                      Theme.of(context).colorScheme.secondary,
                                      Theme.of(context).colorScheme.tertiary,
                                    ],
                                  ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              ),  
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<TransactionCategory>(
                    value: _selectedCategory,
                    items: TransactionCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              color: _getCategoryColor(category),
                            ),
                            const SizedBox(width: 8),
                            Text(category.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                      labelText: 'Kategori',
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        transform: const GradientRotation(pi / 4),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _updateTransaction,
                        borderRadius: BorderRadius.circular(12),
                        child: const Center(
                          child: Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }
}