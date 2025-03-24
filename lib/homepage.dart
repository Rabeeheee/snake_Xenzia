import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Snake extends StatefulWidget {
  const Snake({super.key});

  @override
  State<Snake> createState() => _SnakeState();
}

class _SnakeState extends State<Snake> {
  static List<int> snakePosition = [45, 65, 85, 105, 125];
  int numberOfSquares = 560;

  static var randomNumber = Random();
  int food = randomNumber.nextInt(700);
  int score = 0;

  bool isGameRunning = false;

  void generateNewFood() {
    do {
      food = randomNumber.nextInt(numberOfSquares);
    } while (snakePosition.contains(food));
  }

  Timer? timer;
  var direction = 'down';

  void startGame() {
    if (isGameRunning) return;

    isGameRunning = true;
    snakePosition = [45, 65, 85, 105, 125];
    direction = 'down';
    score = 0;
    generateNewFood();

    const duration = Duration(milliseconds: 250);
    timer = Timer.periodic(duration, (Timer timer) {
      updateSnake();
      if (gameOver()) {
        timer.cancel();
        isGameRunning = false;
        _showGameOverScreen();
      }
    });
  }

  void updateSnake() {
    setState(() {
      int? newHead;

      switch (direction) {
        case 'down':
          newHead = (snakePosition.last + 20) % numberOfSquares;
          
          if (newHead < 0) newHead += numberOfSquares;
          break;

        case 'up':
          newHead = (snakePosition.last - 20 + numberOfSquares) % numberOfSquares;
          break;

        case 'left':
          newHead = snakePosition.last - 1;
          if (newHead % 20 == 19) {
            newHead += 20; // Wrap to the right
          }
          break;

        case 'right':
          newHead = snakePosition.last + 1;
          if (newHead % 20 == 0) {
            newHead -= 20; // Wrap to the left
          }
          break;
      }

      snakePosition.add(newHead!);

      if (snakePosition.last == food) {
        generateNewFood();
        score++;
      } else {
        snakePosition.removeAt(0);
      }
    });
  }

  bool gameOver() {
    for (int i = 0; i < snakePosition.length - 1; i++) {
      if (snakePosition[i] == snakePosition.last) {
        return true;
      }
    }
    return false;
  }

  void _showGameOverScreen() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('GAME OVER'),
            content: Text('Your score: $score'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    startGame();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Play Again'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 5, 5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.only(top: 30.0),
              child: Text(
                  'Score: $score',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                
                ),
                
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (direction != 'up' && details.delta.dy > 0) {
                direction = 'down';
              } else if (direction != 'down' && details.delta.dy < 0) {
                direction = 'up';
              }
            },
            onHorizontalDragUpdate: (details) {
              if (direction != 'left' && details.delta.dx > 0) {
                direction = 'right';
              } else if (direction != 'right' && details.delta.dx < 0) {
                direction = 'left';
              }
            },
            
            child: Container(
              
              child: Center(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 20),
                  itemCount: numberOfSquares,
                  itemBuilder: (BuildContext context, int index) {
                    if (snakePosition.contains(index)) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Container(
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      );
                    } else if (index == food) {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: const Color.fromARGB(255, 54, 244, 149),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.all(2),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      );
                    }
                  },
                ),
                
              ),
              
            ),
          )),
          Column(
          

            children: [
            
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: startGame,
                      child: const Text(
                        'START',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
