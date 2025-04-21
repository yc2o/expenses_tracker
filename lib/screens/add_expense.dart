import 'package:expenses_tracker/helpers/database_helper.dart';
import 'package:expenses_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  String _transactionType = 'Pengeluaran';
  String _name = '';
  double _amount = 0.0;
  DateTime? _selectedDate;

  void _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal harus dipilih')),
        );
        return;
      }

      if (_selectedDate!.isAfter(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggal tidak boleh di masa depan')),
        );
        return;
      }

      final transaction = Transaction(
        name: _name,
        type: _transactionType == 'Pengeluaran' ? 'Expense' : 'Income',
        amount: _amount,
        date: _selectedDate!,
      );
      await DatabaseHelper.instance.insertTransaction(transaction);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaksi berhasil ditambahkan')),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _transactionType,
                items: const [
                  DropdownMenuItem(value: 'Pengeluaran', child: Text('Pengeluaran')),
                  DropdownMenuItem(value: 'Pemasukan', child: Text('Pemasukan')),
                ],
                onChanged: (value) {
                  setState(() {
                    _transactionType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nama'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _amount = double.tryParse(value) ?? 0.0;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Pilih Tanggal'
                          : 'Tanggal: ${_selectedDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _pickDate(context),
                    child: const Text('Pilih'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}