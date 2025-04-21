enum TransactionCategory {
  entertainment,
  food,
  home,
  pet,
  shopping,
  tech,
  travel,
  other,
}

class Transaction {
  final int? id;
  final String name;
  final TransactionCategory category;
  final String type;
  final double amount;
  final DateTime date;

  Transaction({
    this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      category: TransactionCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => TransactionCategory.other,
      ),
      type: map['type'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}