// import 'dart:math' show pi;

import 'package:background_car/background_service/logic/counter_handler.dart';
import 'package:background_car/background_service/presentations/screens/background_counter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:background_car/background_service/logic/cubit/background_service_cubit.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() => runApp(const ExampleApp());

// The callback function should always be a top-level function.
@pragma('vm:entry-point')
void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
   FlutterForegroundTask.setTaskHandler(CounterHandler());
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
          '/': (context) => const BackgroundCounterScreen(),
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
  double? _width= defaultWidth;
  final double _height = defaultHeight;
  bool isZoomedIn = false;
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
                "assets/images/wow.png",fit: BoxFit.fill,
              
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            TextButton(onPressed: () {
              isZoomedIn? _width = defaultWidth:MediaQuery.of(context).size.width ;
              // isZoomedIn? _height = defaultWidth:300;
              isZoomedIn = !isZoomedIn;
              setState(() {
                
              });
            }, child: const Text("zoom in"))
          ],
        ),
      ),
    );
  }
}
