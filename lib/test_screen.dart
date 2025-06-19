import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PsychometricTestApp extends StatelessWidget {
  const PsychometricTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: PsychometricTestScreen(),
        ),
      ),
    );
  }
}

class PsychometricTestScreen extends StatefulWidget {
  const PsychometricTestScreen({super.key});

  @override
  State<PsychometricTestScreen> createState() => _PsychometricTestScreenState();
}

class _PsychometricTestScreenState extends State<PsychometricTestScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  double trainX = 0;
  late double speed; // pixels per second
  double tunnelX = 40;
  double tunnelWidth = 300;
  double? stopDistance;
  bool isStopped = false;
  double screenWidth = 900;
  DateTime? lastTick;
  ui.Image? trainImage;

  List<String> _scores = [];

  @override
  void initState() {
    super.initState();

    _loadTrainImage();

    speed = (Random().nextDouble() * (200)) + 250;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(() {
        final now = DateTime.now();
        if (lastTick != null && !isStopped && trainImage != null) {
          final elapsedMs = now.difference(lastTick!).inMilliseconds;
          setState(() {
            trainX -= speed * elapsedMs / 1000;
            if (trainX < -50) {
              speed = (Random().nextDouble() * (150)) + 200;
              trainX = screenWidth;
              stopDistance = null;
              isStopped = false;
            }
          });
        }
        lastTick = now;
      });

    trainX = screenWidth;
    lastTick = DateTime.now();
    _controller.forward();
  }

  Future<void> _loadTrainImage() async {
    final byteData = await rootBundle.load('assets/train_img.jpg');
    final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    setState(() {
      trainImage = frame.image;
    });
  }

  void _stopTrain() {
    if (!isStopped) {
      setState(() {
        isStopped = true;
        stopDistance = (trainX - tunnelX).abs();
      });
    }
  }

  void _resetState() {
    setState(() {
      speed = (Random().nextDouble() * (300)) + 250;
      isStopped = false;
      trainX = screenWidth;
      stopDistance = null;
      lastTick = DateTime.now();
      _controller.reset();
      _controller.forward();
    });
  }

  void _reset() {
    setState(() {
      _scores = [];
      speed = (Random().nextDouble() * (300)) + 250;
      isStopped = false;
      trainX = screenWidth;
      stopDistance = null;
      lastTick = DateTime.now();
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _getPoints() {
    if (trainX < tunnelX) return 0;

    if (trainX > tunnelX && trainX < (screenWidth / 9)) return 10;
    if (trainX > (screenWidth / 9) && trainX < (screenWidth / 8)) return 9;
    if (trainX > (screenWidth / 8) && trainX < (screenWidth / 7)) return 9;
    if (trainX > (screenWidth / 7) && trainX < (screenWidth / 6)) return 8;
    if (trainX > (screenWidth / 6) && trainX < (screenWidth / 5)) return 7;
    if (trainX > (screenWidth / 5) && trainX < (screenWidth / 4)) return 6;
    if (trainX > (screenWidth / 4) && trainX < (screenWidth / 3)) return 5;
    if (trainX > (screenWidth / 3) && trainX < (screenWidth / 2)) return 4;
    if (trainX > (screenWidth / 3) && trainX < (screenWidth / 2)) return 3;
    if (trainX > (screenWidth / 2) && trainX < (screenWidth))
      return 2;
    else
      return 1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _scores.add(_getPoints().toString());
        _stopTrain();
        await Future.delayed(const Duration(seconds: 1));
        if (_scores.length < 10) { _resetState(); }
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) async {
          if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            _scores.add(_getPoints().toString());
            _stopTrain();
            await Future.delayed(const Duration(seconds: 1));
            if (_scores.length < 10) { _resetState(); }
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: trainImage == null
                  ? const Center(child: CircularProgressIndicator())
                  : CustomPaint(
                      painter: TrainPainter(
                        trainX: trainX,
                        tunnelX: tunnelX,
                        tunnelWidth: tunnelWidth,
                        trainImage: trainImage!,
                        showTopTunnel: !isStopped,
                      ),
                    ),
            ),

            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Points Scored: ${_scores.join(" , ")}',
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),

                  if (_scores.length >= 10) ...[
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _reset,
                      child: const Text("Restart"),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainPainter extends CustomPainter {
  final double trainX;
  final double tunnelX;
  final double tunnelWidth;
  final ui.Image trainImage;
  final bool showTopTunnel;

  TrainPainter({
    required this.trainX,
    required this.tunnelX,
    required this.tunnelWidth,
    required this.trainImage,
    required this.showTopTunnel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final tunnelPaint = Paint()..color = Colors.grey.withOpacity(0.8);
    final topTunnelPaint = Paint()..color = Colors.grey;

    // Bottom Tunnel
    canvas.drawRect(
      Rect.fromLTWH(tunnelX, size.height / 2 - 60, tunnelWidth, 80),
      tunnelPaint,
    );

    // Train image
    final trainRect = Rect.fromLTWH(trainX, size.height / 2 - 40, 130, 80);
    paintImage(
      canvas: canvas,
      rect: trainRect,
      image: trainImage,
      fit: BoxFit.contain,
    );

    // Top Tunnel (if visible)
    if (showTopTunnel) {
      canvas.drawRect(
        Rect.fromLTWH(tunnelX, size.height / 2 - 60, tunnelWidth, 80),
        topTunnelPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
