import 'package:flutter/foundation.dart';
import '../models/expense.dart';
import '../services/database_helper.dart';

class ExpenseProvider with ChangeNotifier {
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  ExpenseProvider() {
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    _expenses = await DatabaseHelper.instance.readAllExpenses();
    notifyListeners();
  }

  Future<void> addExpense(Expense expense) async {
    await DatabaseHelper.instance.create(expense);
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await DatabaseHelper.instance.update(expense);
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    await DatabaseHelper.instance.delete(id);
    await loadExpenses();
  }

  // Analytics Helpers
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  Map<String, double> get categoryBreakdown {
    final Map<String, double> breakdown = {};
    for (var expense in _expenses) {
      if (breakdown.containsKey(expense.category)) {
        breakdown[expense.category] = breakdown[expense.category]! + expense.amount;
      } else {
        breakdown[expense.category] = expense.amount;
      }
    }
    return breakdown;
  }
}
