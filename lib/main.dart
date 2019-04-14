import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:typed_data';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
String _alarm = "Not Entered";
  double _alarmtime = 0;
  double _maxtime = 0;
  List<bool> pressed = new List.filled(25, false);
  var date = new DateTime.now();
  double _settime = 0;

void main() async {
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  runApp(MyApp());
} 

Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _scheduleNotification() async {
  double mins = _settime % 1;
  int min = (mins * 60).ceil();
  int hour = _settime.truncate();
  int index = 24;
  for(int i = 0; i < pressed.length; i++){
    if(pressed[i]){
      index = i;
      break;
    }
  }
  hour = index - hour;
  min = 60 - min;
  if(min == 60){
    min = 0;
  }
  if(min != 0){
    hour--;
  }
  var scheduledNotificationDateTime = DateTime.now().add(new Duration(minutes: 1));
      //new DateTime(date.year,date.month,date.day, hour, min);
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'secondary_icon',
      sound: 'slow_spring_board',
      largeIcon: 'sample_large_icon',
      largeIconBitmapSource: BitmapSource.Drawable,
      vibrationPattern: vibrationPattern,
      color: const Color.fromARGB(255, 255, 0, 0));
  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'ALARM',
      'GET UP!',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
  await _cancelNotification();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alarm Central',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Alarm Central'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class DelayData {
  // from 3.83.174.78/api/closure, clark's api
  final String month;
  final int day;
  final int year;

  DelayData({this.month, this.day, this.year});

  factory DelayData.fromJson(Map<String, dynamic> json) {
    return DelayData(
      month: json['month'],
      day: json['num'],
      year: json['year'],
    );
  }
}

Future<DelayData> _fetchPost() async {
  final response = await http.get('http://3.83.174.78/api/closure');

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    return DelayData.fromJson(json.decode(response.body));
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  initState() {
    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  
  void _cancelAlarm() {
    setState(() {
      date = new DateTime.now();
      date = date.add(new Duration(days: 1));
      
      _settime = _maxtime;
      double maxmins = _maxtime % 1;
      int maxmin = (maxmins * 60).ceil();
      int maxhour = _maxtime.truncate();
      maxmin = 60 - maxmin;
      if(maxmin == 60){
        maxmin = 0;
      }
      if(maxmin != 0 ){
        maxhour--;
      }
      String tim = "School is CANCELLED\n";
      if(maxhour >= 12){
        if(maxhour == 12){
          maxhour = 24;
        }
        if(maxmin < 10){
          tim += (maxhour-12).toString() + ":0" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
        }else{
          tim += (maxhour-12).toString() + ":" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
        }
      }else{
        if(maxhour == 0){
          maxhour = 12;
        }
        if(maxmin < 10){
          tim += (maxhour).toString() + ":0" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
        }else{
          tim += (maxhour).toString() + ":" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
        }
      }
      _alarm = tim;
    });

  }

  void _setAlarm() {
    setState(() {
      date = new DateTime.now();
      date = date.add(new Duration(days: 1));
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if(_alarmtime != 0){
        double mins = _alarmtime % 1;
        int min = (mins * 60).ceil();
        int hour = _alarmtime.truncate();
        int index = 24;
        for(int i = 0; i < pressed.length; i++){
          if(pressed[i]){
            index = i;
            break;
          }
        }
        hour = index - hour;
        min = 60 - min;
        if(min == 60){
          min = 0;
        }
        if(min != 0){
          hour--;
        }
        double maxmins = _maxtime % 1;
        int maxmin = (maxmins * 60).ceil();
        int maxhour = _maxtime.truncate();
        maxmin = 60 - maxmin;
        if(maxmin == 60){
          maxmin = 0;
        }
        if(maxmin != 0 ){
          maxhour--;
        }
        String tim = "";
        if(maxhour < hour || (maxhour == hour && maxmin < min)){
          _settime = _maxtime;
          if(maxhour >= 12){
            if(maxhour == 12){
              maxhour = 24;
            }
            if(maxmin < 10){
              tim = (maxhour-12).toString() + ":0" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString() ;
            }else{
              tim = (maxhour-12).toString() + ":" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }else{
            if(maxhour == 0){
              maxhour = 12;
            }
            if(maxmin < 10){
              tim = (maxhour).toString() + ":0" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (maxhour).toString() + ":" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }
        }else{
          _settime = _alarmtime;
          while(hour < 0){
            hour += 24;
            date = date.add(new Duration(days: -1));
          }
          if(hour >= 12){
            if(hour == 12){
              hour = 24;
            }
            if(min < 10){
              tim = (hour-12).toString() + ":0" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (hour-12).toString() + ":" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }else{
            if(hour == 0){
              hour = 12;
            }
            if(min < 10){
              tim = (hour).toString() + ":0" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (hour).toString() + ":" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }
        }
        _alarm = tim;
      }
    });

  }

  void _setAlarmTime(double time) {
    setState(() {
      date = new DateTime.now();
      date = date.add(new Duration(days: 1));
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _alarmtime  = time;
      double mins = _alarmtime % 1;
      int min = (mins * 60).ceil();
      int hour = _alarmtime.truncate();
      int index = 24;
      for(int i = 0; i < pressed.length; i++){
        if(pressed[i]){
          index = i;
          break;
        }
      }
      hour = index - hour;
      min = 60 - min;
      if(min == 60){
        min = 0;
      }
      if(min != 0){
        hour--;
      }
      double maxmins = _maxtime % 1;
      int maxmin = (maxmins * 60).ceil();
      int maxhour = _maxtime.truncate();
      maxmin = 60 - maxmin;
      if(maxmin == 60){
        maxmin = 0;
      }
      if(maxmin != 0 ){
        maxhour--;
      }
      String tim = "";
      if(maxhour < hour || (maxhour == hour && maxmin < min)){
        _settime = _maxtime;
        if(maxhour >= 12){
          if(maxhour == 12){
            maxhour = 24;
          }
          if(maxmin < 10){
            tim = (maxhour-12).toString() + ":0" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (maxhour-12).toString() + ":" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }else{
          if(maxhour == 0){
            maxhour = 12;
          }
          if(maxmin < 10){
            tim = (maxhour).toString() + ":0" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (maxhour).toString() + ":" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }
      }else{
        _settime = _alarmtime;
        while(hour < 0){
            hour += 24;
            date = date.add(new Duration(days: -1));
        }
        if(hour >= 12){
          if(hour == 12){
            hour = 24;
          }
          if(min < 10){
            tim = (hour-12).toString() + ":0" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (hour-12).toString() + ":" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }else{
          if(hour == 0){
            hour = 12;
          }
          if(min < 10){
            tim = (hour).toString() + ":0" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (hour).toString() + ":" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }
      }
      _alarm = tim;
    });

  }

  void _setAlarmMax(double time) {
    setState(() {
      date = new DateTime.now();
      date = date.add(new Duration(days: 1));
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _maxtime  = time;
      if(_alarmtime != 0){
        double mins = _alarmtime % 1;
        int min = (mins * 60).ceil();
        int hour = _alarmtime.truncate();
        int index = 24;
        for(int i = 0; i < pressed.length; i++){
          if(pressed[i]){
            index = i;
            break;
          }
        }
        hour = index - hour;
        min = 60 - min;
        if(min == 60){
          min = 0;
        }
        if(min != 0){
          hour--;
        }
        double maxmins = _maxtime % 1;
        int maxmin = (maxmins * 60).ceil();
        int maxhour = _maxtime.truncate();
        maxmin = 60 - maxmin;
        if(maxmin == 60){
          maxmin = 0;
        }
        if(maxmin != 0 ){
          maxhour--;
        }
        String tim = "";
        if(maxhour < hour || (maxhour == hour && maxmin < min)){
          _settime = _maxtime;
          if(maxhour >= 12){
            if(maxhour == 12){
              maxhour = 24;
            }
            if(maxmin < 10){
              tim = (maxhour-12).toString() + ":0" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (maxhour-12).toString() + ":" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }else{
            if(maxhour == 0){
              maxhour = 12;
            }
            if(maxmin < 10){
              tim = (maxhour).toString() + ":0" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (maxhour).toString() + ":" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }
        }else{
          _settime = _alarmtime;
          while(hour < 0){
            hour += 24;
            date = date.add(new Duration(days: -1));
          }
          if(hour >= 12){
            if(hour == 12){
              hour = 24;
            }
            if(min < 10){
              tim = (hour-12).toString() + ":0" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (hour-12).toString() + ":" + min.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }else{
            if(hour == 0){
              hour = 12;
            }
            if(min < 10){
              tim = (hour).toString() + ":0" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }else{
              tim = (hour).toString() + ":" + min.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
            }
          }
        }
        _alarm = tim;
      }else{
        _settime = _maxtime;
        double maxmins = _maxtime % 1;
        int maxmin = (maxmins * 60).ceil();
        int maxhour = _maxtime.truncate();
        maxmin = 60 - maxmin;
        if(maxmin == 60){
          maxmin = 0;
        }
        if(maxmin != 0 ){
          maxhour--;
        }
        String tim = "";
        if(maxhour >= 12){
          if(maxhour == 12){
            maxhour = 24;
          }
          if(maxmin < 10){
            tim = (maxhour-12).toString() + ":0" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (maxhour-12).toString() + ":" + maxmin.toString() + " pm on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }else{
          if(maxhour == 0){
            maxhour = 12;
          }
          if(maxmin < 10){
            tim = (maxhour).toString() + ":0" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }else{
            tim = (maxhour).toString() + ":" + maxmin.toString() + " am on " + date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
          }
        }
        _alarm = tim;
      }
      
    });

  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Please block off all hours that you have any activities tomorrow", textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Table(
              border: TableBorder.all(color: Colors.black, width: 1),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: pressed[0] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[0] = !pressed[0];
                            _setAlarm();
                            await _scheduleNotification();

                          },
                          child: Text("12:00 am",textAlign: TextAlign.center,)
                        ),
                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[1] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[1] = !pressed[1];
                            _setAlarm();
                            await _scheduleNotification();

                          },
                          child: Text("1:00 am",textAlign: TextAlign.center,)
                        ),
                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[2] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child:
                        GestureDetector(
                          onTap: () async{
                            pressed[2] = !pressed[2];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("2:00 am",textAlign: TextAlign.center,)
                        ),
                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[3] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[3] = !pressed[3];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();  
                            
                          },
                          child: Text("3:00 am",textAlign: TextAlign.center,)
                        ),
                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[4] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[4] = !pressed[4];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("4:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[5] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[5] = !pressed[5];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("5:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[6] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[6] = !pressed[6];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("6:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[7] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[7] = !pressed[7];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("7:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[8] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[8] = !pressed[8];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("8:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[9] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[9] = !pressed[9];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("9:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[10] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[10] = !pressed[10];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("10:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[11] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[11] = !pressed[11];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("11:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[12] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[12] = !pressed[12];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("12:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[13] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[13] = !pressed[13];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("1:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[14] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[14] = !pressed[14];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("2:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[15] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[15] = !pressed[15];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("3:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[16] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[16] = !pressed[16];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("4:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[17] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[17] = !pressed[17];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("5:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[18] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[18] = !pressed[18];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("6:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
               TableRow(
                  decoration: BoxDecoration(color: pressed[19] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[19] = !pressed[19];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification(); 
                            
                          },
                          child: Text("7:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[20] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[20] = !pressed[20];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("8:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[21] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[21] = !pressed[21];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("9:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[22] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[22] = !pressed[22];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("10:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[23] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[23] = !pressed[23];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("11:00 pm",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
                TableRow(
                  decoration: BoxDecoration(color: pressed[24] ? Colors.red : Colors.white),
                  children: [
                    TableCell(
                      child: 
                        GestureDetector(
                          onTap: () async{
                            pressed[24] = !pressed[24];
                            await _cancelNotification();
                            _setAlarm();
                            await _scheduleNotification();
                            
                          },
                          child: Text("12:00 am",textAlign: TextAlign.center,)
                        ),                    ),
                  ]
                ),
              ]
            ),
            SizedBox(
              height:20
            ),
            Text(
              "Please enter how many hours you wish to wake up before your first blocked off activity:", textAlign: TextAlign.center,
            ),
            TextField (
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              onSubmitted: (value) async{
                await _cancelNotification();
                _setAlarmTime(double.parse(value));
                await _scheduleNotification();
              },
            ),
            SizedBox(
              height:20
            ),
            Text(
              "Please enter the latest hour in 24 hour time you wish to wake up in the event of a cancellation:", textAlign: TextAlign.center,
            ),
            TextField (
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              onSubmitted: (value) async{
                await _cancelNotification();
                _setAlarmMax(double.parse(value));
                await _scheduleNotification();
              },
            ),
            SizedBox(
              height:10
            ),
            Text(
              'Your alarm is currently set for:', textAlign: TextAlign.center,
            ),
            SizedBox(
              height:10
            ),
            Text(
              '$_alarm',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            /*
            FutureBuilder<DelayData>(
              future: _fetchPost(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.month);
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ), // FutureBuilder
            */
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
