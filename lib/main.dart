import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

//앱 구동 (메인페이지를 인자로 받음)
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
      var contacts = await ContactsService.getContacts();
      setState(() {
        name = contacts;
      });
      // print(contacts[0].familyName);
      // print(contacts[0].givenName);

      // 폰에 연락처 강제 추가
      // var newPerson = Contact();
      // newPerson.givenName='철수';
      // newPerson.familyName='김';
      // ContactsService.addContact(newPerson);


    } else {
      print('거절됨');
      Permission.contacts.request();
      // openAppSettings();
    }
  }

  // 이 위젯이 처음 로드시 실행할 코드
  @override
  void initState() {
    super.initState();
    // getPermission();
  }

  int total = 3;
  int a = 1;
  List<int> like = [0, 0, 0, 0, 0];
  List<Contact> name = [];
  String address = '';

  void registerAddress(String address) {
    setState(() {
      // name.add(address);
      like.add(0); // 새로운 주소 추가 시 like 리스트에도 기본 값 추가
    });
  }

  void incrementState() {
    setState(() {
      a += 1;
    });
  }

  void addOne() {
    setState(() {
      total++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('버튼'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return DialogUI(
                state: a,
                state2: name,
                incrementState: incrementState,
                addOne: addOne,
                registerAddress: registerAddress,
                getPermission: getPermission,
              );
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text('연락처 앱 $total'),
        actions: [IconButton(onPressed: (){
          getPermission();
        }, icon: Icon(Icons.contacts))],
      ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text(name[index].givenName ?? '이름이 없는 놈'), // 변수 a를 텍스트에 표시
                Text(like[index].toString())
              ],
            ),
            leading: Icon(Icons.account_circle),
            trailing: TextButton(
              child: Text('좋아요'),
              onPressed: () {
                setState(() {
                  like[index]++; // 버튼을 눌렀을 때 변수 a의 값을 증가시킴
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomBar(),
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        color: Colors.yellow,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(Icons.phone),
            Icon(Icons.message),
            Icon(Icons.contact_page),
          ],
        ),
      ),
    );
  }
}

// 성능 이슈 있을 수 있다.
// 안바뀌는 것들은 변수에다가 축약해도 된다.
// 변하는 것들은 성능 이슈 발생 가능성이 있다.
const a = SizedBox(
  child: Text('안녕'),
);

class DialogUI extends StatelessWidget {
  DialogUI({
    super.key,
    required this.state,
    required this.state2,
    required this.incrementState,
    required this.addOne,
    required this.registerAddress,
    this.getPermission
  });

  final int state; // state를 숫자로 선언
  final state2;
  final VoidCallback incrementState;
  final VoidCallback addOne;
  final Function(String) registerAddress;
  var address = '';
  final getPermission;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (text) {
                address = text;
              },
              decoration: InputDecoration(
                hintText: '02123456',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'State: $state $state2',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    incrementState();
                    addOne();
                    // 폰에 연락처 강제 추가
                    var newPerson = Contact();
                    newPerson.givenName=address;
                    newPerson.familyName=address;
                    await ContactsService.addContact(newPerson);
                    getPermission();
                    // registerAddress(address);
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
