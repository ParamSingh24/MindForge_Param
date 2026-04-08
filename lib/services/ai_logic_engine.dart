import 'dart:math';

class BudgetStrategist {
  static const double monthlyBudget = 10000.0;

  // Calculates a smart tip depending on current totals and the last expense
  static String generateLocalSuggestion(double recentAmount, String category, double totalCategorySpend, {bool isHindi = false}) {
    if (category == 'Food') {
      if (totalCategorySpend > (monthlyBudget * 0.3)) {
        return isHindi 
            ? "नमस्ते परम, मैंने आपके खर्चों की जांच की है। आप खाने पर बहुत खर्च कर रहे हैं। थोड़ा घर का खाना खाएं और 800 रुपये तक बचाएं।"
            : "Hello Param, I have analyzed your receipts. You are overspending on food this month. Try a home-cooked meal tomorrow to save 800 rupees.";
      }
    } else if (category == 'Transport') {
       if (totalCategorySpend > (monthlyBudget * 0.2)) {
         return isHindi
            ? "नमस्ते परम, आवाजाही पर आपका खर्च बढ़ रहा है। अपनी अगली यात्रा के लिए पब्लिक ट्रांसपोर्ट का उपयोग करने पर विचार करें।"
            : "Hello Param, your transport costs are rising. Consider using public transport for your next trip to stabilize the budget.";
       }
    } else if (category == 'Shopping') {
      if (recentAmount > 2000) {
         return isHindi
            ? "यह एक बड़ी खरीदारी थी। इस हफ्ते आगे अनावश्यक खर्च से बचें।"
            : "That was a major purchase. Try to avoid unnecessary spending for the rest of the week.";
      }
    }

    // Default positive tip
    final positiveEnglishTips = [
      "Great job! You are within your daily spending limit.",
      "Your expenses look well-managed.",
      "Keep up the good financial discipline, Param!"
    ];
    
    final positiveHindiTips = [
      "बहुत बढ़िया! आप अपने दैनिक खर्च की सीमा के भीतर हैं।",
      "आपके खर्च अच्छी तरह से प्रबंधित लग रहे हैं।",
      "परम, अद्भुत वित्तीय अनुशासन बनाए रखें!"
    ];

    return isHindi 
        ? positiveHindiTips[Random().nextInt(positiveHindiTips.length)] 
        : positiveEnglishTips[Random().nextInt(positiveEnglishTips.length)];
  }
}
