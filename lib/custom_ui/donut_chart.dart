// 재사용 가능한 도넛 차트 위젯
import 'dart:math' as math;

import 'package:flutter/material.dart';


// 차트 데이터 모델
class ChartData {
  final String label;
  final int value;
  final Color color;
  final IconData? icon;

  ChartData({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });
}

class ReusableDonutChart extends StatelessWidget {
  final List<ChartData> data;
  final String centerTitle;
  final String? centerSubtitle;
  final double size;
  final double strokeWidth;
  final bool showStats;
  final bool showGap;

  const ReusableDonutChart({
    Key? key,
    required this.data,
    required this.centerTitle,
    this.centerSubtitle,
    this.size = 200,
    this.strokeWidth = 35,
    this.showStats = true,
    this.showGap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = data.fold<int>(0, (sum, item) => sum + item.value);

    return Column(
      children: [
        // 도넛 차트
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: FlexibleDonutChartPainter(
                  data: data,
                  strokeWidth: strokeWidth,
                  showGap: showGap,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    centerTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (centerSubtitle != null)
                    Text(
                      centerSubtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (showStats) ...[
          const SizedBox(height: 20),
          _buildStatsCards(),
        ],
      ],
    );
  }


  Widget _buildStatsCards() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: data.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color: item.color.withOpacity(0.7),
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${item.value}건',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: item.color,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// 유연한 도넛 차트 페인터
class FlexibleDonutChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double strokeWidth;
  final bool showGap;

  FlexibleDonutChartPainter({
    required this.data,
    required this.strokeWidth,
    required this.showGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final total = data.fold<int>(0, (sum, item) => sum + item.value);

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
    final gapAngle = showGap ? 0.02 : 0.0; // 간격 여부

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      if (item.value <= 0) continue;

      final sweepAngle = (item.value / total) * 2 * math.pi -
          (data.length > 1 && showGap ? gapAngle : 0);

      final paint = Paint()
        ..color = item.color
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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}