import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/counter/cubit/cubit.dart';
import 'package:todo_app/counter/cubit/states.dart';

class Counter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state is ChangeMinusState) print('Munis ${state.counter}');
          if (state is ChangePlusState) print('Plus ${state.counter}');
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Counter'),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      CounterCubit.get(context).counterMinus();
                    },
                    child: Text(
                      'MINUS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '${CounterCubit.get(context).counter}',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      CounterCubit.get(context).counterPlus();
                    },
                    child: Text(
                      'PLUS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
