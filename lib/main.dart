import 'package:flutter/material.dart';
void main() => runApp(GistPayApp());
class GistPayApp extends StatelessWidget {
  @override Widget build(BuildContext c) {
    return MaterialApp(debugShowCheckedModeBanner:false, home:HomeScreen());
  }
}
class HomeScreen extends StatefulWidget {
  @override _HomeScreenState createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  double balance = 5000;
  List<String> tx = ["Received N2000 from Tolu", "Sent N500 to Mama"];
  void add() { setState(() { balance+=1000; tx.insert(0,"Added N1000"); }); }
  @override Widget build(BuildContext c) {
    return Scaffold(
      appBar: AppBar(title:Text("GistPay"), backgroundColor:Color(0xFF00A859), foregroundColor:Colors.white),
      body: Padding(padding:EdgeInsets.all(16), child:Column(children:[
        Card(color:Color(0xFF00A859), child:Padding(padding:EdgeInsets.all(20), child:Column(children:[
          Text("Wallet Balance", style:TextStyle(color:Colors.white)),
          Text("N${balance.toInt()}", style:TextStyle(color:Colors.white, fontSize:32, fontWeight:FontWeight.bold)),
          SizedBox(height:10), ElevatedButton(onPressed:add, child:Text("Add N1000"))
        ]))),
        SizedBox(height:20),
        Text("Recent Gists", style:TextStyle(fontWeight:FontWeight.bold)),
        Expanded(child:ListView.builder(itemCount:tx.length, itemBuilder:(c,i)=>ListTile(leading:Icon(Icons.payment), title:Text(tx[i])))),
        ElevatedButton.icon(onPressed:(){ ScaffoldMessenger.of(c).showSnackBar(SnackBar(content:Text("Link: gistpay.me/olajide - Shared!"))); }, icon:Icon(Icons.share), label:Text("Share Payment Link on WhatsApp"), style:ElevatedButton.styleFrom(backgroundColor:Color(0xFF00A859), foregroundColor:Colors.white))
      ])),
    );
  }
}
