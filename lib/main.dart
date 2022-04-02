// 1 4 7 10 13 16 19
// 2 5 8 11 14 17 20
// 3 6 9 12 15 18 21
import 'dart:math';

import 'package:flutter/material.dart';

List<Image> images =
    List.generate(22, (index) => Image.asset("assets/img/${index + 1}.png"));

class HelloText extends StatefulWidget {
  const HelloText({Key? key}) : super(key: key);

  @override
  _HelloTextState createState() => _HelloTextState();
}

class _HelloTextState extends State<HelloText> {
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      duration: const Duration(milliseconds: 1000),
      child: isVisible
          ? AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              constraints: const BoxConstraints(minHeight: 0, maxHeight: 400),
              width: MediaQuery.of(context).size.width * 0.7,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 35),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Text(
                        "Привет, я бы хотел продемонстрировать тебе свои телепатические силы. Не веришь? Я докажу тебе это, если ты сыграешь со мной в мини игру."
                        "Тебе лишь надо загадать одну карту их тех, что ты видишь. Потом 3 раза выбери колонку, в которой находится твоя карта. Всё просто.",
                        style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            fontSize:
                                MediaQuery.of(context).size.height < 660 ||
                                        MediaQuery.of(context).size.width < 660
                                    ? 14
                                    : 16)),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isVisible = false;
                        });
                      },
                      child: const Text("Поехали"))
                ],
              ),
            )
          : Container(),
    );
  }
}

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
  bool isCardChosen = true;
  bool isShuffling = false;
  bool isVisible = true;

  int columnChoice = 0;
  int _choiceCount = 0;
  int onWhichColumnPointerIs = 0;
  final columnAnimDuration = 1500;

  @override
  void initState() {
    super.initState();

    startAnimController = AnimationController(
        duration: const Duration(milliseconds: 1100), vsync: this);
    startAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: startAnimController, curve: Curves.easeInQuad))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {});
        }
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

  double calcPointerPosition(BuildContext context, int column) {
    return (MediaQuery.of(context).size.width / 4) * onWhichColumnPointerIs -
        calcCardSize(context) / 2;
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
        padding: const EdgeInsets.all(20),
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 3000),
            builder: (_, double opacity, __) {
              return Opacity(
                opacity: opacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height <= 500 ? 5 : 20),
                      child: Text(
                        "Я же говорил",
                        style: TextStyle(
                          fontFamily: "ComicSansMS",
                          fontSize: MediaQuery.of(context).size.height <= 500 ? 18*opacity : 26*opacity,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: (calcCardSize(context) + 60)*opacity,
                      child: images[11],
                    )
                  ],
                ),
              );
            }),
      );
    } else if (isCardChosen) {
      /*return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              //HelloText(isReady: isReady),
              Flexible(
                flex: 1,
                child: TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 2500),
                  curve: Curves.easeInCubic,
                  builder: (_, double move, __) {
                    return Stack(clipBehavior: Clip.none, children: [
                      Container(),
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
                              top: MediaQuery.of(context).size.height > 660
                                  ? 180
                                  : MediaQuery.of(context).size.height - calcCardHeight(context) - 300,
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
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: mainAnimIsCompleted ? _changeToVertical : null,
          child: const Text("Сыграть"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );*/
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              AnimatedSwitcher(
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                duration: const Duration(milliseconds: 1000),
                child: isVisible
                    ? AnimatedContainer(
                        duration: const Duration(milliseconds: 1000),
                        constraints:
                            const BoxConstraints(minHeight: 0, maxHeight: 400),
                        width: MediaQuery.of(context).size.width <= 660 || MediaQuery.of(context).size.height <= 660
                            ? MediaQuery.of(context).size.width * 0.9
                            : MediaQuery.of(context).size.width * 0.7,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width <= 660 || MediaQuery.of(context).size.height <= 660 ? 8 : 20),
                        margin: const EdgeInsets.only(bottom: 25),
                        decoration: BoxDecoration(
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                  "Привет, я бы хотел продемонстрировать тебе свои телепатические силы. Не веришь? Я докажу тебе это, если ты сыграешь со мной в мини игру."
                                  "Тебе лишь надо загадать одну карту иp тех, что ты увидишь на экране. Потом 3 раза выбери колонку, в которой находится твоя карта. Всё просто.",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'ComicSansMS',
                                      fontStyle: FontStyle.italic,
                                      fontSize:
                                          MediaQuery.of(context).size.height <
                                                      660 ||
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width <
                                                      660
                                              ? 14
                                              : 16)),
                            ),
                            OutlinedButton(
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 15, horizontal: 12)),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.hovered)) {
                                        return Colors.white.withOpacity(0.1);
                                      }
                                      return null;
                                    },
                                  ),
                                  side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        width: 3.0, color: Colors.white),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    isVisible = false;
                                    Future.delayed(
                                        const Duration(milliseconds: 1100), () {
                                      startAnimController.forward();
                                    });
                                  });
                                },
                                child: Text(
                                  "Поехали",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width <= 660 || MediaQuery.of(context).size.height <= 660 ? 12 : 14,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "ComicSansMS",
                                    letterSpacing: 1.5,
                                  ),
                                ))
                          ],
                        ),
                      )
                    : Container(),
              ),
              Flexible(
                flex: 1,
                child: Stack(clipBehavior: Clip.none, children: [
                  Container(),
                  ...List.generate(
                      11,
                      (index) => AnimatedPositioned(
                            duration: const Duration(milliseconds: 900),
                            width: calcCardSize(context),
                            top: 0,
                            left: startAnimation.value *
                                index *
                                (MediaQuery.of(context).size.width - 130) *
                                (1 / 11),
                            child: images[index + 11],
                          )),
                  ...List.generate(
                      11,
                      (index) => AnimatedPositioned(
                          duration: const Duration(milliseconds: 900),
                          width: calcCardSize(context),
                          top: isVisible
                              ? 0 : MediaQuery.of(context).size.height > 500
                                ? 180
                                : MediaQuery.of(context).size.height -
                                    calcCardHeight(context) -
                                    160,
                          left: startAnimation.value *
                              index *
                              (MediaQuery.of(context).size.width - 130) *
                              (1 / 11),
                          child: images[10 - index]))
                ]),
              ),
            ],
          ),
        ),
        floatingActionButton: OutlinedButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15)),
              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered) &&
                      startAnimation.isCompleted) {
                    return Colors.white.withOpacity(0.1);
                  }
                  return Colors.transparent;
                },
              ),
              side: MaterialStateProperty.all<BorderSide>(
                const BorderSide(width: 3.0, color: Colors.white),
              ),
            ),
            onPressed: startAnimation.isCompleted ? _changeToVertical : null,
            child: const Text(
              "Сыграем",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
                fontFamily: "ComicSansMS",
                letterSpacing: 1.5,
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          // Стек всего экрана
          child: Stack(
              clipBehavior: Clip.none,
              textDirection: TextDirection.ltr,
              children: [
                Container(),
                ...List.generate(
                  3,
                  (num) => AnimatedPositioned(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutSine,
                    top: 0,
                    bottom: 0,
                    left: isShuffling
                        ? MediaQuery.of(context).size.width / 2 -
                            calcCardSize(context) / 2
                        : MediaQuery.of(context).size.width / 4 * (num + 1) -
                            calcCardSize(context) / 2,
                    width: calcCardSize(context),
                    // Стек всей колонкиа
                    child: Stack(clipBehavior: Clip.none, children: [
                      Container(),
                      // Стек колонки карт
                      Stack(clipBehavior: Clip.none, children: [
                        Container(),
                        Positioned(
                            top: 0,
                            bottom: MediaQuery.of(context).size.height -
                                MediaQuery.of(context).size.height * 6 / 12 -
                                calcCardHeight(context) -
                                40,
                            left: 0,
                            right: 0,
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: num + 1 == onWhichColumnPointerIs
                                        ? const [
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 10,
                                                blurStyle: BlurStyle.outer)
                                          ]
                                        : null))),
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
                                  child: MouseRegion(
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
                                  ),
                                )),
                      ]),
                      Positioned(
                          width: calcCardSize(context),
                          top: -shirtAnimation.value * 205,
                          child: images[0]),
                    ]),
                  ),
                ),
                //Палец
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  width: calcCardSize(context) - 30,
                  bottom: onWhichColumnPointerIs == 0
                      ? -180
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
