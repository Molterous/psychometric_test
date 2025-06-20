import 'package:flutter/material.dart';
import './directional_train_widget.dart';

class TrainFromLeftWidget extends StatelessWidget {
  final Function(int) onScore;
  const TrainFromLeftWidget({super.key, required this.onScore});

  @override
  Widget build(BuildContext context) {
    return DirectionalTrainWidget(
      isFromRight: false,
      tunnelX: 530, // Adjust based on screen width
      onScore: onScore,
    );
  }
}
