import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyDayApp());
}

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

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  final String adUnitId = "ca-app-pub-3940256099942544/6300978111";

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, err) { ad.dispose(); },
      ),
    )..load();
  }

  void addTodo() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      todos.insert(0, Todo(_controller.text.trim(), false));
      _controller.clear();
    });
  }

  void toggle(int i) => setState(() => todos[i].done =!todos[i].done);
  void delete(int i) => setState(() => todos.removeAt(i));

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
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
                    ),
                    onSubmitted: (_) => addTodo(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), minimumSize: const Size(80, 54)),
                  child: const Text("ADD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              itemCount: todos.length,
              itemBuilder: (context, i) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Checkbox(value: todos[i].done, onChanged: (_) => toggle(i), activeColor: Colors.indigo),
                  title: Text(todos[i].title, style: TextStyle(decoration: todos[i].done? TextDecoration.lineThrough : null, color: todos[i].done? Colors.grey : Colors.black)),
                  trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => delete(i)),
                  onTap: () => toggle(i),
                ),
              ),
            ),
          ),
          if (_isAdLoaded && _bannerAd!= null)
            Container(color: Colors.white, width: _bannerAd!.size.width.toDouble(), height: _bannerAd!.size.height.toDouble(), child: AdWidget(ad: _bannerAd!))
          else
            Container(height: 50, color: Colors.white, child: const Center(child: Text("Ad loading... your money dey load", style: TextStyle(color: Colors.grey, fontSize: 12)))),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
