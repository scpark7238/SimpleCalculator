import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MemorizeNumber extends StatefulWidget {
  const MemorizeNumber({Key? key}) : super(key: key);

  @override
  State<MemorizeNumber> createState() => _MemorizeNumberState();
}

enum GameState {
  ready,
  playing,
  end,
}

enum MemorizeNumberState {
  ready, // 대기
  showCorrectAnswer, // 정답 보여주기(2초)
  hideCorrectAnswer, // 정답 사라지기(0.25초)
  inputCorrectAnswer, // 정답 입력 대기
}

class _MemorizeNumberState extends State<MemorizeNumber> {
  late Timer mainTimer;
  double totalPlayTime = 30;
  double remainSecond = 30;
  String correctAnswer = '12345';
  MemorizeNumberState state = MemorizeNumberState.ready;
  GameState gameState = GameState.ready;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mainTimer.cancel();
    super.dispose();
  }

  _playGame() {
    if (gameState == GameState.ready) {
      setState(() {
        gameState = GameState.playing;
      });

      mainTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          remainSecond -= 1;
          if (remainSecond <= 0) {
            remainSecond = 0;
            timer.cancel();
          }
        });
      });
    }

    if (gameState != GameState.end) {
      _nextState();
    }
  }

  _nextState() {
    if (state == MemorizeNumberState.ready) {
      setState(() {
        state = MemorizeNumberState.showCorrectAnswer;
      });

      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          state = MemorizeNumberState.hideCorrectAnswer;
          timer.cancel();
        });
      });
    } else if (state == MemorizeNumberState.hideCorrectAnswer) {
      Timer.periodic(const Duration(milliseconds: 250), (timer) {
        setState(() {
          state = MemorizeNumberState.inputCorrectAnswer;
          correctAnswer = '';
          timer.cancel();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.redAccent,
              child: ElevatedButton(
                onPressed: () => _playGame(),
                child: Text('TimerStart'),
              ),
            ),
          ),
          buildMiddle(context),
          const SizedBox(height: 10),
          alarmMissionBoardBuilder(context, 343,
              child:
                  _buildMemorizeNumberCalc(context, onPressed: buttonPressed),
              padding: const EdgeInsets.fromLTRB(15, 11.5, 15, 0)),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildMiddle(BuildContext context) {
    return alarmMissionBoardBuilder(
      context,
      219,
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Column(
        children: [
          Opacity(
            opacity: 0.8,
            child: CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 10.0,
              animation: true,
              animateFromLastPercent: true,
              animationDuration: totalPlayTime.toInt() * 1000,
              percent: gameState == GameState.ready ? 0 : 1,
              backgroundColor: const Color(0xffff5934),
              progressColor: const Color(0xffbdbdbd),
              center: Text(
                '${remainSecond.toInt()}',
                style: const TextStyle(
                    color: Color(0xffff5934),
                    fontWeight: FontWeight.w900,
                    fontFamily: "NotoSansCJKKR",
                    fontSize: 40.0),
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            "5자리 숫자를 기억하세요.",
            style: TextStyle(
              color: Color(0xff000000),
              fontWeight: FontWeight.w700,
              fontFamily: "NotoSansCJKKR",
              fontSize: 20.0,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 54,
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.fromLTRB(31.5, 0, 31.5, 0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffbdbdbd),
                  width: 2,
                )),
            child: AnimatedOpacity(
              opacity:
                  state == MemorizeNumberState.hideCorrectAnswer ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 200),
              onEnd: () {
                _nextState();
              },
              child: Text(
                correctAnswer,
                style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w900,
                  fontFamily: "NotoSansCJKKR",
                  fontSize: 34.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buttonPressed(String buttonText) {
    if (state != MemorizeNumberState.inputCorrectAnswer) {
      return;
    }

    setState(() {
      if (buttonText == '⌫') {
        if (correctAnswer.isNotEmpty) {
          correctAnswer = correctAnswer.substring(0, correctAnswer.length - 1);
        }
      } else {
        if (correctAnswer.length < 5) {
          correctAnswer = correctAnswer + buttonText;
        }
      }
    });

    if (correctAnswer.length >= 5) {
      print('정답 제출');
    }
  }
}

Widget _buildMemorizeNumberCalc(BuildContext context,
    {required Function(String) onPressed}) {
  return Table(
    defaultColumnWidth: const FlexColumnWidth(),
    //border: TableBorder.all(),
    children: [
      TableRow(
        children: [
          buildButton(context, '1', onPressed: onPressed),
          buildButton(context, '2', onPressed: onPressed),
          buildButton(context, '3', onPressed: onPressed),
        ],
      ),
      TableRow(
        children: [
          buildButton(context, '4', onPressed: onPressed),
          buildButton(context, '5', onPressed: onPressed),
          buildButton(context, '6', onPressed: onPressed),
        ],
      ),
      TableRow(
        children: [
          buildButton(context, '7', onPressed: onPressed),
          buildButton(context, '8', onPressed: onPressed),
          buildButton(context, '9', onPressed: onPressed),
        ],
      ),
      TableRow(
        children: [
          const SizedBox(),
          buildButton(context, '0', onPressed: onPressed),
          buildButton(context, '⌫', onPressed: onPressed),
        ],
      ),
    ],
  );
}

Widget buildButton(BuildContext context, String buttonText,
    {required Function(String) onPressed,
    Color buttonColor = const Color(0xffe0e0e0)}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: ElevatedButton(
      onPressed: () => onPressed(buttonText),
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        //maximumSize: const Size(101, 70),
        fixedSize: const Size(101, 70),
        backgroundColor: buttonColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: buttonText != '⌫'
          ? Text(
              buttonText,
              style: const TextStyle(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.w900,
                  fontFamily: "NotoSansCJKKR",
                  fontSize: 34.0),
            )
          : SvgPicture.asset('assets/icon_delete_button.svg'),
    ),
  );
}

Widget alarmMissionBoardBuilder(BuildContext context, double height,
    {Widget? child, EdgeInsetsGeometry? padding, Color color = Colors.white}) {
  return Container(
    height: height,
    width: double.infinity,
    margin: const EdgeInsets.only(left: 15, right: 15),
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );
}