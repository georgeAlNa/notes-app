import 'package:flutter/material.dart';
import 'package:notes_app/editnote.dart';
import 'package:notes_app/sqflite.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Sqflite dbObj = Sqflite();

  bool isLoading = true;
  List notes = [];

  Future readData() async {
    // readData("SELECT * FROM 'notes'")
    List<Map> response = await dbObj.read('notes');
    notes.addAll(response);
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
    print(response);
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        height: 50,
        width: 50,
        // color: Colors.black,
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'addnotes');
          },
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Notes App (SqfLite)',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        // margin: const EdgeInsets.all(10),
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  color: Colors.red,
                ),
                child: GestureDetector(
                  onTap: () async {
                    await dbObj.deleteLocalDataBase();
                  },
                  child: const Center(
                    child: Text(
                      'Delete All Notes (Data Base)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   decoration: const BoxDecoration(
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(20),
              //     ),
              //     color: Colors.black,
              //   ),
              //   child: GestureDetector(
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => const AddNotePage(),
              //         ),
              //       );
              //     },
              //     child: const Center(
              //       child: Text(
              //         'Add Note',
              //         style: TextStyle(
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              // FutureBuilder(
              //   future: readData(),
              //   builder:
              //       (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
              //     if (snapshot.hasData) {
              //       return
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notes.length,
                      itemBuilder: (context, index) => Card(
                        shadowColor: Colors.black,
                        child: ListTile(
                          title: Text(
                            "Title : ${notes[index]['title']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            "Note : ${notes[index]['note']}\nColor : ${notes[index]['color']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  int response = await dbObj.deleteData(
                                      "DELETE FROM 'notes' WHERE id = ${notes[index]['id']}");
                                  if (response > 0) {
                                    notes.removeWhere((element) =>
                                        element['id'] == notes[index]['id']);
                                    setState(() {});
                                  }

                                  print('delete');
                                },
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => EditNotePage(
                                        note: notes[index]['note'],
                                        title: notes[index]['title'],
                                        color: notes[index]['color'],
                                        id: notes[index]['id'],
                                      ),
                                    ),
                                  );
                                  print('edit');
                                },
                                icon: const Icon(Icons.edit),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
  //     return const Center(
  //       child: CircularProgressIndicator(
  //         color: Colors.black,
  //       ),
  //     );
  //   },
  // ),
}

// MaterialButton(
//                 color: Colors.blue,
//                 textColor: Colors.black,
//                 onPressed: () async {
//                   int res = await dbObj.insertData(
//                       "INSERT INTO 'notes' ('note') VALUES ('note three')");
//                   print(res);
//                 },
//                 child: const Text(
//                   'insert data',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 textColor: Colors.black,
//                 onPressed: () async {
//                   List<Map> res = await dbObj.readData("SELECT * FROM 'notes'");
//                   print(res);
//                 },
//                 child: const Text(
//                   'read data',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 textColor: Colors.black,
//                 onPressed: () async {
//                   int res = await dbObj.updateData(
//                       "UPDATE 'notes' SET 'note' = 'note fff' WHERE id = 9");
//                   print(res);
//                 },
//                 child: const Text(
//                   'update data',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
//               MaterialButton(
//                 color: Colors.blue,
//                 textColor: Colors.black,
//                 onPressed: () async {
//                   int res = await dbObj
//                       .deleteData("DELETE FROM 'notes' WHERE id = 8");
//                   print(res);
//                 },
//                 child: const Text(
//                   'delete data',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 20,
//                   ),
//                 ),
//               ),
