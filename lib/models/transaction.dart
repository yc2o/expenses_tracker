class Transaction {
  final int? id;
  final String name;
  final String type;
  final double amount;
  final DateTime date;

  Transaction({
    this.id,
    required this.name,
    required this.type,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
    );
  }
}