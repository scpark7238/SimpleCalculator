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
          Container(
            height: 240,
            color: Colors.redAccent,
            child: ElevatedButton(
              onPressed: () => _playGame(),
              child: Text('TimerStart'),
            ),
          ),
          buildMiddle(context),
          const SizedBox(height: 10),
          buildBottom(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    double borderHeight = MediaQuery.of(context).size.height - 240 - 249;
    double buttonHeight = (borderHeight - (16.5 * 2) - (10 * 3)) / 4;
    double buttonWidth =
        (MediaQuery.of(context).size.width - (15 * 2) - (20 * 2) - (10 * 2)) /
            3;

    return alarmMissionBoardBuilder(context, borderHeight,
        child: _buildMemorizeNumberCalc(context,
            buttonWidth: buttonWidth,
            buttonHeight: buttonHeight,
            onPressed: buttonPressed),
        padding: const EdgeInsets.fromLTRB(20, 16.5, 20, 16.5));
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
    {required double buttonWidth,
    required double buttonHeight,
    required Function(String) onPressed}) {
  return Column(
    //border: TableBorder.all(),
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(context, '1', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '2', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '3', buttonWidth, buttonHeight,
              onPressed: onPressed),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(context, '4', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '5', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '6', buttonWidth, buttonHeight,
              onPressed: onPressed),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildButton(context, '7', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '8', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '9', buttonWidth, buttonHeight,
              onPressed: onPressed),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: buttonWidth),
          buildButton(context, '0', buttonWidth, buttonHeight,
              onPressed: onPressed),
          buildButton(context, '⌫', buttonWidth, buttonHeight,
              onPressed: onPressed),
        ],
      ),
    ],
  );
}

Widget buildButton(BuildContext context, String buttonText, double buttonWidth,
    double buttonHeight,
    {required Function(String) onPressed,
    Color buttonColor = const Color(0xffe0e0e0)}) {
  return ElevatedButton(
    onPressed: () => onPressed(buttonText),
    style: ElevatedButton.styleFrom(
      elevation: 0.0,
      //maximumSize: Size(190, buttonHeight),
      fixedSize: Size(buttonWidth, buttonHeight),
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
