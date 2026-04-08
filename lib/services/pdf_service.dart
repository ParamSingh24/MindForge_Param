import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../models/expense.dart';

class PdfService {
  static Future<void> generateAndPrintReport(List<Expense> expenses, double totalAmount) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                text: 'Ethereal Ledger - Expense Report',
              ),
              pw.SizedBox(height: 20),
              pw.Text('Total Spend: Rs. ${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: const <List<String>>[
                  <String>['Date', 'Vendor', 'Category', 'Amount'],
                ]..addAll(
                    expenses.map((e) => [
                      "${e.date.day}/${e.date.month}/${e.date.year}",
                      e.vendor,
                      e.category,
                      e.amount.toStringAsFixed(2)
                    ]),
                  ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'expense_report.pdf');
  }
}
