class WorkAtDay {
  WorkAtDay({required this.start, required this.end, required this.selected});
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  bool selected = false;
}