abstract class CounterState {}

class InitialState extends CounterState {}

class ChangeMinusState extends CounterState {
  final int counter;
  ChangeMinusState(this.counter);
}

class ChangePlusState extends CounterState {
  final int counter;
  ChangePlusState(this.counter);
}
