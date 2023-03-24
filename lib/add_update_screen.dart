import 'package:flutter/material.dart';
import 'package:todo_app/home_screen.dart';
import 'db_handler.dart';
import 'model.dart';
import 'package:intl/intl.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoID;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;
  AddUpdateTask(
      {this.todoDT, this.todoDesc, this.todoID, this.todoTitle, this.update});

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;
  final _fromKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    datalist = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: widget.todoTitle);
    final descController = TextEditingController(text: widget.todoDesc);
    String appTitle;
    if (widget.update == true) {
      appTitle = "Update Task";
    } else {
      appTitle = "Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appTitle,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Form(
              key: _fromKey,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Note Title",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter some Text";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 5,
                    controller: descController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write notes here",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter some Text";
                      }
                      return null;
                    },
                  ),
                ),
              ]),
            ),
            SizedBox(height: 40),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        if (_fromKey.currentState!.validate()) {
                          if (widget.update == true) {
                            dbHelper!.update(TodoModel(
                              id: widget.todoID,
                              title: titleController.text,
                              desc: descController.text,
                              dateandtime: widget.todoDT,
                            ));
                          } else {
                            dbHelper!.insert(TodoModel(
                                title: titleController.text,
                                desc: descController.text,
                                dateandtime: DateFormat('yMd')
                                    .add_jm()
                                    .format(DateTime.now())
                                    .toString()));
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homescreen()));
                          titleController.clear();
                          descController.clear();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                            // boxShadow: [BoxShadow(
                            //   color: Colors.black12,blurRadius: 5, spreadRadius: 1,
                            // )]
                            ),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: BoxDecoration(
                            // boxShadow: [BoxShadow(
                            //   color: Colors.black12,blurRadius: 5, spreadRadius: 1,
                            // )]
                            ),
                        child: Text(
                          "Clear",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
