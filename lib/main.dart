import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(GistPayV3());

class GistPayV3 extends StatefulWidget {
  @override
  _GistPayV3State createState() => _GistPayV3State();
}

class _GistPayV3State extends State<GistPayV3> {
  double balance = 5000;
  List<String> transactions = ["Added N1000", "Received N500", "Sent N200"];

  String username = "David";
  String paymentLink = "gistpay.me/David";

  void addMoney() async {
    setState(() {
      balance += 1000;
      transactions.insert(0, "Added N1000 - ${DateTime.now().hour}:${DateTime.now().minute}");
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('balance', balance);
    prefs.setStringList('transactions', transactions);
  }

  void shareLink() async {
    final url = Uri.parse("https://wa.me/?text=Pay me via GISTPAY: https://$paymentLink 💚");
    if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("GISTPAY - $username"), backgroundColor: Color(0xFF2E9E4E)),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Color(0xFF2E9E4E), borderRadius: BorderRadius.circular(16)),
                child: Column(children: [
                  Text("Wallet Balance", style: TextStyle(color: Colors.white70)),
                  Text("₦${balance.toStringAsFixed(0)}", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text(paymentLink, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ]),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: addMoney, child: Text("Add N1000"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2E9E4E), minimumSize: Size(double.infinity, 50))),
              SizedBox(height: 10),
              ElevatedButton.icon(onPressed: shareLink, icon: Icon(Icons.share), label: Text("Share $paymentLink on WhatsApp"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], minimumSize: Size(double.infinity, 50))),
              SizedBox(height: 20),
              Text("Recent Gists", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              Expanded(child: ListView.builder(itemCount: transactions.length, itemBuilder: (c,i) => ListTile(title: Text(transactions[i]))))
            ],
          ),
        ),
      ),
    );
  }
}
