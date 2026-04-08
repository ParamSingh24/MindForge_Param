class Expense {
  final int? id;
  final double amount;
  final String category;
  final String vendor;
  final DateTime date;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.vendor,
    required this.date,
  });

  // Convert an Expense into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'vendor': vendor,
      'date': date.toIso8601String(),
    };
  }

  // Extract an Expense object from a Map.
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      vendor: map['vendor'],
      date: DateTime.parse(map['date']),
    );
  }
}
