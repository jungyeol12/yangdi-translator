import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Colors.dart';
import 'menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '양디 번역기',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MainPage(),
    );
  }
}

// 메인 화면 구현
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _textController = TextEditingController();
  String _translatedText = ""; // 번역된 텍스트를 저장하는 변수
  List<String> translatedTexts = []; // 번역 기록을 저장할 배열
  final int maxTranslations = 10; // 최대 번역 기록 개수

  String dropDownValue = ""; // 드롭다운에서 선택한 값을 저장할 변수
  String buttonTxt = "한국어로 번역";


  Future<void> _translateText(String text, String targetLanguage) async {
    final apiKey = 'AIzaSyAYeti4omvBQBOi9rql1lIaGlOybHaasB0'; // Google API Key
    final url = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?key=$apiKey');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'q': text,
        'target': targetLanguage,
      }),
    );


    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _translatedText = responseData['data']['translations'][0]['translatedText'];


      });
    } else {
      throw Exception('텍스트 번역 실패'); // 번역 실패
    }
  }

  // 번역 기록 추가 & 삭제 함수
  void _addTranslation() {
    setState(() {
      // 번역 기록 배열에 번역 결과 추가
      translatedTexts.add(_translatedText);

      // 최대 번역 기록 개수를 초과하면 첫 번째 항목 제거
      if (translatedTexts.length > maxTranslations) {
        translatedTexts.removeAt(0);
      }
    });
  }

  // 드롭 다운 메뉴를 클릭함에 따라 버튼 메시지가 바뀌도록 하는 함수
  void buttonMsg() {
    if (dropDownValue == "ko") {
      buttonTxt = "한국어로 번역";
    } else if (dropDownValue == "en") {
      buttonTxt = "영어로 번역";
    } else if (dropDownValue == "ja") {
      buttonTxt = "일본어로 번역";
    } else if (dropDownValue == "zh-CN") {
      buttonTxt = "중국어로 번역";
    } else {
      buttonTxt = "NULL";
    }
  }

  Widget translateLang() {
    // 드롭다운 리스트
    final Map<String, String> dropDownMap = {
      'ko': '한국어',
      'en': '영어',
      'ja': '일본어',
      'zh-CN': '중국어(간체)',
    };

    // 초기값 설정
    if (dropDownValue == "") {
      dropDownValue = dropDownMap.keys.first; // dropDownValue가 비어있다면 dropDownList의 첫 번째 값을 dropDownValue에 저장.
    }

    // DropDownButton return
    return DropdownButton<String>(
      value: dropDownValue, // 처음 보여줄 값 : ko
      // 드롭다운의 리스트를 보여줄 값: en, ja, zh-CH
      items: dropDownMap.entries.map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Text(entry.value),
        );
    }).toList(),
      // 드롭다운의 값을 선택했을 경우
      onChanged: (String? value) {
        setState(() {
          dropDownValue = value!;
          buttonMsg();
        });
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuScreen()),
            );
          }
        ),
        title: Row(
          children: [
            Image.asset('assets/logo.png'),
            Text(
              "양디 번역기",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: color12,
      ),

      body: Container(
        color: white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      translateLang()
                    ],
                  ),
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(labelText: '번역할 내용을 입력하세요.'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTranslation();
                _translateText(_textController.text, dropDownValue); // 드롭다운에서 선택한 값으로 번역,
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color11)),
              child: Text(buttonTxt, style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: _translatedText))
                    .then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('텍스트가 클립보드에 복사되었습니다!')),
                  );
                });
              },
              child: Text(
                _translatedText,
                style: TextStyle(fontSize: 20,),
              ),
            ),
            Container(
              height: 500,
              child: ListView(
                children: List.generate(translatedTexts.length, (index) => Text(translatedTexts[index])),
              ),
            )
          ],
        ),
      ),
    );
  }
}
