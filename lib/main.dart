import 'package:flutter/material.dart';

List<Image> images = List.generate(22, (index) => Image.asset("assets/img/${index+1}.png"));

class ImgRow extends StatelessWidget {
  ImgRow({required this.number, Key? key}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
        List.generate(7, (index) => images[number + index * 3]),
        /*images[number + 0 * 3], // 1 4 7 10 13 16 19
        images[number + 1 * 3], // 2 5 8 11 14 17 20
        images[number + 2 * 3], // 3 6 9 12 15 18 21
        images[number + 3 * 3],
        images[number + 4 * 3],
        images[number + 5 * 3],
        images[number + 6 * 3],*/
    );
  }
}

class ImgCol extends StatelessWidget {
  ImgCol({required this.number ,Key? key}) : super(key: key);
  final int number;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:[
        Column(children: List.generate(7, (index) => Padding(padding: const EdgeInsets.symmetric(vertical: 15),
                                      child: images[number + index * 3]))),
      ]
    );
  }
}

class CardsDisplay extends StatefulWidget {
  const CardsDisplay ({Key? key}) : super(key: key);

  @override
  _CardsDisplayState createState() => _CardsDisplayState();
}

class _CardsDisplayState extends State<CardsDisplay> {

  bool isVertical = false;
  int columnChoice = 0;

  void _changeToVertical() {
    setState(() {
      isVertical = true;
    });
  }

  void _chooseColumn(int num) {
    setState(() {
      columnChoice = num;
      Image a;
      switch(columnChoice){
        case 1:
          for(int i = 1;i <= 19; i+=3){
            a = images[i];
            images[i] = images[i + 1];
            images[i + 1] = a;
          }
          break;
        case 3:
          for(int i = 2;i <= 20; i+=3){
            a = images[i];
            images[i] = images[i + 1];
            images[i + 1] = a;
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    if(isVertical == false){
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: ImgRow(number: 1),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: ImgRow(number: 2),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              height: 150,
              child: ImgRow(number: 3),
            ),
            ElevatedButton(onPressed: _changeToVertical, child: const Text("Сыграть")),
          ],
        ),
      );
    }
    else{
      return Container(
        child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textDirection: TextDirection.ltr,
            children: [
              Container(
                width: 108,
                child: Column(
                  children: [
                    ImgCol(number: 1),
                    ElevatedButton(onPressed: () => _chooseColumn(1), child: const Text("Выбрать")),
                  ],
                ),
              ),
              Container(
                width: 108,
                child: Column(
                  children: [
                    ImgCol(number: 2),
                    ElevatedButton(onPressed: () => _chooseColumn(2), child: const Text("Выбрать")),
                  ],
                ),
              ),
              Container(
                width: 108,
                child: Column(
                  children: [
                    ImgCol(number: 3),
                    ElevatedButton(onPressed: () => _chooseColumn(3), child: const Text("Выбрать")),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
              CardsDisplay(),
          ),
        ),
      )));
}
