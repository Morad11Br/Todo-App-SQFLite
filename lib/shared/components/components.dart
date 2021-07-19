import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultTextField({
  @required TextEditingController controller,
  @required String label,
  @required IconData prefix,
  @required TextInputType textInputType,
  @required Function onValidate,
  Function onChanged,
  Function onSabmitted,
  IconData suffix,
  Function onTap,
  bool isclickabel = true,
}) {
  return TextFormField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      prefix: Icon(prefix),
      suffix: Icon(suffix),
    ),
    enabled: isclickabel,
    controller: controller,
    keyboardType: textInputType,
    onFieldSubmitted: onSabmitted,
    onChanged: onChanged,
    validator: onValidate,
    onTap: onTap,
  );
}

Widget taskItem(Map model, context) {
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      AppCubit.get(context).upDeleteDatabase(id: model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['title']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
          IconButton(
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            ),
            onPressed: () {
              AppCubit.get(context)
                  .upDateDatabase(status: 'done', id: model['id']);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.archive,
              color: Colors.black26,
            ),
            onPressed: () {
              AppCubit.get(context)
                  .upDateDatabase(status: 'Archived', id: model['id']);
            },
          ),
        ],
      ),
    ),
  );
}
