import 'dart:math';
import 'package:expenses_tracker/helpers/database_helper.dart';
import 'package:expenses_tracker/models/transaction.dart' as custom;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final transactions = await DatabaseHelper.instance.fetchTransactions();
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in transactions) {
      if (transaction.type == 'Income') {
        totalIncome += transaction.amount;
      } else if (transaction.type == 'Expense') {
        totalExpense += transaction.amount;
      }
    }

    return {
      'transactions': transactions,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'totalBalance': totalIncome - totalExpense,
    };
  }

  IconData _getCategoryIcon(custom.TransactionCategory category) {
    switch (category) {
      case custom.TransactionCategory.entertainment:
        return Icons.movie;
      case custom.TransactionCategory.food:
        return Icons.fastfood;
      case custom.TransactionCategory.home:
        return Icons.home;
      case custom.TransactionCategory.pet:
        return Icons.pets;
      case custom.TransactionCategory.shopping:
        return Icons.shopping_bag;
      case custom.TransactionCategory.tech:
        return Icons.devices;
      case custom.TransactionCategory.travel:
        return Icons.flight;
      case custom.TransactionCategory.other:
        return Icons.category;
    }
  }

  Color _getCategoryColor(custom.TransactionCategory category) {
    switch (category) {
      case custom.TransactionCategory.entertainment:
        return Colors.purple;
      case custom.TransactionCategory.food:
        return Colors.orange;
      case custom.TransactionCategory.home:
        return Colors.blue;
      case custom.TransactionCategory.pet:
        return Colors.brown;
      case custom.TransactionCategory.shopping:
        return Colors.green;
      case custom.TransactionCategory.tech:
        return Colors.grey;
      case custom.TransactionCategory.travel:
        return Colors.teal;
      case custom.TransactionCategory.other:
        return Colors.black;
    }
  }

  void refreshData() {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Hari ini';
    } else if (difference == -1) {
      return 'Besok';
    } else if (difference == 1) {
      return 'Kemarin';
    } else if (difference > 1 && difference <= 7) {
      return '$difference hari lalu';
    } else if (difference < -1 && difference >= -7) {
      return '${-difference} hari lagi';
    } else {
      return DateFormat('dd-MM-yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available'));
            }

            final data = snapshot.data!;
            final transactions = data['transactions'] as List<custom.Transaction>;
            final totalIncome = data['totalIncome'] as double;
            final totalExpense = data['totalExpense'] as double;
            final totalBalance = data['totalBalance'] as double;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                            ),
                            const Icon(Icons.person, size: 30),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Halo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Browsky!',
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
                              ],
                            ),
                            const Text(
                              'Aplikasi Expense Tracker',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Yeremia Christian Candra Octaviano - 3123600034',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                foreground: Paint()
                                ..shader = LinearGradient(
                                  colors: [
                                    Theme.of(context).colorScheme.primary,
                                    Theme.of(context).colorScheme.secondary,
                                    Theme.of(context).colorScheme.tertiary,
                                  ],
                                ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                              )
                            )
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.secondary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                      transform: const GradientRotation(pi / 4),
                    ),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey.shade300,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Jumlah Saldo',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${currencyFormatter.format(totalBalance)},-',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Pemasukan',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currencyFormatter.format(totalIncome)},-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Pengeluaran',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currencyFormatter.format(totalExpense)},-',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaksimu',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Column(
                        children: [
                          Dismissible(
                            key: Key(transaction.id.toString()),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Transaksi berhasil dihapus')),
                                  );
                                }
                                await DatabaseHelper.instance.deleteTransaction(transaction.id!);
                                refreshData();
                                return true;
                              }
                              return false;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: _getCategoryColor(transaction.category),
                                          child: Icon(
                                            _getCategoryIcon(transaction.category),
                                            color: _getCategoryColor(transaction.category).computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          transaction.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${transaction.type == 'Income' ? '+ ' : '- '}${currencyFormatter.format(transaction.amount)}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: transaction.type == 'Income' ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        const SizedBox(height: 2),
                                        Text(
                                          getFormattedDate(transaction.date),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}