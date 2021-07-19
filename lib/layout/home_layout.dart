import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..creatDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body: ConditionalBuilder(
              condition: true,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    );
                    // insertToDatabase(
                    //   title: titleController.text,
                    //   time: timeController.text,
                    //   date: dateController.text,
                    // ).then((value) {
                    //   getFromDatabase(database).then((value) {
                    //     // setState(() {
                    //     //   Navigator.pop(context);
                    //     //   isBottomSh,

                    //     //   tasks = value;
                    //     //   fabIcon = Icons.edit;
                    //     // });
                    //     print('get data $tasks');
                    //   });
                    // });
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    defaultTextField(
                                      controller: titleController,
                                      label: 'task title',
                                      prefix: Icons.title,
                                      textInputType: TextInputType.text,
                                      onValidate: (String value) {
                                        if (value.isEmpty) {
                                          return 'title must not be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultTextField(
                                      controller: timeController,
                                      label: 'task time',
                                      prefix: Icons.watch_later_outlined,
                                      textInputType: TextInputType.datetime,
                                      onValidate: (String value) {
                                        if (value.isEmpty) {
                                          return 'time must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeController.text =
                                              value.format(context);
                                          print(
                                            value.format(context),
                                          );
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    defaultTextField(
                                      controller: dateController,
                                      label: 'task date',
                                      prefix: Icons.calendar_today,
                                      textInputType: TextInputType.datetime,
                                      onValidate: (String value) {
                                        if (value.isEmpty) {
                                          return 'date must not be empty';
                                        }
                                        return null;
                                      },
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2021-07-04'),
                                        ).then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShown: false, icon: Icons.edit);
                    // isBottomSheetShown = false;
                    // setState(() {
                    //   fabIcon = Icons.edit;
                    // });
                  });
                  cubit.changeBottomSheetState(isShown: true, icon: Icons.add);
                  // isBottomSheetShown = true;
                  // setState(() {
                  //   fabIcon = Icons.add;
                  // });
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
