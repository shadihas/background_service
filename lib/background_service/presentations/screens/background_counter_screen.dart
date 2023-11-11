import 'package:background_car/background_service/logic/cubit/background_service_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_foreground_task/ui/with_foreground_task.dart';

class BackgroundCounterScreen extends StatefulWidget {
  const BackgroundCounterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BackgroundCounterScreenState();
}

class _BackgroundCounterScreenState extends State<BackgroundCounterScreen> {
   BackgroundServiceCubit? backgroundCubit;
  @override
  void initState() {
    super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) async {
      backgroundCubit = BlocProvider.of<BackgroundServiceCubit>(context);
      // await backgroundCubit!.requestPermissionForAndroid();
      backgroundCubit!.initForegroundTask();

      // You can get the previous ReceivePort without restarting the service.
      if (await FlutterForegroundTask.isRunningService) {
        final newReceivePort = FlutterForegroundTask.receivePort;
        backgroundCubit?.registerReceivePort(newReceivePort, context);
       }
     });
   }

  @override
  void dispose() {
    backgroundCubit?.closeReceivePort();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A widget that prevents the app from closing when the foreground service is running.
    // This widget must be declared above the [Scaffold] widget.
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Foreground Task'),
          centerTitle: true,
        ),
        body: _buildContentView(),
      ),
    );
  }

  Widget _buildContentView() {
    buttonBuilder(String text, {VoidCallback? onPressed}) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      );
    }

    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buttonBuilder('start',
              onPressed: ()async=> await backgroundCubit?.startForegroundTask(context)),
          buttonBuilder('stop', onPressed:()=> backgroundCubit?.stopForegroundTask()),
          BlocBuilder<BackgroundServiceCubit, BackgroundServiceState>(
            builder: (context, state) {
              return Text(state.counter.toString());
            },
          ),
        ],
      ),
    );
  }
} 
