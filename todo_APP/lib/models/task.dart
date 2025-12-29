class Task {
  final String id;
  String title;
  bool done;

  Task({
    required this.id,
    required this.title,
    this.done = false,
  });
}
