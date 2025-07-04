import 'package:flutter/material.dart';

class VolumeBarMeter extends StatelessWidget {
  final double level;

  const VolumeBarMeter({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(220, 40),
      painter: _MeterBarPainter(level: level),
    );
  }
}

class _MeterBarPainter extends CustomPainter {
  final double level;

  _MeterBarPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    const int barCount = 20;
    const double spacing = 4.0;

    final double barWidth = (size.width - (barCount - 1) * spacing) / barCount;
    final double maxBarHeight = size.height;

    final int filledBars = (barCount * level).round();

    for (int i = 0; i < barCount; i++) {
      final double x = i * (barWidth + spacing);
      final double barHeight = maxBarHeight;

      final Paint paint = Paint()
        ..color = i < filledBars ? Colors.green : Colors.grey.shade700
        ..style = PaintingStyle.fill;

      final rect = Rect.fromLTWH(
        x,
        size.height - barHeight,
        barWidth,
        barHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(2)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MeterBarPainter oldDelegate) {
    return oldDelegate.level != level;
  }
}
