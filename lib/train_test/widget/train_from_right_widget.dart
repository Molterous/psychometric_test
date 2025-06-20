import 'package:flutter/material.dart';
import './directional_train_widget.dart';

class TrainFromRightWidget extends StatelessWidget {
  final Function(int) onScore;
  const TrainFromRightWidget({super.key, required this.onScore});

  @override
  Widget build(BuildContext context) {
    return DirectionalTrainWidget(
      isFromRight: true,
      tunnelX: 40,
      onScore: onScore,
    );
  }
}
