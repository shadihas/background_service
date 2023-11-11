import 'package:background_car/background_service/logic/counter_handler.dart';
import 'package:background_car/background_service/logic/cubit/background_service_cubit.dart';
import 'package:background_car/background_service/presentations/screens/background_counter_screen.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

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

