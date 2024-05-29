import 'package:flutter/material.dart';
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

  void _addTranslation() {
      // 번역 기록 배열에 번역 결과 추가
      translatedTexts.add(_translatedText);

      // 최대 번역 기록 개수를 초과하면 첫 번째 항목 제거
      if (translatedTexts.length > maxTranslations) {
        translatedTexts.removeAt(0);
      }

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
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: '번역할 내용을 입력하세요.'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _translateText(_textController.text, 'ko'); // 한국어로 번역},
                _addTranslation();
              },
              child: Text('한국어로 번역하기', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color11)),
            ),

            SizedBox(height: 20),
            Text(
              _translatedText,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
