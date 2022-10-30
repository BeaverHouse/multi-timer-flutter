import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_timer_flutter/atoms/upload_dialog.dart';
import 'package:multi_timer_flutter/noti/noti_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotifyUnit extends StatefulWidget {

  final int id;

  const NotifyUnit({super.key, required this.id});

  @override
  State<NotifyUnit> createState() => _NotifyUnitState();
}

class _NotifyUnitState extends State<NotifyUnit> {

  String name = "알람 이름";
  int seconds = 3600;
  String? end;

  @override
  void initState() {
    super.initState();
    loadAlarm(widget.id);
  }
 
  // Loading counter value on start
  void loadAlarm(int id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = (prefs.getString("name$id") ?? "알람 이름$id");
      seconds = (prefs.getInt("seconds$id") ?? 600);
      end = prefs.getString("end$id");
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    int hours = seconds~/3600;
    int mins = seconds~/60 - hours * 60;
    int secs = seconds%60;

    return GestureDetector(
      onLongPress:() async {
        if (end != null) return;
        showDialog<void>(
          context: context,
          builder: ((context) => UpdateDialog(
            id: widget.id,
            name: name,
            seconds: seconds,
          ))
        ).then((_) => loadAlarm(widget.id));
      },
      child: Container(
        width: width-30,
        margin: const EdgeInsets.all(2.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all()),
        child: Row(
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Icon(
                Icons.alarm, 
                size: 40,
                color: end != null ? Colors.red : Colors.grey
              )
            ),              
            const SizedBox(width: 15,),
            SizedBox(
                width: width - 200,
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name, 
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.fade,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    end ?? "$hours시간 $mins분 $secs초", 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w600, 
                      color: end != null ? Colors.red : Colors.grey),
                    overflow: TextOverflow.fade,
                  )                
                ]
              ),
            ),
            FloatingActionButton(
              onPressed: (() {
                if (end == null) {
                  NotificationController.scheduleNewNotification(widget.id, name, seconds)
                  .then((_) async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("end${widget.id}", DateFormat.Hms("ko_KR").format(DateTime.now().add(Duration(seconds: seconds))));
                    loadAlarm(widget.id);
                  });
                } else {
                  NotificationController.cancelNotification(widget.id)
                  .then((_) async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.remove("end${widget.id}");
                    loadAlarm(widget.id);
                  });
                }
              }),
              child: Icon(end == null ? Icons.play_arrow : Icons.stop)
            )
          ],
        ) 
      )
    );
  }
}