import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: ImageKnobWithVolume()),
    ),
  ));
}

class ImageKnobWithVolume extends StatefulWidget {
  const ImageKnobWithVolume({super.key});

  @override
  State<ImageKnobWithVolume> createState() => _ImageKnobWithVolumeState();
}

class _ImageKnobWithVolumeState extends State<ImageKnobWithVolume> {
  double value = 0.0;

  void onChanged(double newValue) {
    setState(() {
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageKnob(
          onChanged: onChanged,
        ),
        const SizedBox(height: 20),
        VolumeBarMeter(level: value),
      ],
    );
  }
}

class ImageKnob extends StatefulWidget {
  final ValueChanged<double> onChanged;

  const ImageKnob({super.key, required this.onChanged});

  @override
  State<ImageKnob> createState() => _ImageKnobState();
}

class _ImageKnobState extends State<ImageKnob> {
  static const double minAngle = 135 * pi / 180;
  static const double maxAngle = 360 * pi / 180;
  static const double sweep = maxAngle - minAngle;

  double angle = minAngle;
  double value = 0.0;

  void _handleDrag(Offset localPos, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;
    double newAngle = atan2(dy, dx);
    if (newAngle < 0) newAngle += 2 * pi;

    if (newAngle >= minAngle && newAngle <= maxAngle ) {
      setState(() {
        angle = newAngle;
        value = ((newAngle - minAngle) / sweep).clamp(0.0, 1.0);
        if (value > 0.98) value = 1.0;
        widget.onChanged(value); // 🔁 Notify parent
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPos = renderBox.globalToLocal(details.globalPosition);
        _handleDrag(localPos, renderBox.size);
      },
      child: Transform.rotate(
        angle: angle,
        child: Image.asset(
          'assets/music_knob.png', // 👈 ensure this image exists
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}

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
