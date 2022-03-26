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
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0.0, end: 60),
        duration: const Duration(milliseconds: 2000),
        onEnd: () {},
        builder: (_, double move, __) {
          return Stack(
            children: List.generate(
                7,
                (index) => Positioned(
                      top: index * move,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 80,
                          maxWidth: 130,
                        ),
                        child: images[number + index * 3],
                      ),
                    )),
          );
        });
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

      for (int i = 0; i <= 2; i++) {
        for (int j = i * 7 + 1, k = 1 + i; j <= 7 + i * 7; j++, k += 3) {
          helpList[j] = images[k];
        }
      }

      switch (columnChoice) {
        case 1:
          for (int i = 1; i <= 7; i++) {
            a = helpList[i];
            helpList[i] = helpList[i + 7];
            helpList[i + 7] = a;
          }
          for (int i = 1; i <= 21; i++) {
            images[i] = helpList[i];
          }
          break;
        case 2:
          for (int i = 1; i <= 21; i++) {
            images[i] = helpList[i];
          }
          break;
        case 3:
          for (int i = 8; i <= 14; i++) {
            a = helpList[i];
            helpList[i] = helpList[i + 7];
            helpList[i + 7] = a;
          }
          for (int i = 1; i <= 21; i++) {
            images[i] = helpList[i];
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_choiceCount == 3) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 3000),
            builder: (_, double opacity, __) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text("Ваша карта:",
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                  ),
                  Opacity(
                    opacity: opacity,
                    child: Container(
                      child: images[11],
                    ),
                  )
                ],
              );
            }),
      );
    } else if (!isPlaying) {
      return Scaffold(
        body: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 70.0),
          duration: const Duration(milliseconds: 2000),
          builder: (_, double move, __){
            return Stack(
              children: List.generate(
                  21,
                      (index) => Positioned(
                      top: index < 10 ? 0 : 180,
                      left: index < 10 ? move * index : move * index - move * 10,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 80,
                          maxWidth: 130,
                        ),
                        child: images[index + 1],
                      ))),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(

          onPressed: _changeToVertical,
          label: const Text("Сыграть"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        textDirection: TextDirection.ltr,
        children: [
          Container(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: ImgCol(number: 1),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                      onPressed: () => _chooseColumn(1),
                      child: const Text("Выбрать")),
                )
              ],
            ),
          ),
          Container(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: ImgCol(number: 2),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                      onPressed: () => _chooseColumn(2),
                      child: const Text("Выбрать")),
                ),
              ],
            ),
          ),
          Container(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: ImgCol(number: 3),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                      onPressed: () => _chooseColumn(3),
                      child: const Text("Выбрать")),
                ),
              ],
            ),
          ),
        ],
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
