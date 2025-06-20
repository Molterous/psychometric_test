import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/assets.dart';

class DirectionalTrainWidget extends StatefulWidget {
  final bool isFromRight;
  final double tunnelX;
  final Function(int) onScore;

  const DirectionalTrainWidget({
    super.key,
    required this.isFromRight,
    required this.tunnelX,
    required this.onScore,
  });

  @override
  State<DirectionalTrainWidget> createState() => _DirectionalTrainWidgetState();
}

class _DirectionalTrainWidgetState extends State<DirectionalTrainWidget>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late double speed;

  double trainX       = 0;
  double tunnelWidth  = 300;
  bool isStopped      = false;
  double screenWidth  = 900;

  DateTime? lastTick;
  ui.Image? trainImage;

  @override
  void initState() {
    super.initState();
    _loadTrainImage();

    speed = (Random().nextDouble() * (200)) + 250;
    trainX = widget.isFromRight ? screenWidth : -130;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(() {
      final now = DateTime.now();
      if (lastTick != null && !isStopped && trainImage != null) {
        final elapsedMs = now.difference(lastTick!).inMilliseconds;
        double delta = speed * elapsedMs / 1000;
        setState(() {
          trainX += widget.isFromRight ? -delta : delta;

          if ((widget.isFromRight && trainX < -130) ||
              (!widget.isFromRight && trainX > screenWidth)) {
            trainX = widget.isFromRight ? screenWidth : -130;
          }
        });
      }
      lastTick = now;
    });

    lastTick = DateTime.now();
    _controller.forward();
  }

  Future<void> _loadTrainImage() async {
    final byteData = await rootBundle.load(Assets.trainImg);
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
        _controller.stop();
        widget.onScore(_getPoints());
      });
    }
  }

  int _getPoints() {
    double distance = (trainX - widget.tunnelX);
    distance -= widget.isFromRight ? 0 : 170; // train width

    distance *= widget.isFromRight ? 1 : -1;

    if (distance < 0) {
      if (distance > -10) return -1;
      if (distance > -30) return -2;
      if (distance > -50) return -3;
      if (distance > -70) return -4;
      if (distance > -90) return -5;
      if (distance > -110) return -6;
      if (distance > -130) return -7;
      if (distance > -160) return -8;
      if (distance > -200) return -9;
      return -10;
    }

    if (distance < 10) return 10;
    if (distance < 30) return 9;
    if (distance < 50) return 8;
    if (distance < 70) return 7;
    if (distance < 90) return 6;
    if (distance < 110) return 5;
    if (distance < 130) return 4;
    if (distance < 160) return 3;
    if (distance < 200) return 2;
    return 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _stopTrain,
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (event) {
          if (event.isKeyPressed(LogicalKeyboardKey.space)) {
            _stopTrain();
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
                  tunnelX: widget.tunnelX,
                  tunnelWidth: tunnelWidth,
                  trainImage: trainImage!,
                  showTopTunnel: !isStopped,
                  isFromRight: widget.isFromRight,
                ),
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
  final bool isFromRight;

  TrainPainter({
    required this.trainX,
    required this.tunnelX,
    required this.tunnelWidth,
    required this.trainImage,
    required this.showTopTunnel,
    required this.isFromRight,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final tunnelPaint = Paint()..color = Colors.grey.withOpacity(0.8)..style = PaintingStyle.stroke..strokeWidth = 2;;
    final topTunnelPaint = Paint()..color = Colors.grey;

    // Bottom Tunnel
    // Create rounded rectangle (RRect) for tunnel
    final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tunnelX, size.height / 2 - 60, tunnelWidth, 80),
      const Radius.circular(20),
    );
    canvas.drawRRect(rrect, tunnelPaint);

    canvas.save();
    if (!isFromRight) {
      canvas.translate(trainX + 130 / 2, 0);
      canvas.scale(-1, 1);
      canvas.translate(-trainX - 130 / 2, 0);
    }

    // train image
    final trainRect = Rect.fromLTWH(trainX, size.height / 2 - 40, 130, 80);
    paintImage(
      canvas: canvas,
      rect: trainRect,
      image: trainImage,
      fit: BoxFit.contain,
    );

    canvas.restore();

    // top tunnel
    if (showTopTunnel) {
      final topRrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(tunnelX + (isFromRight ? 0 : 20), size.height / 2 - 60, tunnelWidth - 20, 80),
        const Radius.circular(20),
      );
      canvas.drawRRect(topRrect, topTunnelPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
