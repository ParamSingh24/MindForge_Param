import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../theme/app_theme.dart';
import '../providers/expense_provider.dart';
import '../providers/settings_provider.dart';
import '../services/ai_logic_engine.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenses = context.watch<ExpenseProvider>().expenses;
    final totalExpense = context.watch<ExpenseProvider>().totalExpenses;
    final user = FirebaseAuth.instance.currentUser;
    final firstName = user?.displayName?.split(' ').first ?? 'there';

    // Hardcoded Budget vs Spent for UI aesthetic from the reference
    final double budgeted = 3500.0;
    final double savings = 565.0;
    final double debts = 597.0;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Top Purple Background Graphic
                Container(
                  height: 140,
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
                      const SizedBox(height: 12),
                      Text("Rs. ${(budgeted - totalExpense).toStringAsFixed(0)}", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: AppTheme.surfaceContainerLowest)),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // AI Suggestions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                     children: [
                       const Icon(Icons.psychology, color: AppTheme.primary),
                       const SizedBox(width: 8),
                       Text("AI Budget Assistant", style: Theme.of(context).textTheme.headlineSmall),
                     ],
                   ),
                   const SizedBox(height: 16),
                   if (expenses.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text("Scan your first receipt to generate AI insights!"),
                      )
                   else
                     ...context.watch<ExpenseProvider>().categoryBreakdown.entries.map((e) {
                         // Only show suggestion if spend > 0 to keep it relevant
                         if (e.value <= 0) return const SizedBox.shrink();
                         String insight = BudgetStrategist.generateLocalSuggestion(
                           0, e.key, e.value, isHindi: context.read<SettingsProvider>().isHindi
                         );
                         return Container(
                           margin: const EdgeInsets.only(bottom: 12),
                           padding: const EdgeInsets.all(16),
                           decoration: BoxDecoration(
                             color: AppTheme.primaryContainer.withOpacity(0.3),
                             borderRadius: BorderRadius.circular(16),
                             border: Border.all(color: AppTheme.primary.withOpacity(0.2)),
                           ),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               const Icon(Icons.tips_and_updates, color: AppTheme.primary, size: 20),
                               const SizedBox(width: 12),
                               Expanded(child: Text(insight, style: Theme.of(context).textTheme.bodyMedium)),
                             ],
                           ),
                         );
                     }),
                   const SizedBox(height: 24),
                   const SizedBox(height: 24),
                   // Price Comparison section
                   Row(
                     children: [
                       const Icon(Icons.shopping_bag_outlined, color: AppTheme.primary),
                       const SizedBox(width: 8),
                       Text("Smart Deal Finder", style: Theme.of(context).textTheme.headlineSmall),
                     ],
                   ),
                   const SizedBox(height: 4),
                   Text("Motorola Moto Edge 60 Stylus 256GB", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppTheme.outlineVariant)),
                   const SizedBox(height: 16),
                   SizedBox(
                     height: 140, // fixed height for horizontal cards
                     child: ListView(
                       scrollDirection: Axis.horizontal,
                       children: [
                         _buildPriceCard(context, "GadgetsNow", "₹23,999", false, "High Price", "https://shop.gadgetsnow.com/smartphones/motorola-moto-edge-60-stylus-5g-256-gb-pantone-gibraltar-sea-8-gb-ram-/10021/p_G629847?utm_source=google&utm_medium=cpc&srsltid=AfmBOoruGI9pQN1HkokzmEmG2rvGpIJ0KqIzpW3pnnfkzEP8LPGrX207GbM"),
                         _buildPriceCard(context, "Amazon", "₹20,700", false, "Average", "https://www.amazon.in/Motorola-Edge-Stylus-256GB-Storage/dp/B0F5Y84NWS?source=ps-sl-shoppingads-lpcontext&ref_=fplfs&psc=1&smid=ADQBS37PIWWH6"),
                         _buildPriceCard(context, "JioMart", "₹19,999", true, "Lowest! Buy Here", "https://www.jiomart.com/p/electronics/moto-edge-60-stylus-256-gb-8-gb-ram-pantone-gibraltar-sea-mobile-phone/611322221?source=shoppingads"),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   // Upcoming Bills section
                   Row(
                     children: [
                       Text("Upcoming Utilities", style: Theme.of(context).textTheme.headlineSmall),
                     ],
                   ),
                   const SizedBox(height: 16),
                   SizedBox(
                     height: 120, // fixed height for horizontal cards
                     child: ListView(
                       scrollDirection: Axis.horizontal,
                       children: [
                         _buildUtilityCard(context, "Electricity Bill", "CESC Limited", "₹1,450", Icons.electric_bolt, Colors.orange),
                         _buildUtilityCard(context, "Water Bill", "Municipal Corp", "₹340", Icons.water_drop, AppTheme.secondary),
                         _buildUtilityCard(context, "LPG Gas", "Bharat Gas", "₹900", Icons.local_fire_department, const Color(0xFFE57373)),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   
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

  Widget _buildUtilityCard(BuildContext context, String title, String vendor, String amount, IconData icon, Color iconColor) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
        border: Border.all(color: AppTheme.outlineVariant.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold), maxLines: 1),
          Text(vendor, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppTheme.outlineVariant), maxLines: 1),
          const SizedBox(height: 4),
          Text(amount, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.primary)),
        ],
      ),
    );
  }
  Widget _buildPriceCard(BuildContext context, String platform, String price, bool isLowest, String label, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLowest ? AppTheme.primaryContainer.withOpacity(0.5) : AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
        border: Border.all(color: isLowest ? AppTheme.primary : AppTheme.outlineVariant.withOpacity(0.2), width: isLowest ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(platform, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1)),
              if (isLowest)
               const Icon(Icons.check_circle, color: AppTheme.primary, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          Text(price, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: isLowest ? AppTheme.primary : AppTheme.onSurface, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isLowest ? AppTheme.primary : AppTheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isLowest ? AppTheme.onPrimary : AppTheme.outlineVariant)),
          ),
        ],
      ),
    ));
  }
}

