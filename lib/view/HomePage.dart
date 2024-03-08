import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/TimeFormator.dart';

import 'package:intl/intl.dart';
import '../model/WorkAtDay.dart';
import '../utils/FileReader.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WorkAtDay> items = [];
  bool timer = false;
  String itemsToString() {
    String str = "";
    for (int i = 0; i < items.length; i++) {
      print(items[i].start.toString());
      str += items[i].start.toString() + ',' + items[i].end.toString() + "\n";
    }
    return str;
  }

  String selectedItemsToString() {
    String str = "";
    var selectedItems =
        items.where((element) => element.selected == true).toList();
    for (int i = 0; i < selectedItems.length; i++) {
      print(selectedItems[i].start.toString());
      str += selectedItems[i].start.toString() +
          ',' +
          selectedItems[i].end.toString() +
          "\n";
    }
    return str;
  }

  int selectedITems = 0;
  var reuslt = "0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileReader.readFile("data").then((value) {
      var list = value.split('\n');
      print(list);
      List<WorkAtDay> newItems = [];
      for (int i = 0; i < list.length - 1; i++) {
        var item = list[i].split(',');
        print(item);
        newItems.add(WorkAtDay(
          start: DateTime.parse(item[0]),
          end: DateTime.parse(item[1]),
          selected: false,
        ));
      }

      setState(() {
        items = newItems;
      });
    });
  }

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          // if (index == 0) Navigator.pushReplacementNamed(context, '/');
          if (index == 1) Navigator.pushReplacementNamed(context, '/archive');
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: 'الارشيف',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            setState(() {
              items.add(WorkAtDay(
                  start: DateTime.now(), end: DateTime.now(), selected: false));
            });
            FileReader.writeFile('data', itemsToString());
            print("writing");
          }),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView(children: [
        Container(
            height: 500,
            child: ListView(children: [
              DataTable(
                showCheckboxColumn: true,
                horizontalMargin: 10,
                columnSpacing: 5,
                showBottomBorder: true,
                headingRowColor: MaterialStateProperty.resolveWith((states) {
                  return Colors.blueGrey.shade100;
                }),
                columns: [
                  DataColumn(label: Text("التاريخ")),
                  DataColumn(label: Text("الي")),
                  DataColumn(label: Text("من")),
                  DataColumn(label: Text("المجموع")),
                  DataColumn(label: Text("حذف")),
                ],
                rows: items
                    .map((e) => DataRow(
                          cells: [
                            DataCell(
                                Text(e.start.year.toString() +
                                    '/' +
                                    e.start.month.toString() +
                                    '/' +
                                    e.start.day.toString()), onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: e.start,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              setState(() {
                                e.start = new DateTime(
                                    newDate!.year,
                                    newDate.month,
                                    newDate.day,
                                    e.start.hour,
                                    e.start.minute);
                                e.end = new DateTime(
                                    newDate!.year,
                                    newDate.month,
                                    newDate.day,
                                    e.end.hour,
                                    e.end.minute);
                              });
                            }),
                            DataCell(
                              Text(
                                DateFormat.jm().format(e.end).toString(),
                              ),
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: e.end.hour,
                                        minute: e.end.minute));
                                DateTime now = DateTime.now();

                                setState(() {
                                  e.end = DateTime(now.year, now.month, now.day,
                                      newTime!.hour, newTime!.minute);
                                });
                              },
                            ),
                            DataCell(
                              Text(
                                DateFormat.jm().format(e.start).toString(),
                              ),
                              onTap: () async {
                                TimeOfDay? newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay(
                                        hour: e.start.hour,
                                        minute: e.start.minute));

                                DateTime now = DateTime.now();
                                setState(() {
                                  e.start = DateTime(now.year, now.month,
                                      now.day, newTime!.hour, newTime!.minute);
                                });
                              },
                            ),
                            DataCell(
                              Text(
                                TimerFormator.getTimeString(
                                    e.end.difference(e.start).inMinutes),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            DataCell(IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => FileReader.appendFile(
                                        "archive",
                                        e.start.toString() +
                                            ',' +
                                            e.end.toString() +
                                            "\n")
                                    .then((value) => setState(
                                          () {
                                            items.remove(e);
                                          },
                                        )))),
                          ],
                          selected: e.selected,
                          onSelectChanged: (value) {
                            setState(() {
                              if (e.selected == true) {
                                selectedITems -= 1;
                              } else {
                                selectedITems += 1;
                              }
                              e.selected = !e.selected;
                            });
                          },
                          onLongPress: () {
                            setState(() {
                              if (e.selected == true) {
                                selectedITems -= 1;
                              } else {
                                selectedITems += 1;
                              }
                              e.selected = !e.selected;
                            });
                          },
                        ))
                    .toList(),
              ),
            ])),
        Container(
            child: Column(children: [
          Text(" المجموع الكلي : " + reuslt),
          ElevatedButton(
              onPressed: () {
                if (items[0].start != null && items[0].end != null) {
                  // TimeOfDay duration = items[0]['start'].difference items[0]['end'];
                  setState(() {
                    int res = 0;
                    for (int i = 0; i < items.length; i++) {
                      res += items[i].end.difference(items[i].start).inMinutes;
                    }
                    reuslt = TimerFormator.getTimeString(res);
                  });
                }
              },
              child: Text("حساب المجموع الكلي")),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                child: Text("حفظ البيانات"),
                onPressed: () => FileReader.writeFile('data', itemsToString())),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text("هل تريد حذف البيانات؟"),
                            actions: [
                              TextButton(
                                  child: Text("نعم"),
                                  onPressed: () {
                                    FileReader.appendFile(
                                            'archive', selectedItemsToString())
                                        .then((value) {
                                      setState(() {
                                        items.removeWhere((element) =>
                                            element.selected == true);
                                      });
                                      FileReader.writeFile(
                                              'data', itemsToString())
                                          .then((value) {
                                        Navigator.pop(context);
                                      });
                                    });
                                  })
                            ]);
                      });
                },
                icon: Icon(
                  Icons.delete_forever,
                )),
          ]),
          ElevatedButton.icon(
              onPressed: () {
                if (timer == false)
                  FileReader.writeFile("timer", "${DateTime.now()}")
                      .then((value) => setState(() {
                            timer = true;
                          }));
                else {
                  String start = "";
                  FileReader.readFile("timer").then((value) {
                    start = value;
                    setState(() {
                      timer = false;
                      items.add(WorkAtDay(
                          start: DateTime.parse(start),
                          end: DateTime.now(),
                          selected: false));
                    });
                    FileReader.writeFile('data', itemsToString())
                        .then((value) {});
                  });
                }
              },
              icon: timer ? Icon(Icons.pause) : Icon(Icons.play_arrow),
              label: timer ? Text("توقف المؤقت") : Text("بدء المؤقت"))
        ]))
      ]),
    );
  }
}
