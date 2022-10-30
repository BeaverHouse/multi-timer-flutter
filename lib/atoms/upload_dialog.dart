import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateDialog extends StatefulWidget {
  final String name;
  final int seconds;
  final int id;
  
  const UpdateDialog({super.key, required this.name, required this.seconds, required this.id});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final nameController = TextEditingController();
  int hours = 0;
  int mins = 0;
  int secs = 0;

  @override
  void initState() {
    nameController.text = widget.name;
    hours = widget.seconds~/3600;
    mins = widget.seconds~/60 - hours * 60;
    secs = widget.seconds%60;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(          
          title: const Text('알람 수정'),
          insetPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: width-50,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController, 
                  decoration: const InputDecoration(
                      labelText: "이름",
                      hintText: "이름",
                      border: OutlineInputBorder(),
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberPicker(
                      itemWidth: 50,
                      value: hours,
                      minValue: 0,
                      maxValue: 50,
                      onChanged: (value) => setState(() => hours = value),
                    ),
                    const Text(
                      '시간',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(
                      itemWidth: 50,
                      value: mins,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => mins = value),
                    ),
                    const Text(
                      '분',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    NumberPicker(                      
                      itemWidth: 50,
                      value: secs,
                      minValue: 0,
                      maxValue: 59,
                      onChanged: (value) => setState(() => secs = value),
                    ),
                    const Text(
                      '초',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            )
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('확인'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("name${widget.id}", nameController.text);
                prefs.setInt("seconds${widget.id}", hours*3600 + mins*60 + secs);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
  }
}