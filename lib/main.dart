import 'package:flutter/material.dart';

class ImgRow extends StatelessWidget {
  const ImgRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class CardsDisplay extends StatelessWidget {
  CardsDisplay({Key? key}) : super(key: key);

  final List<Image> images = List.generate(22, (index) => Image.asset("assets/img/${index+1}.png"));

  Widget _buildRow(int number) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Row(
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
      ),
    );
  }

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
            child: _buildRow(0),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            height: 150,
            child: _buildRow(1),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            height: 150,
            child: _buildRow(2),
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
            children: [
              CardsDisplay(),
              const ElevatedButton(onPressed: null, child: Text("Сыграть"))
            ],
          ),
        ),
      )));
}
