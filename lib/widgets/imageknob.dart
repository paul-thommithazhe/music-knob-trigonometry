import 'dart:math';

import 'package:flutter/material.dart';

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

