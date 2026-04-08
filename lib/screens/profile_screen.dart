import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/settings_provider.dart';
import '../providers/expense_provider.dart';
import '../services/pdf_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            // Settings Card - Language
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
            
            // Settings Card - Demo Mode Toggle
            Card(
              child: ListTile(
                title: Text("Demo Mode Engine", style: Theme.of(context).textTheme.bodyLarge),
                subtitle: Text("Mock OCR scan data", style: Theme.of(context).textTheme.bodySmall),
                trailing: Switch(
                  value: settings.isDemoMode,
                  activeColor: AppTheme.secondary,
                  onChanged: (val) {
                    settings.toggleDemoMode();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // PDF Export Action
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
            
            const SizedBox(height: 120), // padding for FAB missing
          ],
        ),
      ),
    );
  }
}
