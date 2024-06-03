import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<DateTime> alarms = [];

  @override
  void initState() {
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        // Handle the payload here
        DateTime scheduledTime = DateTime.parse(payload);
        // Show the popup dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center( // Center the dialog
              child: AlertDialog(
                title: Center(child: Text('Bangunlah Sigma')), // Center the title
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network('https://example.com/custom_alarm_image.png'), // Replace URL with your image URL
                    Text('Alarm was scheduled for ${scheduledTime.hour}:${scheduledTime.minute}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Dismiss'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  void _addAlarm() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      DateTime now = DateTime.now();
      DateTime alarmTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);

      if (alarmTime.isBefore(now)) {
        alarmTime = alarmTime.add(Duration(days: 1));
      }

      setState(() {
        alarms.add(alarmTime);
      });

      _scheduleAlarm(alarmTime); // Schedule the alarm
    }
  }

  void _removeAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  void _scheduleAlarm(DateTime scheduledTime) async {
    var androidDetails = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      channelDescription: 'Channel for Alarm notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Alarm',
      'It\'s time!',
      scheduledTime,
      generalNotificationDetails,
      payload: scheduledTime.toIso8601String(), // Pass scheduledTime as payload
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sigma Alarm'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          DateTime alarm = alarms[index];
          return ListTile(
            title: Text('${alarm.hour.toString().padLeft(2, '0')}:${alarm.minute.toString().padLeft(2, '0')}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeAlarm(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAlarm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
