import 'package:flutter/material.dart';
import 'cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> flapAnimation;
  AnimationController flapController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -30.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );

    flapController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    flapAnimation = Tween(begin: 0.6, end: 0.65).animate(
      CurvedAnimation(
        parent: flapController,
        curve: Curves.linear,
      ),
    );
    flapController.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        flapController.reverse();
      else if (status == AnimationStatus.dismissed) flapController.forward();
    });
    flapController.forward();
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      flapController.forward();
    }
    else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      flapController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildFlapAnimation(),
              buildRightFlap(),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          right: 0.0,
          left: 0.0,
          top: catAnimation.value,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      width: 200.0,
      height: 240.0,
      color: Colors.brown,
    );
  }

  Widget buildFlapAnimation() {
    return Positioned(
      left: 5.0,
      top: 3.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        child: Container(
          width: 125.0,
          height: 10.0,
          color: Colors.brown,
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: pi * flapAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 5.0,
      top: 3.0,
      child: AnimatedBuilder(
          animation: flapAnimation,
          child: Container(
            width: 125.0,
            height: 10.0,
            color: Colors.brown,
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: pi * (2 - flapAnimation.value),
              alignment: Alignment.topRight,
              child: child,
            );
          }),
    );
  }
}
