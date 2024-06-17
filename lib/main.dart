import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  var total = 3;
  var a = 1;
  var name = ['김영숙', '홍길동', '피자집', '피자집2', '피자집 3'];
  var like = [0, 0, 0, 0, 0];
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

  // 왜 MaterialAPp을 밖으로 빼야함?
  // context는 커스텀 위젯을 만들 때마다 강제로 생성된다.
  // context : 부모 위젯의 정보를 담고 있는 변수, 족보와 비슷 (부모님들과 부모님들의 부모... 나열)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('버튼'),
        // onPressed: () {
          // 입력한 context의 부모 중 MaterialApp이 있어야 동작한다.)
          // MaterialApp을 밖으로 빼지 않으면 context가 MaterialApp을 포함하지 않게된다.
          // Builder 사용하면 context를 생성할 수 있다.
          // showDialog(context: context, builder: (context){
          //   return Dialog(
          //       child: Text('안녕')
          //   );
          // });
        // },
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return DialogUI(state: a, state2: name, incrementState: incrementState, addOne: addOne);
            },
          );
        },
      ),
      appBar: AppBar(
        title: Text('연락처 앱 $total'),
      ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text(name[index]), // 변수 a를 텍스트에 표시
                Text(like[index].toString())
              ],
            ),
            leading: Icon(Icons.account_circle),
            trailing: TextButton(child: Text('좋아요'), onPressed: (){
              setState(() {
                like[index]++; // 버튼을 눌렀을 때 변수 a의 값을 증가시킴
              });
            },),
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
  DialogUI({super.key, required this.state, required this.state2, required this.incrementState, this.addOne});

  final int state; // state를 숫자로 선언
  final List<String> state2;
  final VoidCallback incrementState;
  final addOne;
  var inputData = TextEditingController();
  var inputData2 = '';
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
              // controller: inputData,
              onChanged: (text){inputData2 = text; print(inputData2); },
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
                  onPressed: () {
                    incrementState();
                    addOne();
                    // 확인 버튼을 눌렀을 때 실행할 코드 작성
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
