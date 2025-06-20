import 'package:flutter/material.dart';
import 'dart:math';
import './widget/train_from_right_widget.dart';
import './widget/train_from_left_widget.dart';

class TrainTestApp extends StatelessWidget {
  const TrainTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: PsychometricTestParent(),
        ),
      ),
    );
  }
}

class PsychometricTestParent extends StatefulWidget {
  const PsychometricTestParent({super.key});

  @override
  State<PsychometricTestParent> createState() => _PsychometricTestParentState();
}

class _PsychometricTestParentState extends State<PsychometricTestParent> {

  final random = Random();
  bool showNextBtn = false, showDoneBtn = false;
  int currentRound = 0;
  final List<int> scores = [];

  void _onRoundComplete(int score) async {
    if (scores.length < 9) {
      setState(() {
        scores.add(score);
        showNextBtn = true;
      });
    } else if (scores.length == 9) {
      setState(() {
        scores.add(score);
        showNextBtn = false;
        showDoneBtn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // game screen
          if (!showDoneBtn) ...[
            Expanded(
              child: currentRound % 2 == 0
                  ? TrainFromRightWidget(onScore: _onRoundComplete)
                  : TrainFromLeftWidget(onScore: _onRoundComplete),
            ),
            const SizedBox(height: 16),
          ],

          // points and buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [

                // points
                Expanded(
                  child: Text(
                    'Points Scored: ${scores.join(" , ")}',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),

                // next btn
                if (showNextBtn) ...[
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showNextBtn = false;
                        setState(() => currentRound++);
                      });
                    },
                    child: const Text("Next Round"),
                  ),
                ],

                // done btn
                if (showDoneBtn) ...[
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () =>  Navigator.of(context, rootNavigator: true).pop(),
                    child: const Text("Done"),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
