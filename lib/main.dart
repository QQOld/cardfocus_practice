import 'dart:math';

import 'package:flutter/material.dart';

const String version = "1.0.1";

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
    with TickerProviderStateMixin {
  late AnimationController startAnimController;
  late Animation<double> startAnimation;
  late Animation<double> animation;
  late Animation<double> shirtAnimation;
  late AnimationController controller; //Анимация сжатия/разжатия колонок
  late Animation<double> curve;
  late Animation<double> secondMainAnimation;

  bool mainAnimIsCompleted = false;
  bool isCardChoosing= true;
  bool isShuffling = false;
  bool isVisible = true;
  bool isRepeat = false;

  int columnChoice = 0;
  int _choiceCount = 0;
  int onWhichColumnPointerIs = 0;
  final columnAnimDuration = 1500;

  @override
  void initState() {
    super.initState();

    startAnimController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    startAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: startAnimController, curve: Curves.easeInQuad))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {});
        }
        /*if (status == AnimationStatus.dismissed && isRepeat) {
          setState(() {
            startAnimController.forward();
          });
        }*/
      });

    controller = AnimationController(
        duration: Duration(milliseconds: columnAnimDuration), vsync: this);
    shirtAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    secondMainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInCubic))
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
    return MediaQuery.of(context).size.height < 661 ||
        MediaQuery.of(context).size.width < 661
        ? min(MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height) /
        5
        : 130;
  }

  double calcCardHeight(BuildContext context) {
    return calcCardSize(context) * (346 / 248);
  }

  void updateCursorCoord(PointerEvent details) {
    double position = (MediaQuery.of(context).size.width)/details.position.dx;
    setState(() {
      if(!animation.isCompleted || details.position.dy > 6/12 * (MediaQuery.of(context).size.height) + calcCardHeight(context) + 40){
        onWhichColumnPointerIs = 0;
      } else if(position >= 8/3) {
        onWhichColumnPointerIs = 1;
      } else if(position >= 8/5) {
        onWhichColumnPointerIs = 2;
      } else if(position >= 1) {
        onWhichColumnPointerIs = 3;
      } else {
        onWhichColumnPointerIs = 0;
      }
    });
  }

  double calcPointerPosition(BuildContext context, int column) {
    return (MediaQuery.of(context).size.width / 4) * onWhichColumnPointerIs -
        calcCardSize(context) / 2;
  }

  void _changeToVertical() {
    setState(() {
      isCardChoosing = false;
    });
    controller.forward();
  }

  void _chooseColumn(int num) {
    if (animation.isCompleted) {
      onWhichColumnPointerIs = 0;
      //почему не работает без if?
      controller.reverse();
    }
    Future.delayed(Duration(milliseconds: columnAnimDuration + 1700), () {
      setState(() {
        _choiceCount++;
        columnChoice = num;

        ShuffleCalc.shuffleAfterChoice(columnChoice);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_choiceCount == 3) {
      return Container(
        padding: const EdgeInsets.all(5),
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 3000),
            builder: (_, double move, __) {
              return Opacity(
                opacity: move,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height <= 500
                              ? 5
                              : 20),
                      child: Text(
                        "Я же говорил",
                        style: TextStyle(
                          fontFamily: "ComicSansMS",
                          fontSize: MediaQuery.of(context).size.height <= 500
                              ? 18 * move
                              : 26 * move,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 7),
                      width: (calcCardSize(context) + 50) * move,
                      child: images[11],
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      hoverColor: Colors.white30.withOpacity(0.1),
                      onTap: move == 1.0
                          ? () => setState(() {
                        isCardChoosing = true;
                        columnChoice = 0;
                        _choiceCount = 0;
                        controller.reset();
                        startAnimController.reset();
                        startAnimController.forward();
                      })
                          : null,
                      child: Container(
                        padding: EdgeInsets.all(6 * move),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12 * move,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            fontFamily: "ComicSansMS",
                            letterSpacing: 1.4 * move,
                          ),
                          child: const Text(
                            "Сыграем ещё",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      );
    } else if (isCardChoosing) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              AnimatedContainer(
                // key: Key("Button$isVisible"),
                duration: const Duration(milliseconds: 1000),
                clipBehavior: Clip.hardEdge,
                constraints: const BoxConstraints(minHeight: 0, maxHeight: 320),
                width: MediaQuery.of(context).size.width <= 660 ||
                    MediaQuery.of(context).size.height <= 660
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.7,
                height: isVisible ? null : 0,
                padding: EdgeInsets.all(
                    MediaQuery.of(context).size.width <= 660 ||
                        MediaQuery.of(context).size.height <= 660
                        ? 8
                        : 20),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                        blurStyle: BlurStyle.outer)
                  ],
                ),
                child: Column(
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                            color: Colors.transparent
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Text(
                            "Привет, я бы хотел продемонстрировать тебе свои телепатические силы. Не веришь? Я докажу тебе это, если ты сыграешь со мной в мини игру."
                            "Тебе лишь надо загадать одну карту иp тех, что ты увидишь на экране. Потом 3 раза выбери колонку, в которой находится твоя карта. Всё просто.",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                                backgroundColor: Colors.transparent,
                                overflow: TextOverflow.clip,
                                color: Colors.white,
                                fontFamily: 'ComicSansMS',
                                fontStyle: FontStyle.italic,
                                fontSize: MediaQuery.of(context).size.height <
                                    660 ||
                                    MediaQuery.of(context).size.width < 660
                                    ? 14
                                    : 16)),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: OutlinedButton(
                          clipBehavior: Clip.hardEdge,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(Size.zero),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 12)),
                            backgroundColor:
                            MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.hovered)) {
                                  return Colors.white.withOpacity(0.1);
                                }
                                return Colors.transparent;
                              },
                            ),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(width: 3.0, color: Colors.white),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isVisible = false;
                              Future.delayed(const Duration(milliseconds: 1000),
                                      () {
                                    startAnimController.forward();
                                  });
                            });
                          },
                          child: Text(
                            "Поехали",
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              overflow: TextOverflow.clip,
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width <=
                                  660 ||
                                  MediaQuery.of(context).size.height <= 660
                                  ? 12
                                  : 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              fontFamily: "ComicSansMS",
                              letterSpacing: 1.5,
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(),
                  ...List.generate(
                      11,
                          (index) => AnimatedPositioned(
                        duration: const Duration(milliseconds: 800),
                        width: calcCardSize(context),
                        top: 0,
                        left: startAnimation.value *
                            index *
                            (MediaQuery.of(context).size.width - calcCardSize(context)) *
                            (1 / 11),
                        child: images[index + 11],
                      )),
                  ...List.generate(
                      11,
                          (index) => AnimatedPositioned(
                          duration: const Duration(milliseconds: 800),
                          width: calcCardSize(context),
                          top: isVisible
                              ? 0
                              : MediaQuery.of(context).size.height > 500
                              ? 180
                              : MediaQuery.of(context).size.height -
                              calcCardHeight(context) -
                              160,
                          left: startAnimation.value *
                              index *
                              (MediaQuery.of(context).size.width - calcCardSize(context)) *
                              (1 / 11),
                          child: images[10 - index]))
                ]),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          borderRadius: BorderRadius.circular(10),
          hoverColor: Colors.white30.withOpacity(0.1),
          onTap: startAnimation.isCompleted ? _changeToVertical : null,
          child: AnimatedContainer(
            padding: EdgeInsets.all(isVisible ? 5 : 8),
            decoration: BoxDecoration(
              border: Border.all(
                  color:
                  isVisible ? Colors.white.withOpacity(0.2) : Colors.white,
                  width: 3),
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(milliseconds: 2000),
            child: AnimatedDefaultTextStyle(
              style: TextStyle(
                color: isVisible ? Colors.white.withOpacity(0.2) : Colors.white,
                fontSize: isVisible ? 14 : 22,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: "ComicSansMS",
                letterSpacing: isVisible ? 1 : 2.5,
              ),
              duration: const Duration(milliseconds: 2800),
              child: const Text(
                "Сыграем",
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GestureDetector(
            onTap: onWhichColumnPointerIs == 0
                ? null
                : () {
              _chooseColumn(onWhichColumnPointerIs);
              onWhichColumnPointerIs = 0;
            },
            child: MouseRegion(
              cursor: onWhichColumnPointerIs == 0 ? SystemMouseCursors.basic : SystemMouseCursors.click,
              onHover: controller.isAnimating ? null : updateCursorCoord,
              onExit: (exit) => setState(
                      () => onWhichColumnPointerIs = 0),
              child: Stack(
                  clipBehavior: Clip.none,
                  textDirection: TextDirection.ltr,
                  children: [
                    Container(),
                    Positioned(
                        top: MediaQuery.of(context).size.height * (6 / 12) +
                            calcCardHeight(context) +
                            calcCardHeight(context) / 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 1200),
                            opacity: isShuffling ? 0 : 1,
                            child: Text(
                              "Выбери колонку",
                              style: TextStyle(
                                color: isVisible
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.white,
                                fontSize:
                                MediaQuery.of(context).size.height < 500 ||
                                    MediaQuery.of(context).size.width < 500
                                    ? 14
                                    : 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w600,
                                fontFamily: "ComicSansMS",
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        )),
                    ...List.generate(
                      3,
                          (num) => AnimatedPositioned(
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOutSine,
                        top: 0,
                        bottom: (MediaQuery.of(context).size.height - 70) -
                            (6/12) * MediaQuery.of(context).size.height -
                            calcCardHeight(context),
                        left: isShuffling
                            ? MediaQuery.of(context).size.width / 2 -
                            calcCardSize(context) / 2
                            : MediaQuery.of(context).size.width / 4 * (num + 1) -
                            calcCardSize(context) / 2,
                        width: calcCardSize(context),
                        // Стек всей колонки
                        child: /*Stack(clipBehavior: Clip.none, children: [
                          Container(),*/
                        // Стек колонки карт
                        GestureDetector(
                          onTap:  () {
                            _chooseColumn(num + 1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: num + 1 == onWhichColumnPointerIs && animation.isCompleted
                                    ? const [
                                  BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 17,
                                      blurStyle: BlurStyle.outer)
                                ]
                                    : null),
                            child: Stack(clipBehavior: Clip.none, children: [
                              Container(),
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
                                    /*MouseRegion(
                                          onEnter: animation.isCompleted
                                              ? (enter) => setState(() =>
                                                  onWhichColumnPointerIs = num + 1)
                                              : null,
                                          onExit: (exit) => setState(
                                              () => onWhichColumnPointerIs = 0),
                                          child: GestureDetector(
                                            child: images[num + 1 + index * 3],
                                            onTap: () {
                                              onWhichColumnPointerIs = 0;
                                              _chooseColumn(num + 1);
                                            },
                                          ),
                                        ),*/
                                  )),
                              Positioned(
                                  width: calcCardSize(context),
                                  top: -shirtAnimation.value * 205,
                                  child: images[0]),
                            ]),
                          ),
                        ),
                        /*Positioned(
                              width: calcCardSize(context),
                              top: -shirtAnimation.value * 205,
                              child: images[0]),*/
                        /*]),*/
                      ),
                    ),
                    //Палец
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 500),
                      width: calcCardSize(context) - 30,
                      bottom: onWhichColumnPointerIs == 0
                          ? -210
                          : MediaQuery.of(context).size.height / 13,
                      left: onWhichColumnPointerIs == 0
                          ? MediaQuery.of(context).size.width / 2 - 40
                          : calcPointerPosition(context, onWhichColumnPointerIs),
                      child: const Image(
                        image: AssetImage("assets/finger.png"),
                        repeat: ImageRepeat.noRepeat,
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    startAnimController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
      title: 'Card Focus',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromRGBO(69, 152, 66, 0.9),
          body: const Center(
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CardsDisplay()),
          ),
        bottomNavigationBar: Stack(
          alignment: Alignment.bottomRight,
          children: const [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                version,
                style: TextStyle(
                      backgroundColor: Colors.transparent,
                      color: Colors.white,
                      fontFamily: 'ComicSansMS',
                      fontStyle: FontStyle.italic,
                      fontSize: 14)
              ),
            ),
          ],
        ),
      )
  )
  );
}