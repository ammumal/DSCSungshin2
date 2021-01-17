import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      routes: { //routes 프로퍼티에 Map으로 문자열과 목적지 설정, 문자열 앞에 /붙인다
        '/first': (context) => MyHomePage(),
        SecondPage.routeName : (context) => SecondPage(),
      },
    );
  }
}

class Iljung {
  String name;
  String mydate;
  String mytime;

  Iljung(this.name, this.mydate, this.mytime);

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, }) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    print('FirstPage initState()');
  }


  @override
  void dispose() {
    super.dispose();
    print('FirstPage dispose()');
  }

  final myController = TextEditingController();
  String _selectedTime;
  DateTime _selectDate;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text('일정 관리'),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              expandedHeight: 180.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('일정 추가'),
                background: Image.asset('assets/dogsample.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverFillRemaining(
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: myController,
                          decoration: InputDecoration(
                            labelText: '일정 이름',
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            Future<DateTime> selectedDate = showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: ThemeData.light(),
                                  child: child,
                                );
                              },
                            );
                            selectedDate.then((dateTime) {
                              setState(() {
                                _selectDate = dateTime;
                              });
                            });
                          },
                          child: Text('날짜 선택'),
                        ),
                        Text('$_selectDate'),

                        RaisedButton(
                          onPressed: () {
                            Future<TimeOfDay> selectedTime = showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            selectedTime.then((timeOfDay) {
                              setState(() {
                                _selectedTime = '${timeOfDay.hour}:${timeOfDay.minute}';
                              });
                            });
                          },
                          child: Text('시간 선택'),
                        ),
                        Text('$_selectedTime'),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            labelText: '설명',
                          ),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        RaisedButton(
                          onPressed: () {
                            _showDialog();
                          },
                          child: Text('일정 추가'),
                        ),
                        RaisedButton(
                          child: Text('목록 보기'),
                          onPressed: () async {
                            await Navigator.pushNamed(
                                context,
                                SecondPage.routeName,
                                arguments: Iljung(myController.text, '$_selectedTime', '$_selectDate'));
                          },
                        ),
                      ],
                    ),
                  )
              ),
            )
          ],
        )

    );
  }

  void _showDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: true, // 다이얼로그 바깥을 터치해도 닫히지 않는다
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('일정이 추가되었습니다'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () { // 다이얼로그 표시
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}

class SecondPage extends StatelessWidget{
  static const routeName = '/second';
  final Iljung iljung;
  SecondPage({@required this.iljung});

  @override
  Widget build(BuildContext context) {
    final Iljung args = ModalRoute.of(context).settings.arguments;
    print('SecondPage build()');
    return Scaffold(
      appBar: AppBar(
        title: Text('일정 목록'),
      ),
      body: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(args.name),
                    onTap: () {
                      Navigator.pop(context, 'ok');
                    },
                  ),
                  ListTile(
                    title: Text('coffee'),
                    onTap: () {
                      Navigator.pop(context, 'ok');
                    },
                  ),
                  ListTile(
                    title: Text('coffee'),
                    onTap: () {
                      Navigator.pop(context, 'ok');
                    },
                  ),
                ],
              ),
    );
  }
}