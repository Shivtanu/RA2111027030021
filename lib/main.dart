import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(AverageCalculatorApp());
}

class AverageCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Average Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AverageCalculatorPage(),
    );
  }
}

class AverageCalculatorPage extends StatefulWidget {
  @override
  _AverageCalculatorPageState createState() => _AverageCalculatorPageState();
}

class _AverageCalculatorPageState extends State<AverageCalculatorPage> {
  List<int> windowPrevState = [];
  List<int> windowCurrState = [];
  double average = 0.0;

  Future<void> _calculateAverage() async {
    final response =
        await http.get(Uri.parse('http://20.244.56.144/test/primes'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        windowPrevState = data['windowPrevState'].cast<int>();
        windowCurrState = data['windowCurrState'].cast<int>();
        average = data['avg'];
      });
    } else {
      // Handle error
      print('Failed to fetch average: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Average Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _calculateAverage,
              child: Text('Calculate Average'),
            ),
            SizedBox(height: 20),
            Text(
              'Previous Window State: $windowPrevState',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Current Window State: $windowCurrState',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Average: ${average.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
