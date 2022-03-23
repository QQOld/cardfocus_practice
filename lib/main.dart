import 'package:flutter/material.dart';


class ImgRow extends StatelessWidget {
  ImgRow({required this.number ,Key? key}) : super(key: key);
  final List<Image> images = List.generate(22, (index) => Image.asset("assets/img/${index+1}.png"));
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        images[1 + number * 7],
        images[2 + number * 7],
        images[3 + number * 7],
        images[4 + number * 7],
        images[5 + number * 7],
        images[6 + number * 7],
        images[7 + number * 7],
      ],
    );
  }
}

class ImgCol extends StatelessWidget {
  ImgCol({required this.number ,Key? key}) : super(key: key);
  final List<Image> images = List.generate(22, (index) => Image.asset("assets/img/${index+1}.png"));
  final int number;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        images[1 + number * 7],
        images[2 + number * 7],
        images[3 + number * 7],
        images[4 + number * 7],
        images[5 + number * 7],
        images[6 + number * 7],
        images[7 + number * 7],
      ],
    );
  }
}

class CardsDisplay1 extends StatefulWidget {
  const CardsDisplay1 ({Key? key}) : super(key: key);

  @override
  _CardsDisplay1State createState() => _CardsDisplay1State();
}

class _CardsDisplay1State extends State<CardsDisplay1> {

  bool isVertical = false;

  void _changeToVertical() {
    setState(() {
      isVertical = true;
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
              child: ImgRow(number: 0),
            ),
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
            ElevatedButton(onPressed: _changeToVertical, child: const Text("Сыграть")),
          ],
        ),
      );
    }
    else{
      return Container(
        padding: const EdgeInsets.all(40),
        child: Expanded(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            textDirection: TextDirection.ltr,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 108,
                child: ImgCol(number: 0),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 108,
                child: ImgCol(number: 1),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 108,
                child: ImgCol(number: 2),
              ),
            ],
          ),
        )
      );
    }

  }
}


class CardsDisplay extends StatelessWidget {
  const CardsDisplay({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        textDirection: TextDirection.ltr,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 150,
            child: ImgRow(number: 0),
          ),
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
      title: 'Card Focus',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: const [
              CardsDisplay1(),
            ],
          ),
        ),
      )));
}
