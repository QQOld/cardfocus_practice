// 1 4 7 10 13 16 19
// 2 5 8 11 14 17 20
// 3 6 9 12 15 18 21
import 'package:flutter/material.dart';

List<Image> images =
    List.generate(22, (index) => Image.asset("assets/img/${index + 1}.png"));

/*class ImgCol extends StatefulWidget {
  const ImgCol(
      {required this.number,
      required this.animation,
      required this.controller,
      Key? key})
      : super(key: key);
  final int number;
  final Animation<double> animation;
  final AnimationController controller;

  @override
  _ImgColState createState() => _ImgColState();
}

class _ImgColState extends State<ImgCol> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.animation
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
        } else if (status == AnimationStatus.dismissed) {
          widget.controller.forward();
        }
      });
    widget.controller.forward();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
          7,
          (index) => Positioned(
                top: index * widget.animation.value,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 80,
                    maxWidth: 130,
                  ),
                  child: images[widget.number + index * 3],
                ),
              )),
    );
  }
}*/

class CardsDisplay extends StatefulWidget {
  const CardsDisplay({Key? key}) : super(key: key);

  @override
  _CardsDisplayState createState() => _CardsDisplayState();
}

class _CardsDisplayState extends State<CardsDisplay>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late Animation<double> shirtAnimation;
  late AnimationController controller;
  late Animation<double> curve;
  late Animation<double> secondMainAnimation;

  bool mainAnimIsCompleted = false;
  bool isCardChosen = true;
  int columnChoice = 0;
  int _choiceCount = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2500), vsync: this);
    shirtAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    secondMainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    curve = CurvedAnimation(parent: controller, curve: Curves.easeInCubic);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
  }

  void _changeToVertical() {
    setState(() {
      isCardChosen = false;
    });
    controller.forward();
  }

  void _chooseColumn(int num) {
    if (animation.isCompleted) {
      //почему не работает без if?
      controller.reverse();
    }
    Future.delayed(const Duration(milliseconds: 2500), () {
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
                    child: const Text(
                      "Ваша карта:",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
    } else if (isCardChosen) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 2500),
          curve: Curves.easeInCubic,
          builder: (_, double move, __) {
            return Stack(
                clipBehavior: Clip.none,
                children: [
              ...List.generate(
                  11,
                  (index) => Positioned(
                        width: 130,
                        top: 0,
                        left: move *
                            index *
                            MediaQuery.of(context).size.width *
                            (1/11),
                        child: images[index],
                      )),
              ...List.generate(
                  11,
                  (index) => Positioned(
                        width: 130,
                        top: 180,
                        left: move *
                            index *
                            MediaQuery.of(context).size.width *
                            (1/11),
                        child: images[index + 11]))
            ]
                /*List.generate(
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
                        )))*/

                );
          },
          onEnd: () => setState(() => mainAnimIsCompleted = true),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: mainAnimIsCompleted ? _changeToVertical : null,
          child: const Text("Сыграть"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          textDirection: TextDirection.ltr,
          children: List.generate(
            3,
            (num) => SizedBox(
              width: 130,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      clipBehavior: Clip.none,
                        children: [
                      ...List.generate(
                          7,
                          (index) => Positioned(
                                width: 130,
                                top: index *
                                    animation.value *
                                    MediaQuery.of(context).size.height *
                                    1/12,
                                // индекс (0..2) + 1 = номер колонки, умножение на 3 для правильного разложения карт(в каждый столбец по порядку, т.е. 1 столбец - 1, 4, 7...)
                                child: images[num + 1 + index * 3],
                              )),
                      Positioned(
                          width: 130,
                          top: -shirtAnimation.value * 205,
                          child: images[0])
                    ]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ElevatedButton(
                        onPressed: () => _chooseColumn(num + 1),
                        child: const Text("Выбрать")),
                  )
                ],
              ),
            ),
          )
          /*[
          SizedBox(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: List.generate(
                        7,
                        (index) => Positioned(
                              width: 130,
                              top: index * animation.value * MediaQuery.of(context).size.height/7 * 0.01,
                              child: images[1 + index * 3],
                            )),
                  ),
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
          SizedBox(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: List.generate(
                        7,
                        (index) => Positioned(
                              width: 130,
                              top: index * animation.value * MediaQuery.of(context).size.height/7 * 0.01,
                              child: images[2 + index * 3],
                            )),
                  ),
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
          SizedBox(
            width: 130,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: List.generate(
                        7,
                        (index) => Positioned(
                              width: 130,
                              top: index * animation.value * MediaQuery.of(context).size.height/7 * 0.01,
                              child: images[3 + index * 3],
                            )),
                  ),
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
        ],*/
          );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(const MaterialApp(
      title: 'Card Focus',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color.fromRGBO(69, 152, 66, 0.9),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
                child: CardsDisplay()
            ),
          ))));
}
