import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:word_hurdle_game/helper_functions.dart';
import 'package:word_hurdle_game/hurdle_provider.dart';
import 'package:word_hurdle_game/keyboard_view.dart';
import 'package:word_hurdle_game/wordle_item.dart';

class WordHurdleScreen extends StatefulWidget {
  const WordHurdleScreen({super.key});

  @override
  State<WordHurdleScreen> createState() => _WordHurdleScreenState();
}

class _WordHurdleScreenState extends State<WordHurdleScreen> {
  @override
  void didChangeDependencies() {
    Provider.of<HurdleProvider>(context, listen: false).init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    _submitButton(HurdleProvider provider){
      if (!provider.isAValidWord) {
        showMsg(context, 'This word is not in my dictionary');
        return;
      }
      if (provider.shouldCheckForAnswer) {
        provider.checkAnswer();
      }
      if (provider.wins) {
        showResult(
          context: context,
          title: 'You Win!!!',
          body: 'The word was ${provider.targetWord}',
          onPlayAgain: () {
            Navigator.pop(context);
            provider.reset();
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      } else if (provider.noAttemptsLeft) {
        showResult(
          context: context,
          title: 'You Lost',
          body: 'The word was ${provider.targetWord}',
          onPlayAgain: () {
            Navigator.pop(context);
            provider.reset();
          },
          onCancel: () {
            Navigator.pop(context);
          },
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Word Hurdle"),
        actions: [
          IconButton(
              onPressed: (){
                Provider.of<HurdleProvider>(context, listen: false).reset();
              },
              icon: const Icon(Icons.restart_alt),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.72,
                child: Consumer<HurdleProvider>(
                  builder: (context, provider, child) => GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: provider.hurdleBoard.length,
                    itemBuilder: (context, index) {
                      final wordle = provider.hurdleBoard[
                          index]; //passing the each wordle item from hurdleboard to the next screen
                      return WordleItem(wordle: wordle);
                    },
                  ),
                ),
              ),
            ),
            Consumer<HurdleProvider>(
              builder: (context, provider, child) => KeyboardView(
                excludedLetters: provider.excludedLetters,
                onPressed: (value) {
                  provider.inputLetter(value);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<HurdleProvider>(
                builder: (context, provider, child) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        provider.deleteLetter();
                      },
                      child: const Text("DELETE"),
                    ),
                    if (provider.count == 5)
                      ElevatedButton(
                        onPressed: () {
                          _submitButton(provider);
                        },
                        child: const Text("SUBMIT"),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );


  }
}
