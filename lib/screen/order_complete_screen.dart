import 'package:flutter/material.dart';
import 'dart:async';

class OrderCompleteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to home screen after a delay
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Complete'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Thank you for your order!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Your food will be delivered shortly.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
