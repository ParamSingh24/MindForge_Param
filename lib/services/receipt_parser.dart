class ReceiptParser {
  static final RegExp _amountRegex = RegExp(r'(?:rs|inr|₹|$)?\s*(\d+(?:\.\d{1,2})?)', caseSensitive: false);
  static final RegExp _dateRegex = RegExp(r'(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})');

  static final Map<String, List<String>> _categoryKeywords = {
    'Food': ['restaurant', 'cafe', 'zomato', 'swiggy', 'canteen', 'food', 'hotel'],
    'Transport': ['uber', 'ola', 'petrol', 'diesel', 'taxi', 'auto', 'fuel', 'metro'],
    'Shopping': ['mall', 'store', 'mart', 'supermarket', 'clothing', 'retail'],
    'Bills': ['electricity', 'recharge', 'water', 'bill', 'broadband', 'airtel', 'jio'],
  };

  static Map<String, dynamic> parse(String text) {
    // 1. Amount
    double amount = 0.0;
    final amountMatches = _amountRegex.allMatches(text);
    if (amountMatches.isNotEmpty) {
      // Find the largest number, loosely assuming it's the total.
      for (var match in amountMatches) {
        if (match.groupCount >= 1) {
          final val = double.tryParse(match.group(1) ?? '0');
          if (val != null && val > amount) {
            amount = val;
          }
        }
      }
    }

    // 2. Date
    DateTime date = DateTime.now();
    final dateMatch = _dateRegex.firstMatch(text);
    if (dateMatch != null) {
      try {
        final dateStr = dateMatch.group(0)!.replaceAll('-', '/').replaceAll('.', '/');
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          // Naive DD/MM/YYYY parsing mostly for simple strings
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);
          if (year < 100) year += 2000;
          date = DateTime(year, month, day);
        }
      } catch (e) {
        // fallback to now
      }
    }

    // 3. Vendor
    String vendor = 'Unknown Vendor';
    final lines = text.split('\n');
    if (lines.isNotEmpty) {
      // Usually vendor is the first non-empty line
      vendor = lines.firstWhere((element) => element.trim().isNotEmpty, orElse: () => 'Unknown Vendor').trim();
    }

    // 4. Category
    String category = 'Other';
    final lowerText = text.toLowerCase();
    for (var entry in _categoryKeywords.entries) {
      if (entry.value.any((keyword) => lowerText.contains(keyword))) {
        category = entry.key;
        break;
      }
    }

    return {
      'amount': amount,
      'date': date,
      'vendor': vendor,
      'category': category,
    };
  }
}
