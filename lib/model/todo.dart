class TODO {
  int id;
  String date;
  String task;

  TODO({this.id, this.date, this.task});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"date": this.date, "taskName": this.task};
    return map;
  }
}
