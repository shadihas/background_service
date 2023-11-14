
import 'package:flutter/material.dart';
import 'dart:math' show pi;

class AnimationExample1 extends StatefulWidget {
  const AnimationExample1({super.key});

  @override
  State<AnimationExample1> createState() => _AnimationExample1State();
}

class _AnimationExample1State extends State<AnimationExample1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(_animation.value),
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 7,
                            spreadRadius: 5,
                            offset: Offset(0, 3))
                      ]),
                ),
              ),
            ),
          ),
          TextButton(
              onPressed: () {
                _controller.repeat();
              },
              child: const Text("rotate"))
        ],
      ),
    );
  }
}
