import 'package:flutter/material.dart';
import 'package:multi_timer_flutter/molecules/noti_unit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "꾹 눌러서 수정!", 
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              overflow: TextOverflow.fade,
            ),
            const SizedBox(height: 20),
            ...[1,2,3,4,5].map((e) => NotifyUnit(id: e))
          ],
        ),
      ),
    );
  }
}