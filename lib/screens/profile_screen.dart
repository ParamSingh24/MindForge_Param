import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../services/tts_service.dart';
import '../services/ai_logic_engine.dart';
import '../services/pdf_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TtsService _ttsService = TtsService();
  bool _isDemoRunning = false;

  void _runDemoMode() async {
    setState(() => _isDemoRunning = true);

    // 1. Show simulated scanning overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLowest,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: AppTheme.primary),
            const SizedBox(height: 24),
            Text(
              "Scanning receipt...",
              style: Theme.of(context).textTheme.labelLarge,
            )
          ],
        ),
      ),
    );

    // 2. Wait 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    // 3. Pop Dialog
    if (mounted) {
      Navigator.of(context).pop();
    }

    // 4. Inject specific fake data designed to trigger the "Food overbudget" warning
    final fakeExpense = Expense(
      amount: 4500.0,
      category: 'Food',
      vendor: 'Gourmet Cafe',
      date: DateTime.now(),
    );

    if (mounted) {
      final provider = context.read<ExpenseProvider>();
      final settings = context.read<SettingsProvider>();
      
      await provider.addExpense(fakeExpense);
      
      double categoryTotal = provider.categoryBreakdown['Food'] ?? 0.0;
      
      String suggestion = BudgetStrategist.generateLocalSuggestion(
        fakeExpense.amount,
        fakeExpense.category,
        categoryTotal,
        isHindi: settings.isHindi,
      );

      // 5. Automatically trigger Audio & SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Demo Scan Complete. Insight running..."),
          backgroundColor: AppTheme.secondary,
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      await _ttsService.speak(suggestion, isHindi: settings.isHindi);
    }

    if (mounted) {
      setState(() => _isDemoRunning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            // Settings Card
            Card(
              child: ListTile(
                title: Text("Hindi Language", style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text("Voice & insights output language", style: Theme.of(context).textTheme.bodySmall),
                trailing: Switch(
                  value: settings.isHindi,
                  activeColor: AppTheme.primary,
                  onChanged: (val) {
                    settings.toggleLanguage();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // PDF Export Option (Placeholder for Task 7)
            Card(
              child: ListTile(
                title: Text("Export PDF Report", style: Theme.of(context).textTheme.bodyLarge),
                leading: const Icon(Icons.picture_as_pdf, color: AppTheme.primary),
                onTap: () {
                   final provider = context.read<ExpenseProvider>();
                   PdfService.generateAndPrintReport(provider.expenses, provider.totalExpenses);
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Demo Mode Section (Critical Requirement)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Presentation Tools", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    "Showcase the offline AI analytics safely.",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.outlineVariant),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isDemoRunning ? null : _runDemoMode,
                      style: ElevatedButton.styleFrom(
                         backgroundColor: AppTheme.onSurface,
                         foregroundColor: AppTheme.surface,
                      ),
                      child: const Text("Try Sample Receipt"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
