import 'package:flutter/material.dart';

class GradientCard extends StatelessWidget {
  final String content;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;

  const GradientCard({
    Key? key,
    required this.content,
    this.width = 400,
    this.height = 400,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(106, 255, 82, 82),
                Color.fromARGB(121, 233, 30, 98),
              ],
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Center(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
