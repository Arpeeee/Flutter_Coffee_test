import 'dart:async';
import 'dart:ffi';
import 'dart:math';

class PrincePoint {
  final double x;
  final double y;

  PrincePoint({required this.x, required this.y})
}

class RandomListManager {
  List<Float> randomList = [];
  Timer? timer;

  void startAddingData() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (randomList.length < 100) {
        randomList.add(Random().nextInt(100));
        print('List length: ${randomList.length}');
      } else {
        stopAddingData();
        print('List complete');
      }
    });
  }

  void stopAddingData() {
    timer?.cancel();
  }
}