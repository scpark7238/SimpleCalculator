import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:table_exam/memorize_number.dart';

import 'theme.dart';

void main() {
  runApp(Calculator());
}

class Calculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: theme(),
      home: const MemorizeNumber(),
      //home: SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({Key? key}) : super(key: key);

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String equation = '0';
  String result = '0';
  String expression = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Calculator')),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Text(equation, style: const TextStyle(fontSize: 38)),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Text(result, style: const TextStyle(fontSize: 48)),
            ),
            const Expanded(
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton('C', 1, Colors.redAccent),
                          buildButton('<', 1, Colors.blue),
                          buildButton('%', 1, Colors.blue),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('7', 1, Colors.black54),
                          buildButton('8', 1, Colors.black54),
                          buildButton('9', 1, Colors.black54),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('4', 1, Colors.black54),
                          buildButton('5', 1, Colors.black54),
                          buildButton('6', 1, Colors.black54),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('1', 1, Colors.black54),
                          buildButton('2', 1, Colors.black54),
                          buildButton('3', 1, Colors.black54),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('.', 1, Colors.black54),
                          buildButton('0', 1, Colors.black54),
                          buildButton('00', 1, Colors.black54),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          buildButton('x', 1, Colors.blue),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('-', 1, Colors.blue),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('+', 1, Colors.blue),
                        ],
                      ),
                      TableRow(
                        children: [
                          buildButton('=', 2, Colors.redAccent),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        equation = '0';
        result = '0';
      } else if (buttonText == '<') {
        equation = equation.substring(0, equation.length - 1);
        if (equation == '') {
          equation = '0';
        }
      } else if (buttonText == '=') {
        expression = equation;
        expression = expression.replaceAll('x', '*');
        expression = expression.replaceAll('%', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
        } catch (e) {
          result = 'Error';
        }
      } else {
        if (equation == '0') {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return ElevatedButton(
      onPressed: () => buttonPressed(buttonText),
      style: ElevatedButton.styleFrom(
        minimumSize: Size.fromHeight(
            MediaQuery.of(context).size.height * 0.1 * buttonHeight),
        backgroundColor: buttonColor,
        padding: const EdgeInsets.all(16.0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          side: BorderSide(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Text(
        buttonText,
        style: const TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
    );
  }
}
