import 'package:flutter_test/flutter_test.dart';
import 'package:toy_flutter/unit_test/counter.dart';

void main() {
  group('Counter', () {
    test('0으로 시작해야 한다', () {
      expect(Counter().value, 0);
    });

    test('1씩 증가되야한다', () {
      final counter = Counter();
      counter.countUp();
      expect(counter.value, 1);
    });
  });
}
