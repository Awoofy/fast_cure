import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fast Cure -GATCG Life Counter-',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const LifeCounterPage(),
    );
  }
}

class LifeCounterPage extends StatefulWidget {
  const LifeCounterPage({super.key});

  @override
  State<LifeCounterPage> createState() => _LifeCounterPageState();
}

class _LifeCounterPageState extends State<LifeCounterPage> {
  int player1Life = 0;
  int player2Life = 0;
  bool player1LeftPressed = false;
  bool player1RightPressed = false;
  bool player2LeftPressed = false;
  bool player2RightPressed = false;

  void _updateLife(bool isPlayer1, bool isIncrease) {
    setState(() {
      if (isPlayer1) {
        player1Life = isIncrease ? player1Life + 1 : (player1Life > 0 ? player1Life - 1 : 0);
      } else {
        player2Life = isIncrease ? player2Life + 1 : (player2Life > 0 ? player2Life - 1 : 0);
      }
    });
  }

  void _resetLife() {
    setState(() {
      player1Life = 0;
      player2Life = 0;
    });
  }

  Widget _buildPlayerArea(bool isPlayer1) {
    final life = isPlayer1 ? player1Life : player2Life;
    final isLeftPressed = isPlayer1 ? player1LeftPressed : player2LeftPressed;
    final isRightPressed = isPlayer1 ? player1RightPressed : player2RightPressed;
    
    return Expanded(
      child: RotatedBox(
        quarterTurns: isPlayer1 ? 0 : 2,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => setState(() {
                      if (isPlayer1) {
                        player1LeftPressed = true;
                      } else {
                        player2LeftPressed = true;
                      }
                    }),
                    onTapUp: (_) {
                      setState(() {
                        if (isPlayer1) {
                          player1LeftPressed = false;
                        } else {
                          player2LeftPressed = false;
                        }
                      });
                      _updateLife(isPlayer1, false);
                    },
                    onTapCancel: () => setState(() {
                      if (isPlayer1) {
                        player1LeftPressed = false;
                      } else {
                        player2LeftPressed = false;
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      color: Colors.lightBlue.withOpacity(isLeftPressed ? 0.1 : 0.3),
                      child: const Center(
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTapDown: (_) => setState(() {
                      if (isPlayer1) {
                        player1RightPressed = true;
                      } else {
                        player2RightPressed = true;
                      }
                    }),
                    onTapUp: (_) {
                      setState(() {
                        if (isPlayer1) {
                          player1RightPressed = false;
                        } else {
                          player2RightPressed = false;
                        }
                      });
                      _updateLife(isPlayer1, true);
                    },
                    onTapCancel: () => setState(() {
                      if (isPlayer1) {
                        player1RightPressed = false;
                      } else {
                        player2RightPressed = false;
                      }
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      color: Colors.lightBlue.withOpacity(isRightPressed ? 0.1 : 0.3),
                      child: const Center(
                        child: Text(
                          '+',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Text(
                life.toString(),
                style: const TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildPlayerArea(false),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _resetLife,
                child: const Text('Reset'),
              ),
            ),
          ),
          _buildPlayerArea(true),
        ],
      ),
    );
  }
}
