// import 'dart:math' show pi;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:background_car/background_service/logic/cubit/background_service_cubit.dart';
import 'dart:math' as math;
import 'dart:math' show pi, cos, sin;
// import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() => runApp(const ExampleApp());

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  // FlutterForegroundTask.setTaskHandler(CounterHandler());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackgroundServiceCubit(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const CustomPainterAnimation(),
        },
      ),
    );
  }
}

class ImplicitAnimations extends StatefulWidget {
  const ImplicitAnimations({super.key});

  @override
  State<ImplicitAnimations> createState() => _ImplicitAnimationsState();
}

const defaultWidth = 100.0;
const defaultHeight = 60.0;

class _ImplicitAnimationsState extends State<ImplicitAnimations> {
  double? _width = defaultWidth;
  String _textButton = "Zoom in";
  bool isZoomIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              // height: _height,
              width: _width,
              duration: const Duration(seconds: 1),
              curve: Curves.bounceInOut,
              child: Image.asset(
                "assets/images/wow.png",
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    isZoomIn = !isZoomIn;
                    _width = isZoomIn
                        ? MediaQuery.of(context).size.width
                        : defaultWidth;
                    _textButton = isZoomIn ? "Zoom out" : "Zoom in";
                  });
                },
                child: Text(_textButton))
          ],
        ),
      ),
    );
  }
}

class CustomClipperExample extends StatefulWidget {
  const CustomClipperExample({super.key});

  @override
  State<CustomClipperExample> createState() => _CustomClipperExampleState();
}

class CircularClipper extends CustomClipper<Path> {
  const CircularClipper();
  @override
  Path getClip(Size size) {
    Path path = Path();
    final rec = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);
    path.addOval(rec);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Color getRandowmColor() =>
    Color(0xFF000000 + math.Random().nextInt(0x00FFFFFF));

class _CustomClipperExampleState extends State<CustomClipperExample> {
  var _color = getRandowmColor();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: CircularClipper(),
          child: TweenAnimationBuilder(
            duration: Duration(seconds: 1),
            tween: ColorTween(begin: getRandowmColor(), end: _color),
            onEnd: () => setState(() {
              _color = getRandowmColor();
            }),
            builder: (context, Color? color, child) => Container(
              color: color,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                "Captain Car",
                style: TextStyle(fontSize: 20, color: Colors.black),
              )),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPainterAnimation extends StatefulWidget {
  const CustomPainterAnimation({super.key});

  @override
  State<CustomPainterAnimation> createState() => _CustomPainterAnimationState();
}

class Polygons extends CustomPainter {
  int sides;
  Polygons({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final angle = (pi * 2) / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

    path.moveTo(center.dx + radius * cos(0), center.dy + radius * sin(0));

    for (var angle in angles) {
      path.lineTo(
          center.dx + radius * cos(angle), center.dy + radius * sin(angle));
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is Polygons && oldDelegate.sides != sides;
  }
}

class _CustomPainterAnimationState extends State<CustomPainterAnimation>
    with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;
  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    _radiusController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _radiusAnimation = Tween<double>(
      begin: 20.0,
      end: 400.0,
    ).chain(CurveTween(curve: Curves.bounceInOut)).animate(_radiusController);

    _sidesController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _sidesAnimation = IntTween(begin: 3, end: 8).animate(_sidesController);
    _rotationController =
        AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotationController);

    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _radiusController..reset()..forward();
          _rotationController..reset()..forward();
          _sidesController..reset()..forward();
        },
        child: Center(
          child: AnimatedBuilder(
              animation: Listenable.merge([_sidesController, _radiusController]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                   transform: Matrix4.identity()..rotateX(_rotationAnimation.value)..rotateY(_rotationAnimation.value)..rotateZ(_rotationAnimation.value),
                  child: CustomPaint(
                    painter: Polygons(sides: _sidesAnimation.value),
                    child: SizedBox(
                      width: _radiusAnimation.value,
                      height: _radiusAnimation.value,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
