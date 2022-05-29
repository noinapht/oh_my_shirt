import 'package:flutter/material.dart';

class SlidingIndicator extends StatefulWidget {
  @override
  _SlidingIndicatorState createState() => _SlidingIndicatorState();
}

class _SlidingIndicatorState extends State<SlidingIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  bool showSlider = false;

  @override
  void dispose() {
    animController?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: showSlider
            ? LinearProgressIndicator(value: animation.value)
            : GestureDetector(
                onTap: () {
                  animController = AnimationController(
                      duration: const Duration(milliseconds: 5000),
                      vsync: this);
                  animation =
                      Tween(begin:0.0, end: 2.0).animate(animController)
                        ..addListener(() {
                          setState(() {
                            print('Here set the state');
                          });
                        });
                  animController.repeat();
                  setState(() {
                    showSlider = true;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(color: Colors.red),
                  padding: EdgeInsets.all(20),
                  child: Text('Start Slider'),
                ),
              ));
  }
}
