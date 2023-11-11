part of 'background_service_cubit.dart'; 
class BackgroundServiceState extends Equatable {
  int counter;
   BackgroundServiceState({
    required this.counter
  });

  @override
  List<Object> get props => [counter];
}