import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../model/WorkAtDay.dart';
import '../utils/FileReader.dart';
import '../utils/TimeFormator.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key, required this.title});
  final String title;
  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<WorkAtDay> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FileReader.readFile("archive").then((value) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/');
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
                                onPressed: () => setState(
                                      () {
                                        items.remove(e);
                                      },
                                    ))),
                          ],
                          selected: e.selected,
                          onSelectChanged: (value) {
                            //   setState(() {
                            //     if (e.selected == true) {
                            //       selectedITems -= 1;
                            //     } else {
                            //       selectedITems += 1;
                            //     }
                            //     e.selected = !e.selected;
                            //   });
                            // },
                            // onLongPress: () {
                            //   setState(() {
                            //     if (e.selected == true) {
                            //       selectedITems -= 1;
                            //     } else {
                            //       selectedITems += 1;
                            //     }
                            //     e.selected = !e.selected;
                            //   });
                          },
                        ))
                    .toList(),
              ),
            ])),
      ]),
    );
  }
}
