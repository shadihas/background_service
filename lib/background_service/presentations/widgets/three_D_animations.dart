
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'dart:math' show pi;

class ThreeDAnimation extends StatefulWidget {
  const ThreeDAnimation({super.key});

  @override
  State<ThreeDAnimation> createState() => _ThreeDAnimationState();
}

class _ThreeDAnimationState extends State<ThreeDAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;
  double dimention = 100.0;
  @override
  void initState() {
    _xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _animation = Tween<double>(begin: 0, end: pi * 2);

    super.initState();
  }

  @override
  Widget build(BuildContext context) { 
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: dimention,
              ),
              AnimatedBuilder(
                  animation: Listenable.merge([
                    _xController,
                    _yController,
                    _zController,
                  ]),
                  builder: (context, child) => Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..rotateX(_animation.evaluate(_xController))
                          ..rotateY(_animation.evaluate(_yController))
                          ..rotateZ(_animation.evaluate(_zController)),
                        child: Stack(
                          children: [
                            //back
                            Transform(
                              transform: Matrix4.identity()
                                ..translate(Vector3(0, 0, dimention)),
                              child: Container(
                                color: Colors.red,
                                height: dimention,
                                width: dimention,
                              ),
                            ),
                            //right side

                            Transform(
                              alignment: Alignment.centerRight,
                              transform: Matrix4.identity()..rotateY(pi / 2),
                              child: Container(
                                color: Colors.blue,
                                height: dimention,
                                width: dimention,
                              ),
                            ),

                            // left side

                            Transform(
                              alignment: Alignment.centerLeft,
                              transform: Matrix4.identity()..rotateY(-(pi / 2)),
                              child: Container(
                                color: Colors.yellow,
                                height: dimention,
                                width: dimention,
                              ),
                            ),
                            // top
                            Transform(
                              alignment: Alignment.topCenter,
                              transform: Matrix4.identity()..rotateX((pi / 2)),
                              child: Container(
                                color: Colors.pink,
                                height: dimention,
                                width: dimention,
                              ),
                            ),

                            // bottom
                            Transform(
                              alignment: Alignment.bottomCenter,
                              transform: Matrix4.identity()..rotateX(-(pi / 2)),
                              child: Container(
                                color: Colors.black26,
                                height: dimention,
                                width: dimention,
                              ),
                            ),
                            //front
                            Container(
                              color: Colors.green,
                              height: dimention,
                              width: dimention,
                            )
                          ],
                        ),
                      ))
            ],
          ),
        ),
      ),
    );
  }
} 

