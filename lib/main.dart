// 1 4 7 10 13 16 19
// 2 5 8 11 14 17 20
// 3 6 9 12 15 18 21
import 'package:flutter/material.dart';

List<Image> images =
    List.generate(22, (index) => Image.asset("assets/img/${index + 1}.png"));

/*class ImgRow extends StatelessWidget {
  const ImgRow({required this.number, Key? key}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) => images[number + index * 3]),
    );
  }
}*/

class ImgCol extends StatelessWidget {
  const ImgCol({required this.number, Key? key}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
          7,
          (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: images[number + index * 3])),
    );
  }
}

class CardsDisplay extends StatefulWidget {
  const CardsDisplay({Key? key}) : super(key: key);

  @override
  _CardsDisplayState createState() => _CardsDisplayState();
}

class _CardsDisplayState extends State<CardsDisplay> {
  bool isPlaying = false;
  int columnChoice = 0;
  int _choiceCount = 0;

  void _changeToVertical() {
    setState(() {
      isPlaying = true;
    });
  }

  void _chooseColumn(int num) {
    setState(() {
      _choiceCount++;
      columnChoice = num;
      Image a;
      List<Image> helpList = List.generate(22, (index) => images[index]);

      for(int i = 0; i <= 2; i++){
        for (int j = i*7 + 1, k = 1 + i; j <= 7 + i*7; j++, k+=3) {
          helpList[j] = images[k];
        }
      }

      switch (columnChoice) {
        case 1:
          for(int i = 1; i <= 7; i++){
            a = helpList[i];
            helpList[i] = helpList[i + 7];
            helpList[i + 7] = a;
          }
          for(int i = 1; i <= 21; i++){
            images[i] = helpList[i];
          }
          break;
        case 2:
          for(int i = 1; i <= 21; i++){
            images[i] = helpList[i];
          }
          break;
        case 3:
          for(int i = 8; i <= 14; i++){
            a = helpList[i];
            helpList[i] = helpList[i + 7];
            helpList[i + 7] = a;
          }
          for(int i = 1; i <= 21; i++){
            images[i] = helpList[i];
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_choiceCount == 3){
      return AnimatedContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: const Text("Ваша карта:", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
            Container(
              child: images[11],
            ),
          ],
        ),
        duration: const Duration(seconds: 5),
      );
    }
    else if (isPlaying == false) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
        child: Column(
          children: [
            Wrap(
              direction: Axis.horizontal,
              spacing: 50.0, // gap between adjacent chips
              runSpacing: 30.0, // gap between lines,
              children: List.generate(21, (index) =>
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 70,
                      maxHeight: 200,
                    ),
                    child: images[index + 1],
                  )
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: ElevatedButton(
                  onPressed: _changeToVertical, child: const Text("Сыграть")),
            ),
          ],
        ),
      );
      /*return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: const ImgRow(number: 1),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: const ImgRow(number: 2),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: const ImgRow(number: 3),
            ),
            ElevatedButton(
                onPressed: _changeToVertical, child: const Text("Сыграть")),
          ],
        ),
      );*/
    } else {
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              width: 108,
              child: Column(
                children: [
                  ImgCol(number: 1),
                  ElevatedButton(
                      onPressed: () => _chooseColumn(1),
                      child: const Text("Выбрать")),
                ],
              ),
            ),
            Container(
              width: 108,
              child: Column(
                children: [
                  ImgCol(number: 2),
                  ElevatedButton(
                      onPressed: () => _chooseColumn(2),
                      child: const Text("Выбрать")),
                ],
              ),
            ),
            Container(
              width: 108,
              child: Column(
                children: [
                  ImgCol(number: 3),
                  ElevatedButton(
                      onPressed: () => _chooseColumn(3),
                      child: const Text("Выбрать")),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

void main() {
  runApp(const MaterialApp(
      title: 'Card Focus',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: CardsDisplay(),
        ),
      )));
}
