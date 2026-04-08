import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _tabIndex = 0; // 0 for Categories, 1 for Nature/Time

  @override
  Widget build(BuildContext context) {
    final breakdown = context.watch<ExpenseProvider>().categoryBreakdown;
    final totalExpense = context.watch<ExpenseProvider>().totalExpenses;
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Spending trends", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18, color: AppTheme.onSurface)),
            Text("Aug 1 - Aug 22, 2023", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outlineVariant)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            // Toggle Switch
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tabIndex = 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tabIndex == 0 ? AppTheme.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: _tabIndex == 0 ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                        ),
                        child: Center(child: Text("Categories", style: Theme.of(context).textTheme.labelMedium)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _tabIndex == 1 ? AppTheme.surfaceContainerLowest : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: _tabIndex == 1 ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                        ),
                        child: Center(child: Text("Nature", style: Theme.of(context).textTheme.labelMedium)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            if (breakdown.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text("No Data Available"),
              ))
            else ...[
              // Modern Donut Chart
              SizedBox(
                height: 250,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 70,
                        startDegreeOffset: -90,
                        sections: breakdown.entries.map((entry) {
                           final double perc = (entry.value / totalExpense) * 100;
                           return PieChartSectionData(
                             color: _getColorForCategory(entry.key),
                             value: entry.value,
                             title: "${perc.toStringAsFixed(0)}%",
                             radius: 35,
                             titleStyle: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.surfaceContainerLowest, fontWeight: FontWeight.bold),
                           );
                        }).toList(),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("₹${totalExpense.toStringAsFixed(0)}", style: Theme.of(context).textTheme.headlineMedium),
                          Text("Total", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outlineVariant)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Category Progress Bars
              Align(
                alignment: Alignment.centerLeft,
                child: Text("All categories", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.outlineVariant)),
              ),
              const SizedBox(height: 16),
              
              ...breakdown.entries.map((e) {
                final perc = (e.value / totalExpense);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${(perc*100).toStringAsFixed(0)}%  ${e.key}", style: Theme.of(context).textTheme.labelMedium),
                          const Icon(Icons.edit, size: 14, color: AppTheme.outlineVariant),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: perc,
                        backgroundColor: AppTheme.surfaceContainerLow,
                        color: _getColorForCategory(e.key),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text("Spent ₹${e.value.toStringAsFixed(0)}", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outlineVariant)),
                    ],
                  ),
                );
              }),
            ],
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
      case 'Bills': return const Color(0xFFba68c8);
      default: return AppTheme.primary;
    }
  }
}
