import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedLineChart extends StatefulWidget {
  const AnimatedLineChart({Key? key}) : super(key: key);

  @override
  _AnimatedLineChartState createState() => _AnimatedLineChartState();
}

class _AnimatedLineChartState extends State<AnimatedLineChart>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<double> _dataPoints = [];

  final _random = Random();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });

    _animationController.repeat();

    _generateRandomData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double minX = 0;
    final double maxX = 9;
    final double minY = 0;
    final double maxY = 1;

    final List<double> xLabels = [0, 3, 6, 9];
    final List<double> yLabels = [0, 0.25, 0.5, 0.75, 1];

    return CustomPaint(
      size: Size(size.width, 300),
      painter: LineChartPainter(
        dataPoints: _dataPoints,
        animationValue: _animation.value,
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
        xLabels: xLabels,
        yLabels: yLabels,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _generateRandomData() {
    _dataPoints.clear();
    for (int i = 0; i < 10; i++) {
      _dataPoints.add(_random.nextDouble());
    }
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final double animationValue;

  final double minX;
  final double maxX;
  final double minY;
  final double maxY;

  final List<double> xLabels;
  final List<double> yLabels;

  final Paint linePaint = Paint()
    ..color = Color.fromARGB(255, 233, 41, 41)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;

  final Paint gridPaint = Paint()
    ..color = Color.fromARGB(255, 19, 3, 3)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 7;

  final Paint labelPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill
    ..strokeWidth = 1;

  LineChartPainter({
    required this.dataPoints,
    required this.animationValue,
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
    required this.xLabels,
    required this.yLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final dataCount = dataPoints.length;

    final path = Path();
    path.moveTo(0, height);
    for (int i = 0; i < dataCount; i++) {
      final x = i * width / (dataCount - 1);
      final y = height * (1 - dataPoints[i]) * animationValue;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      dataPoints != oldDelegate.dataPoints ||
      animationValue != oldDelegate.animationValue;
}
