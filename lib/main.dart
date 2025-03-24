import 'package:flutter/material.dart';
import 'package:snake/homepage.dart';

void main(){
  runApp(const SnakeGame());

}
class SnakeGame extends StatelessWidget {
  const SnakeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Snake(),
    );
  }
}