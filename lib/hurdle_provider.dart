import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:english_words/english_words.dart' as words;

import 'Model/wordle.dart';

class HurdleProvider extends ChangeNotifier {
  final random = Random.secure(); //Generate Random Numbers
  String targetWord = '';
  int count = 0;
  final lettersPerRow = 5;
  final totalAttempts = 6;
  int attempts = 0;
  int index = 0;
  bool wins = false;

  List<String> totalWords = [];
  List<String> rowInputs = [];
  List<String> excludedLetters = [];
  List<Wordle> hurdleBoard = [];
  // final player = AudioPlayer();

  // Initializes the game by generating a list of words with a length of 5 characters.
  // Filters words from the 'words.all' collection, selecting those with a length of 5,
  // and stores them in the 'totalWords' variable as a list.
  // Additionally, sets up the game board with 'generateBoard()' and selects a random word
  // from the generated list with 'generateRandomWord()'.
  init() {
    totalWords = words.all.where((element) => element.length == 5).toList();
    generateBoard();
    generateRandomWord();
  }

  // Generates the initial game board for Wordle, creating a list of 30 'Wordle' instances
  // within the 'hurdleBoard' variable. Each instance is initialized with an empty string for the 'letter' property.
  generateBoard() {
    hurdleBoard = List.generate(30, (index) => Wordle(letter: ''));
  }

  // Selects a random word from the list of words with a length of 5 ('totalWords').
  // Converts the selected word to uppercase and assigns it to the 'targetWord' variable.
  // Prints the selected 'targetWord', possibly for debugging or informational purposes.

  generateRandomWord() {
    targetWord = totalWords[random.nextInt(totalWords.length)].toUpperCase();
    print(targetWord);
  }

  bool get isAValidWord =>
      totalWords.contains(rowInputs.join('').toLowerCase());

  bool get shouldCheckForAnswer => rowInputs.length == lettersPerRow;

  bool get noAttemptsLeft => attempts == totalAttempts;

  inputLetter(String letter) {
    if (count < lettersPerRow) {
      count++;
      rowInputs.add(letter);
      hurdleBoard[index] = Wordle(letter: letter);
      index++;
      notifyListeners();
      print(rowInputs);
    }
  }

  void deleteLetter() {
    if (rowInputs.isNotEmpty) {
      rowInputs.removeAt(rowInputs.length - 1);
      print(rowInputs);
    }
    if (count > 0) {
      hurdleBoard[index - 1] = Wordle(letter: '');
      count--;
      index--;
    }
    notifyListeners();
  }

  void checkAnswer() {
    final input = rowInputs.join('');
    if (targetWord == input) {
      wins = true;
    } else {
      // _playSound("assets/sounds/wrong_answer.mp3");
      _markLetterOnBoard();
      if (attempts < totalAttempts) {
        _goToNextRow();
      }
    }
  }

  void _markLetterOnBoard() {
    for (int i = 0; i < hurdleBoard.length; i++) {
      if (hurdleBoard[i].letter.isNotEmpty &&
          targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].existsInTarget = true;
      } else if (hurdleBoard[i].letter.isNotEmpty &&
          !targetWord.contains(hurdleBoard[i].letter)) {
        hurdleBoard[i].doesNotExistInTarget = true;
        excludedLetters.add(hurdleBoard[i].letter);
      }
    }
    notifyListeners();
  }

  void _goToNextRow() {
    attempts++;
    count = 0;
    rowInputs.clear();
  }

  reset(){
    count = 0;
    index = 0;
    rowInputs.clear();
    hurdleBoard.clear();
    excludedLetters.clear();
    attempts = 0;
    wins = false;
    targetWord = '';
    generateBoard();
    generateRandomWord();
    notifyListeners();
  }

  // Future<void> _playSound(String path) async {
  //   print(path);
  //   await player.play(AssetSource(path));
  //   notifyListeners();
  // }
}
