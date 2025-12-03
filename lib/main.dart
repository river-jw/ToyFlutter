import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toy_flutter/Bloc/bloc_counter_screen.dart';
import 'package:toy_flutter/GetX/get_screen.dart';
import 'package:toy_flutter/bluetooth_bloc/bt_status_screen.dart';
import 'package:toy_flutter/ca/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:toy_flutter/ca/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:toy_flutter/ca/injection.dart' as di;
import 'package:toy_flutter/code_canvas.dart';
import 'package:toy_flutter/custom_ui/_donut_chart.dart';
import 'package:toy_flutter/custom_ui/donut_chart.dart';
import 'package:toy_flutter/custom_widget/radar_widget.dart';
import 'package:toy_flutter/flutter_grammar/operator.dart';
import 'package:toy_flutter/flutter_grammar/stream_example_screen.dart';
import 'package:toy_flutter/grammar/mixin/manager.dart';

import 'async/future_ex.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initDependencies();
  runApp(MaterialApp(
    home: ReusableDonutChart(
      data: [
        ChartData(label: 'A', value: 10, color: Colors.red),
        ChartData(label: 'B', value: 20, color: Colors.blue),
        ChartData(label: 'C', value: 15, color: Colors.green),
        ChartData(label: 'D', value: 5, color: Colors.orange),
        // ... 원하는 만큼
      ],
      centerTitle: '총 50건',
    ),
  ));
/*  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('레이더 애니메이션 예제')),
        body: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: RadarWidget(
              radarColor: Colors.green.shade200,
              sweepColor: Colors.green.withOpacity(0.5),
              sweepSize: 60,
              sweepSpeed: 3,
            ),
          ),
        ),
      ),
    ),
  );*/
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => NumberTriviaBloc(di.sl()),
        child: StreamExampleScreen(),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color.withOpacity(0.7),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${count}건',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class AccidentStatsWidget extends StatelessWidget {
  final int emergency; // 긴급
  final int warning; // 주의
  final int normal; // 일반

  const AccidentStatsWidget({
    Key? key,
    required this.emergency,
    required this.warning,
    required this.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final total = emergency + warning + normal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 야차사고',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),
          // 도넛 차트
          Center(
            child: SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: DonutChartPainter(
                      emergency: emergency,
                      warning: warning,
                      normal: normal,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '총 ${total}건',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const Text(
                        '24시간',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // 통계 카드들
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.warning_amber_rounded,
                  label: '긴급',
                  count: emergency,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.error_outline,
                  label: '주의',
                  count: warning,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  icon: Icons.shield_outlined,
                  label: '일반',
                  count: normal,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


// 동적으로 변하는 예시
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  int emergency = 2;
  int warning = 4;
  int normal = 3;

  void _updateStats() {
    setState(() {
      // 랜덤하게 값 변경 (테스트용)
      emergency = math.Random().nextInt(10);
      warning = math.Random().nextInt(10);
      normal = math.Random().nextInt(10);
    });
  }

  void _incrementEmergency() {
    setState(() {
      emergency++;
    });
  }

  void _incrementWarning() {
    setState(() {
      warning++;
    });
  }

  void _incrementNormal() {
    setState(() {
      normal++;
    });
  }

  void _reset() {
    setState(() {
      emergency = 0;
      warning = 0;
      normal = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('야차사고 대시보드'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 동적으로 변하는 차트
            AccidentStatsWidget(
              emergency: emergency,
              warning: warning,
              normal: normal,
            ),
            const SizedBox(height: 24),
            // 컨트롤 버튼들
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _incrementEmergency,
                  icon: const Icon(Icons.add),
                  label: const Text('긴급 +1'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementWarning,
                  icon: const Icon(Icons.add),
                  label: const Text('주의 +1'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _incrementNormal,
                  icon: const Icon(Icons.add),
                  label: const Text('일반 +1'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _updateStats,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('랜덤 변경'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('초기화'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
