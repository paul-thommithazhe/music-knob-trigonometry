import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_knob/widgets/imageknob.dart';
import 'package:music_knob/widgets/volumeBarindicator.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: ImageKnobWithVolume()),
    ),
  ));
}


// image knob for increasing the volume
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

