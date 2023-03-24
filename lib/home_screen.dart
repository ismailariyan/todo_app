import 'package:flutter/material.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/model.dart';
import 'add_update_screen.dart';

class Homescreen extends StatefulWidget {
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;
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
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text(
          "TODO APP",
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
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
          future: datalist,
          builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data!.length == 0) {
              return Center(
                child: Text(
                  "No Task Found",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 122, 122, 122),
                  ),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  int todoID = snapshot.data![index].id!.toInt();
                  String todoTitle = snapshot.data![index].title.toString();
                  String todoDesc = snapshot.data![index].desc.toString();
                  String todoDT = snapshot.data![index].dateandtime.toString();
                  return Dismissible(
                    key: ValueKey<int>(todoID),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      child: Icon(Icons.delete_forever, color: Colors.white),
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        dbHelper!.delete(todoID);
                        datalist = dbHelper!.getDataList();
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade300,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                todoTitle,
                                style: TextStyle(
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              todoDesc,
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.8,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  todoDT,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    AddUpdateTask(
                                      todoID: todoID,
                                      todoDesc: todoDesc,
                                      todoTitle: todoTitle,
                                      update: true,
                                    ),
                                    ));
                                  },
                                  child: Icon(
                                    Icons.edit_note,
                                    color: Colors.green,
                                    size: 28, 
                                    ),
                                ),

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ))
      ]),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (con) => AddUpdateTask()));
          }),
    );
  }
}
