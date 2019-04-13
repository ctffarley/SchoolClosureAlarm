import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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

class _MyHomePageState extends State<MyHomePage> {
  String _alarm = "Not Entered";
  double _alarmtime = 0;
  double _maxtime = 0;
  List<bool> pressed = new List.filled(25, false);

  void _setAlarm() {
    setState(() {
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
        if(min != 0){
          hour--;
        }
        String tim = "";
        if(hour >= 12){
          if(hour == 12){
            hour = 24;
          }
          tim = (hour-12).toString() + ":" + min.toString();
          tim += " pm";
        }else{
          if(hour == 0){
            hour = 12;
          }
          tim = hour.toString() + ":" + min.toString();
          tim += " am";
        }
        _alarm = tim;
      }
    });

  }

  void _setAlarmTime(double time) {
    setState(() {
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
      if(min != 0){
        hour--;
      }
      String tim = "";
        if(hour >= 12){
          if(hour == 12){
            hour = 24;
          }
          tim = (hour-12).toString() + ":" + min.toString();
          tim += " pm";
        }else{
          if(hour == 0){
            hour = 12;
          }
          tim = hour.toString() + ":" + min.toString();
          tim += " am";
        }
        _alarm = tim;
    });

  }

  void _setAlarmMax(double time) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _maxtime  = time;
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
                          onTap: () {
                            pressed[0] = !pressed[0];
                            _setAlarm();
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
                          onTap: () {
                            pressed[1] = !pressed[1];
                            _setAlarm();
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
                          onTap: () {
                            pressed[2] = !pressed[2];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[3] = !pressed[3];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[4] = !pressed[4];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[5] = !pressed[5];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[6] = !pressed[6];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[7] = !pressed[7];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[8] = !pressed[8];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[9] = !pressed[9];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[10] = !pressed[10];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[11] = !pressed[11];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[12] = !pressed[12];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[13] = !pressed[13];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[14] = !pressed[14];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[15] = !pressed[15];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[16] = !pressed[16];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[17] = !pressed[17];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[18] = !pressed[18];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[19] = !pressed[19];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[20] = !pressed[20];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[21] = !pressed[21];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[22] = !pressed[22];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[23] = !pressed[23];
                            _setAlarm();
                              
                            
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
                          onTap: () {
                            pressed[24] = !pressed[24];
                            _setAlarm();
                              
                            
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
              "Please enter how many hours you wish to wake up before your first blocked off activity:"
            ),
            TextField (
              textAlign: TextAlign.center,
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              onSubmitted: (value){
                _setAlarmTime(double.parse(value));
              },
            ),
            SizedBox(
              height:20
            ),
            Text(
              "Please enter the latest hour in 24 hour time you wish to wake up in the event of a cancellation:"
            ),
            TextField (
              textAlign: TextAlign.center,
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              onSubmitted: (value){
                _setAlarmMax(double.parse(value));
              },
            ),
            SizedBox(
              height:10
            ),
            Text(
              'Your alarm is currently set for:',
            ),
            SizedBox(
              height:10
            ),
            Text(
              '$_alarm',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ],
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
