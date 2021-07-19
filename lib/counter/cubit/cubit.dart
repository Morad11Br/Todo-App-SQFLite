import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/counter/cubit/states.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(InitialState());

  static CounterCubit get(context) => BlocProvider.of(context);

  int counter = 1;

  void counterMinus() {
    counter--;
    emit(ChangeMinusState(counter));
  }

  void counterPlus() {
    counter++;
    emit(ChangePlusState(counter));
  }
}
