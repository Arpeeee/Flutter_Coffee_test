import 'package:flutter/material.dart';

import 'animated_line_chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Line Chart',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Animated Line Chart'),
        ),
        body: Center(
          child: AnimatedLineChart(),
        ),
      ),
    );
  }
}
