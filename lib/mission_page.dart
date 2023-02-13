import 'package:flutter/material.dart';
import 'package:table_exam/memorize_number.dart';
import 'package:table_exam/memorize_shape.dart';

class MissionPage extends StatefulWidget {
  const MissionPage({Key? key}) : super(key: key);

  @override
  State<MissionPage> createState() => _MissionPageState();
}

class _MissionPageState extends State<MissionPage> {
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 240,
            color: Colors.redAccent,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _index = _index == 0 ? 1 : 0;
                  print(_index);
                });
              },
              child: Text('Start'),
            ),
          ),
          IndexedStack(
            index: _index,
            children: [
              MemorizeNumber(),
              MemorizeShape(),
            ],
          ),
        ],
      ),
    );
  }
}
