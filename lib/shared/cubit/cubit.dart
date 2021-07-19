import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks.dart';
import 'package:todo_app/modules/done_tasks.dart';
import 'package:todo_app/modules/new_tasks.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBottomBarState());
  }

  Database database;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void creatDatabase() {
    openDatabase('toDo.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
          .then((value) {
        print('Table created');
      }).catchError((error) {
        print('error when creat Table ${error.toString()}');
      });
      print('database Created');
    }, onOpen: (database) {
      getFromDatabase(database);
      print('database open');
    }).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time,status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertToDatabaseState());

        getFromDatabase(database);
      }).catchError((error) {
        print('error when insert New Task ${error.toString()}');
      });
      return null;
    });
  }

  void getFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });

      emit(AppGetFromDatabaseState());
    });
  }

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    @required bool isShown,
    @required IconData icon,
  }) {
    isBottomSheetShown = isShown;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void upDateDatabase({
    @required String status,
    @required int id,
  }) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      getFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void upDeleteDatabase({
    @required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE name = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(AppDeleteFromDatabaseState());
    });
  }
}
