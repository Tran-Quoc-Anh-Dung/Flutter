import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  final List<String> todos = [];
  final List<String> done = [];

  void addTask() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      todos.add(controller.text.trim());
      controller.clear();
    });
  }

  void editTask(int index, bool isDoneList) {
    final list = isDoneList ? done : todos;
    final editController = TextEditingController(text: list[index]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Đổi tên công việc"),
        content: TextField(
          controller: editController,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editController.text.trim().isEmpty) return;
              setState(() => list[index] = editController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  void toggleDone(int index) {
    setState(() {
      done.add(todos[index]);
      todos.removeAt(index);
    });
  }

  void restoreTask(int index) {
    setState(() {
      todos.add(done[index]);
      done.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todo App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Nhập công việc...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: addTask, child: const Text("Thêm")),
              ],
            ),
            const SizedBox(height: 16),
            const Text("📌 TODO",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (_, i) => Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: false,
                      onChanged: (_) => toggleDone(i),
                    ),
                    title: Text(todos[i]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editTask(i, false),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(() => todos.removeAt(i)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text("✅ DONE", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: done.length,
                itemBuilder: (_, i) => Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: true,
                      onChanged: (_) => restoreTask(i),
                    ),
                    title: Text(
                      done[i],
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => editTask(i, true),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => setState(() => done.removeAt(i)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
