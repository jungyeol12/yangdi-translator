import 'package:flutter/material.dart';
import 'Colors.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<String> translatedTexts = []; // 번역 기록을 저장할 배열
  final int maxTranslations = 10; // 최대 번역 기록 개수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton( // 뒤로가기 아이콘
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // 뒤로가기 버튼 클릭 시 이전 화면으로 이동
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Image.asset('assets/logo.png'),
            Text(
              "메뉴",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: color12,
      ),
      body: Container(
        color: white,
        child: Text("메뉴입니다.")
      )
    );
  }
}