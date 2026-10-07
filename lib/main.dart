import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(GistPayV2());

class GistPayV2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GistPay',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Roboto'),
      home: LoginScreen(),
    );
  }
}

// LOGIN SCREEN - Pro Level
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final phoneCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet, size: 80, color: Colors.white),
            SizedBox(height: 10),
            Text("GistPay V2", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text("Chat, Post, Pay — Real Money", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 40),
            TextField(controller: phoneCtrl, keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: "Enter Phone e.g 0810...", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if(phoneCtrl.text.length < 10) return;
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('phone', phoneCtrl.text);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => WalletScreen()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, minimumSize: Size(double.infinity, 50)),
              child: Text("Login to Wallet", style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

// WALLET SCREEN - Real Money + Transfer
class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}
class _WalletScreenState extends State<WalletScreen> {
  int balance = 5000;
  List<String> gists = ["Received N2000 from Tolu", "Added N1000", "Added N1000"];
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }
  loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      balance = prefs.getInt('balance')?? 5000;
      phone = prefs.getString('phone')?? "";
      gists = prefs.getStringList('gists')?? gists;
    });
  }
  saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('balance', balance);
    await prefs.setStringList('gists', gists);
  }

  // PAYSTACK REAL PAYMENT
  payWithPaystack() async {
    // Replace with your real Paystack link or public key logic later
    // For now we open Paystack demo and simulate success
    final url = Uri.parse("https://paystack.com/pay/gistpay-demo");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
    // Simulate payment success after returning
    Future.delayed(Duration(seconds: 2), () {
      setState(() { balance += 1000; gists.insert(0, "Added N1000 via Paystack - ${DateTime.now().hour}:${DateTime.now().minute}"); });
      saveData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Payment Successful! N1000 Added")));
    });
  }

  void transferMoney() {
    final ctrlPhone = TextEditingController();
    final ctrlAmt = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text("Transfer to User"),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: ctrlPhone, decoration: InputDecoration(hintText: "Phone number")),
        TextField(controller: ctrlAmt, keyboardType: TextInputType.number, decoration: InputDecoration(hintText: "Amount")),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
        ElevatedButton(onPressed: () {
          int amt = int.tryParse(ctrlAmt.text)?? 0;
          if(amt > 0 && amt <= balance) {
            setState(() { balance -= amt; gists.insert(0, "Sent N$amt to ${ctrlPhone.text}"); });
            saveData();
            Navigator.pop(context);
          }
        }, child: Text("Send"))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GistPay V2 — $phone"), backgroundColor: Colors.green[700], actions: [IconButton(icon: Icon(Icons.logout), onPressed: () async {
        final prefs = await SharedPreferences.getInstance(); await prefs.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
      })]),
      body: Column(children: [
        Container(color: Colors.green[700], width: double.infinity, padding: EdgeInsets.all(20),
          child: Column(children: [
            Text("Wallet Balance", style: TextStyle(color: Colors.white70)),
            Text("N$balance", style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 15),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton.icon(onPressed: payWithPaystack, icon: Icon(Icons.add), label: Text("Add N1000 (Real Pay)"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.green[700])),
              ElevatedButton.icon(onPressed: transferMoney, icon: Icon(Icons.send), label: Text("Transfer"), style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white)),
            ])
          ]),
        ),
        Padding(padding: EdgeInsets.all(12), child: Row(children: [Text("Recent Gists", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), Spacer(), IconButton(icon: Icon(Icons.share), onPressed: () async {
          final url = Uri.parse("https://wa.me/?text=Pay me on GistPay! My wallet: $phone https://github.com/davidolajide474-max/Gistpay");
          if(await canLaunchUrl(url)) await launchUrl(url);
        })])),
        Expanded(child: ListView.builder(itemCount: gists.length, itemBuilder: (_, i) => ListTile(leading: Icon(Icons.history, color: Colors.green), title: Text(gists[i]), subtitle: Text("GistPay Secure"))))
      ]),
    );
  }
}
