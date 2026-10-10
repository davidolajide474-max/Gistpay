import 'package:flutter/material.dart';

void main() => runApp(const MyDayApp());

class MyDayApp extends StatelessWidget {
  const MyDayApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const TodoHome(),
    );
  }
}

class Todo {
  String title;
  bool done;
  Todo(this.title, this.done);
}

class TodoHome extends StatefulWidget {
  const TodoHome({super.key});
  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  final TextEditingController _controller = TextEditingController();
  List<Todo> todos = [
    Todo("Buy fuel for gen", false),
    Todo("Finish my app", false),
    Todo("Charge phone to 100%", true),
  ];

  void addTodo() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      todos.insert(0, Todo(_controller.text.trim(), false));
      _controller.clear();
    });
  }

  void toggle(int i) {
    setState(() => todos[i].done =!todos[i].done);
  }

  void delete(int i) {
    setState(() => todos.removeAt(i));
  }

  @override
  Widget build(BuildContext context) {
    int doneCount = todos.where((t) => t.done).length;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("MY DAY - $doneCount/${todos.length} Done", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "What to do today?",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: addTodo,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                    child: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: todos.isEmpty
               ? const Center(child: Text("No tasks yet. Add one! ✅", style: TextStyle(fontSize: 16, color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: todos.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                        child: ListTile(
                          leading: Checkbox(value: todos[i].done, onChanged: (_) => toggle(i), activeColor: Colors.indigo),
                          title: Text(todos[i].title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, decoration: todos[i].done? TextDecoration.lineThrough : null, color: todos[i].done? Colors.grey : Colors.black)),
                          trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => delete(i)),
                          onTap: () => toggle(i),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Text("${todos.length} tasks total • Tap to complete • Long press? No, just tap!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
      ),
    );
  }
}
