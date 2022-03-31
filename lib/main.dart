// 1 4 7 10 13 16 19
// 2 5 8 11 14 17 20
// 3 6 9 12 15 18 21
import 'dart:math';

import 'package:flutter/material.dart';

List<Image> images =
    List.generate(22, (index) => Image.asset("assets/img/${index + 1}.png"));

class ShuffleCalc {
  static List<Image> createHelpList() {
    List<Image> helpList = List.generate(22, (index) => images[index]);
    for (int i = 0; i <= 2; i++) {
      for (int j = i * 7 + 1, k = 1 + i; j <= 7 + i * 7; j++, k += 3) {
        helpList[j] = images[k];
      }
    }
    return helpList;
  }

  static void shuffleAfterChoice(int column) {
    List<Image> helpList = createHelpList();
    Image a;
    switch (column) {
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
  }
}

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
  bool isShuffling = false;
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
          isShuffling = true;
          Future.delayed(const Duration(milliseconds: 1700), () {
            setState(() {
              isShuffling = false;
            });
            Future.delayed(const Duration(milliseconds: 1700), () {
              controller.forward();
            });
          });
        }
      });
  }

  double calcCardSize(BuildContext context) {
    return MediaQuery.of(context).size.height < 520 ||
            MediaQuery.of(context).size.width < 520
        ? min(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height) /
            4
        : 130;
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

        ShuffleCalc.shuffleAfterChoice(columnChoice);
        /*Image a;
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
        }*/
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2500),
            curve: Curves.easeInCubic,
            builder: (_, double move, __) {
              return Stack(clipBehavior: Clip.none, children: [
                ...List.generate(
                    11,
                    (index) => Positioned(
                          width: calcCardSize(context),
                          top: 0,
                          left: move *
                              index *
                              (MediaQuery.of(context).size.width - 130) *
                              (1 / 11),
                          child: images[index],
                        )),
                ...List.generate(
                    11,
                    (index) => Positioned(
                        width: calcCardSize(context),
                        top: MediaQuery.of(context).size.height > 400
                            ? 180
                            : MediaQuery.of(context).size.height - 220,
                        left: move *
                            index *
                            (MediaQuery.of(context).size.width - 130) *
                            (1 / 11),
                        child: images[index + 11]))
              ]);
            },
            onEnd: () => setState(() => mainAnimIsCompleted = true),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: mainAnimIsCompleted ? _changeToVertical : null,
          child: const Text("Сыграть"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
              clipBehavior: Clip.none,
              textDirection: TextDirection.ltr,
              children: List.generate(
                3,
                (num) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeOutSine,
                  left: isShuffling
                      ? MediaQuery.of(context).size.width / 2 -
                          calcCardSize(context) / 2
                      : MediaQuery.of(context).size.width / 4 * (num + 1) -
                          calcCardSize(context) / 2,
                  width: calcCardSize(context),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          ...List.generate(
                              7,
                              (index) => Positioned(
                                    width: calcCardSize(context),
                                    top: index *
                                        animation.value *
                                        MediaQuery.of(context).size.height *
                                        1 /
                                        12,
                                    // индекс (0..2) + 1 = номер колонки, умножение на 3 для правильного разложения карт(в каждый столбец по порядку, т.е. 1 столбец - 1, 4, 7...)
                                    child: images[num + 1 + index * 3],
                                  )),
                          Positioned(
                              width: calcCardSize(context),
                              top: -shirtAnimation.value * 205,
                              child: images[0]),
                          Positioned(
                            width: 100,
                            bottom: 50,
                            child: IconButton(
                              onPressed: () => _chooseColumn(num + 1),
                              icon: const Image(
                                  image: AssetImage("assets/finger.png")),
                              iconSize: 100,
                              color: Colors.transparent,
                              hoverColor: Colors.transparent,
                            ),
                          ),
                        ]),
                  ),
                ),
              )),
        ),
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
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CardsDisplay()),
          ))));
}
