import 'dart:math' as math;

import 'package:flutter/material.dart';

class DonutChartPainter extends CustomPainter {
  final int emergency;
  final int warning;
  final int normal;

  DonutChartPainter({
    required this.emergency,
    required this.warning,
    required this.normal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 35.0; // 두께 증가

    final total = emergency + warning + normal;

    if (total == 0) {
      // 데이터가 없을 때 회색 원 표시
      final paint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    double startAngle = -math.pi / 2; // 12시 방향부터 시작
    final gapAngle = 0.02; // 각 섹션 사이의 작은 간격

    // 긴급 (빨강)
    if (emergency > 0) {
      final sweepAngle = (emergency / total) * 2 * math.pi - (total > 1 ? gapAngle : 0);
      final paint = Paint()
        ..color = const Color(0xFFFF5252) // 밝은 빨강
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + gapAngle;
    }

    // 주의 (주황)
    if (warning > 0) {
      final sweepAngle = (warning / total) * 2 * math.pi - (total > 1 ? gapAngle : 0);
      final paint = Paint()
        ..color = const Color(0xFFFFB74D) // 밝은 주황
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + gapAngle;
    }

    // 일반 (파랑)
    if (normal > 0) {
      final sweepAngle = (normal / total) * 2 * math.pi - (total > 1 ? gapAngle : 0);
      final paint = Paint()
        ..color = const Color(0xFF42A5F5) // 밝은 파랑
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
