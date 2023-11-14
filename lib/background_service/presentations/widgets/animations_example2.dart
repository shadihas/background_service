import 'dart:math' show pi;
import 'package:flutter/material.dart';

class AnimationExample2 extends StatefulWidget {
  const AnimationExample2({super.key});

  @override
  State<AnimationExample2> createState() => _AnimationExample2State();
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class _AnimationExample2State extends State<AnimationExample2>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseRotationController;
  late Animation<double> _counterClockwiseRotationAnimation;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  @override
  void initState() {
    _counterClockwiseRotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _counterClockwiseRotationAnimation = Tween<double>(begin: 0, end: -(pi / 2))
        .animate(CurvedAnimation(
            parent: _counterClockwiseRotationController,
            curve: Curves.bounceOut));

    _flipController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
        CurvedAnimation(parent: _flipController, curve: Curves.bounceOut));
    _counterClockwiseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _flipAnimation = Tween<double>(
                begin: _flipAnimation.value, end: _flipAnimation.value + pi)
            .animate(CurvedAnimation(
                parent: _flipController, curve: Curves.bounceOut));
        _flipController
          ..reset()
          ..forward();
      }
    });
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _counterClockwiseRotationAnimation = Tween<double>(
                begin: _counterClockwiseRotationAnimation.value,
                end: _counterClockwiseRotationAnimation.value + -(pi / 2))
            .animate(CurvedAnimation(
                parent: _counterClockwiseRotationController,
                curve: Curves.bounceOut));
        _counterClockwiseRotationController
          ..reset()
          ..forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _counterClockwiseRotationController.dispose();
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _counterClockwiseRotationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    //status listener

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                _counterClockwiseRotationController.stop();
                _flipController.stop();
              },
              child: SizedBox(
                height: 200,
                width: 200,
                child: AnimatedBuilder(
                    animation: _counterClockwiseRotationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateZ(_counterClockwiseRotationAnimation.value),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _flipAnimation,
                              builder: (context, child) => Transform(
                                alignment: Alignment.centerRight,
                                transform: Matrix4.identity()
                                  ..rotateY(_flipAnimation.value),
                                child: ClipPath(
                                  clipper:
                                      HalfCircleClipper(side: CircleSide.left),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.blueAccent,
                                      )),
                                ),
                              ),
                            ),
                            AnimatedBuilder(
                                animation: _flipAnimation,
                                builder: (context, child) {
                                  return Transform(
                                    alignment: Alignment.centerLeft,
                                    transform: Matrix4.identity()
                                      ..rotateY(_flipAnimation.value),
                                    child: ClipPath(
                                      clipper: HalfCircleClipper(
                                          side: CircleSide.right),
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: const BoxDecoration(
                                          color: Colors.yellowAccent,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            TextButton(
                onPressed: () {
                  _counterClockwiseRotationController.reset();
                  _flipController.reset();
                },
                child: const Text("restart animations"))
          ],
        ),
      ),
    );
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  CircleSide side;
  HalfCircleClipper({
    required this.side,
  });
  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);
    return path;
  }
}
