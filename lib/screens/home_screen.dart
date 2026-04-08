import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final totalExpense = context.watch<ExpenseProvider>().totalExpenses;

    // Hardcoded Budget vs Spent for UI aesthetic from the reference
    final double budgeted = 3500.0;
    final double savings = 565.0;
    final double debts = 597.0;

    return Scaffold(
      // The scaffold itself is covered by the MainScreen's color logic,
      // but we paint a purple top half here.
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Top Purple Background Graphic
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                ),
                
                // Content Layer
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text("₹${(budgeted - totalExpense).toStringAsFixed(0)}", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.surfaceContainerLowest)),
                      Text("Funds available to budget", style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.primaryContainer)),
                      
                      const SizedBox(height: 32),
                      
                      // Savings and Debts Row 
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.trending_up, color: AppTheme.secondary, size: 16),
                                      const SizedBox(width: 8),
                                      Text("Saving", style: Theme.of(context).textTheme.labelMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("₹${savings.toStringAsFixed(0)}", style: Theme.of(context).textTheme.headlineMedium),
                                  Text("+10% From last month", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.secondary)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.trending_down, color: Color(0xFFE57373), size: 16),
                                      const SizedBox(width: 8),
                                      Text("Debts", style: Theme.of(context).textTheme.labelMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("₹${debts.toStringAsFixed(0)}", style: Theme.of(context).textTheme.headlineMedium),
                                  Text("-0.2% From last month", style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outlineVariant)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Budget Overview Progress
                      Text("Budget overview", style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Budgeted", style: Theme.of(context).textTheme.labelSmall),
                                    Text("₹${budgeted.toStringAsFixed(0)}", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.primary)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Spent", style: Theme.of(context).textTheme.labelSmall),
                                    Text("₹${totalExpense.toStringAsFixed(0)}", style: Theme.of(context).textTheme.labelLarge),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Left", style: Theme.of(context).textTheme.labelSmall),
                                    Text("₹${(budgeted - totalExpense).toStringAsFixed(0)}", style: Theme.of(context).textTheme.labelLarge),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            LinearProgressIndicator(
                              value: (totalExpense / budgeted).clamp(0.0, 1.0),
                              backgroundColor: AppTheme.surfaceContainerLow,
                              color: totalExpense > budgeted ? const Color(0xFFE57373) : AppTheme.primary,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.check_circle, color: AppTheme.secondary, size: 14),
                                const SizedBox(width: 8),
                                Text(
                                  totalExpense > budgeted ? "You are over budget!" : "You are on track!",
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: totalExpense > budgeted ? const Color(0xFFE57373) : AppTheme.secondary
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Latest transactions", style: Theme.of(context).textTheme.headlineSmall),
                          Text("Show all >", style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Latest Transactions List
          expenses.isEmpty
          ? SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text("Click '+' to scan.", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppTheme.outlineVariant)),
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final ex = expenses[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
                    child: Card(
                      color: AppTheme.surfaceContainerLowest,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.surfaceContainerLow,
                          child: Icon(Icons.receipt_long, color: AppTheme.primary, size: 20),
                        ),
                        title: Text(ex.vendor, style: Theme.of(context).textTheme.labelLarge),
                        subtitle: Text(ex.category, style: Theme.of(context).textTheme.bodySmall),
                        trailing: Text(
                          "-₹${ex.amount.toStringAsFixed(2)}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                  );
                },
                childCount: expenses.length,
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)), // Space for FAB
        ],
      ),
    );
  }
}
