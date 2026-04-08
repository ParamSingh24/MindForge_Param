import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final breakdown = context.watch<ExpenseProvider>().categoryBreakdown;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.primary,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.onSurface.withOpacity(0.04),
                    blurRadius: 32,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    "Total Spending",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.outlineVariant),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "₹${context.watch<ExpenseProvider>().totalExpenses.toStringAsFixed(2)}",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text("Category Breakdown", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            
            if (breakdown.isEmpty)
              const Center(child: Text("No data available yet."))
            else
              SizedBox(
                height: 250,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 4,
                    centerSpaceRadius: 60,
                    sections: breakdown.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getColorForCategory(entry.key),
                        value: entry.value,
                        title: '',
                        radius: 50,
                      );
                    }).toList(),
                  ),
                ),
              ),
              
            const SizedBox(height: 32),
            ...breakdown.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getColorForCategory(e.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(e.key, style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                  Text("₹${e.value.toStringAsFixed(2)}", style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            )),
            
            const SizedBox(height: 120), // Bottom padding for dock
          ],
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Food': return const Color(0xFFE57373);
      case 'Transport': return const Color(0xFF64B5F6);
      case 'Shopping': return const Color(0xFFFFB74D);
      case 'Bills': return const Color(0xFF81C784);
      default: return AppTheme.primaryContainer;
    }
  }
}
