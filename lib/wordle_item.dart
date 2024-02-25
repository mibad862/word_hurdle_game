import 'package:flutter/material.dart';
import 'package:word_hurdle_game/Model/wordle.dart';

class WordleItem extends StatelessWidget {
  const WordleItem({super.key, required this.wordle});

  final Wordle wordle;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: wordle.existsInTarget ? Colors.white60 :
            wordle.doesNotExistInTarget ? Colors.blueGrey.shade700 : null,
      border: Border.all(
        color: Colors.amber,
        width: 1.5,
      ),
      ),
      child: Text(
        wordle.letter,
        style: TextStyle(
          color: wordle.existsInTarget ? Colors.black :
              wordle.doesNotExistInTarget ? Colors.white54 : Colors.white,
        ),
      ),
    );
  }
}
