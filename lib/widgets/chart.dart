import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E()
            .format(weekDay)
            .substring(0, 1), // Day of the week (abbreviated)
        'amount': totalSum, // Total amount for the day
      };
    }).reversed.toList(); // Reverse to display starting from current day
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double); // Cast amount to double
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Slightly increased elevation
      margin: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners
      ),
      child: Padding(
        padding: EdgeInsets.all(15), // Increased padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Last 7 Days',
              style: TextStyle(
                fontSize: 20, // Custom font size
                fontWeight: FontWeight.bold, // Custom font weight
                color: Colors.purple, // Custom text color
              ),
            ),
            SizedBox(height: 20), // Spacing between title and chart
            // Inside the Chart widget build method
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: groupedTransactionValues.map((data) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                    data['day'] as String, // Day string
                    data['amount'] as double, // Amount as double
                    totalSpending == 0.0
                        ? 0.0
                        : (data['amount'] as double) /
                            totalSpending, // Percentage
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
