import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'report_screen.dart';
import 'profile_screen.dart';
import '../theme/app_theme.dart';
import '../services/ocr_service.dart';
import '../providers/settings_provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../services/ai_logic_engine.dart';
import '../services/tts_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final OcrService _ocrService = OcrService();
  final TtsService _ttsService = TtsService();
  bool _isProcessing = false;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const ReportScreen(),
    // We add empty placeholders for the right side tabs matching the UI layout
    Container(),
    Container(), 
  ];

  void _globalScanReceipt() async {
    final settings = context.read<SettingsProvider>();
    setState(() => _isProcessing = true);
    
    // Always open the real camera so it looks authentic
    final rawResult = await _ocrService.scanReceipt();
    
    if (rawResult != null) {
      if (settings.isDemoMode) {
        // --- DEMO MODE: Inject 4 Mock Receipts, Ignore OCR ---
        final List<Expense> fakeData = [
          Expense(amount: 1500.0, category: 'Food', vendor: 'Gourmet Cafe', date: DateTime.now().subtract(const Duration(days: 1))),
          Expense(amount: 950.0, category: 'Transport', vendor: 'Uber Ride', date: DateTime.now().subtract(const Duration(days: 2))),
          Expense(amount: 3200.0, category: 'Food', vendor: 'Zomato Delivery', date: DateTime.now()),
          Expense(amount: 400.0, category: 'Shopping', vendor: 'Reliance Fresh', date: DateTime.now().subtract(const Duration(days: 1))),
        ];
        
        final provider = context.read<ExpenseProvider>();
        for (var expense in fakeData) {
           await provider.addExpense(expense, persist: false);
        }
        
        if (mounted) {
          // Calculate the new total for 'Food' to trigger the specific warning
          double foodTotal = provider.categoryBreakdown['Food'] ?? 0.0;
          String suggestion = BudgetStrategist.generateLocalSuggestion(
            fakeData[2].amount, 'Food', foodTotal, isHindi: settings.isHindi
          );
          
          _showAiFeedback(suggestion, settings.isHindi);
        }
      } else {
        // --- REAL MODE ---
        final expense = Expense(
          amount: rawResult['amount'],
          date: rawResult['date'],
          vendor: rawResult['vendor'],
          category: rawResult['category'],
        );

        if (mounted) {
          final provider = context.read<ExpenseProvider>();
          await provider.addExpense(expense);
          
          double catTotal = provider.categoryBreakdown[expense.category] ?? 0.0;
          String suggestion = BudgetStrategist.generateLocalSuggestion(
            expense.amount, expense.category, catTotal, isHindi: settings.isHindi
          );
          _showAiFeedback(suggestion, settings.isHindi);
        }
      }
    }
    
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  void _showAiFeedback(String text, bool isHindi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: AppTheme.secondary,
        duration: const Duration(seconds: 8),
      ),
    );
    _ttsService.speak(text, isHindi: isHindi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Needed for transparent FAB notched bottom bar
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ethereal Ledger", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppTheme.onPrimary)),
            Text("Current budget", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.primaryContainer)),
          ],
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: AppTheme.surfaceContainerLowest,
              child: Icon(Icons.person, color: AppTheme.primary),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          _screens[_currentIndex],
          if (_isProcessing)
             Container(
               color: Colors.black45,
               child: const Center(child: CircularProgressIndicator(color: AppTheme.primary)),
             )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _globalScanReceipt,
        backgroundColor: AppTheme.onSurface,
        child: const Icon(Icons.add, color: AppTheme.surface, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: AppTheme.surfaceContainerLowest,
        elevation: 16,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTabItem(icon: Icons.stacked_line_chart, label: 'Activity', index: 0),
            _buildTabItem(icon: Icons.account_balance_wallet_outlined, label: 'Budget', index: 1),
            const SizedBox(width: 48), // Space for FAB
            _buildTabItem(icon: Icons.receipt_long_outlined, label: 'Transactions', index: 2),
            _buildTabItem(icon: Icons.credit_card_outlined, label: 'Accounts', index: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem({required IconData icon, required String label, required int index}) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? AppTheme.primary : AppTheme.outlineVariant;
    return GestureDetector(
      onTap: () {
        if (index < 2) {
           setState(() => _currentIndex = index);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
