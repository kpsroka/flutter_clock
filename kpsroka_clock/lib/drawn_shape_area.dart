import 'dart:math';

import 'package:digital_clock/drawn_shape.dart';
import 'package:digital_clock/model_provider.dart';
import 'package:digital_clock/shapes.dart';
import 'package:digital_clock/sponge.dart';
import 'package:flutter/material.dart';

class DrawnShapeArea extends StatefulWidget {
  @override
  _DrawnShapeAreaState createState() => _DrawnShapeAreaState();
}

class _DrawnShapeAreaState extends State<DrawnShapeArea> with TickerProviderStateMixin {
  AnimationController spongeController;
  final List<AnimationController> shapeAnimationControllers = [];
  final List<BezierShape> currentShapes = List.filled(4, null, growable: true);
  double spongeFractionalWidth = 1;

  @override
  void initState() {
    super.initState();
    spongeController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    shapeAnimationControllers.addAll(Iterable.generate(
      4,
      (int _) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
      ),
    ));

    shapeAnimationControllers.reduce(
      (AnimationController previous, AnimationController next) {
        previous.addStatusListener(
          (AnimationStatus status) {
            if (status == AnimationStatus.dismissed) {
              next.reset();
            } else if (status == AnimationStatus.completed) {
              next.forward();
            }
          },
        );
        return next;
      },
    );
  }

  @override
  void dispose() {
    spongeController.dispose();
    shapeAnimationControllers.forEach((AnimationController controller) => controller.dispose());
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    DateTime nextDateTime = DateTimeProvider.of(context, granularity: DateTimeGranularity.minute);
    List<BezierShape> nextShapes = [
      shapes[nextDateTime.hour ~/ 10],
      shapes[nextDateTime.hour % 10],
      shapes[nextDateTime.minute ~/ 10],
      shapes[nextDateTime.minute % 10],
    ];

    int firstChangeIndex = _firstDifferenceIndex(currentShapes, nextShapes);

    if (firstChangeIndex != null) {
      _redrawShapes(nextShapes, firstChangeIndex);
    }
  }

  void _redrawShapes(List<BezierShape> nextShapes, int firstChangeIndex) {
    if (spongeController.isAnimating) {
      spongeController.stop(); // should only happen at the very beginning.
    }

    spongeFractionalWidth = (4 - firstChangeIndex) * (2 / 9) + (firstChangeIndex < 2 ? 1 / 9 : 0);

    spongeController.duration = Duration(seconds: (4 - firstChangeIndex) * 2);
    spongeController.forward().then((void _) {
      if (mounted) {
        spongeController.reset();
        shapeAnimationControllers[firstChangeIndex].reset();
        shapeAnimationControllers[firstChangeIndex].forward();
        setState(() {
          currentShapes.replaceRange(firstChangeIndex, 4, nextShapes.sublist(firstChangeIndex));
        });
      }
    }, onError: (dynamic e) {
      debugPrint('Caught error $e when running sponge controller');
    });
    debugPrint("Sponge controller started with duration ${spongeController.duration}");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildDrawnShape(0),
            _buildDrawnShape(1),
            Spacer(flex: 1),
            _buildDrawnShape(2),
            _buildDrawnShape(3),
          ],
        ),
        Positioned.fill(
          child: FractionallySizedBox(
            widthFactor: spongeFractionalWidth,
            alignment: Alignment.centerRight,
            child: Sponge(animationController: spongeController),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(':', style: TextStyle(color: Colors.black, fontSize: 120)),
          ),
        ),
      ],
    );
  }

  _buildDrawnShape(int index) {
    return currentShapes[index] == null
        ? Spacer(flex: 2)
        : Expanded(
            flex: 2,
            child: DrawnShape(
              shape: currentShapes[index],
              animationController: shapeAnimationControllers[index],
            ),
          );
  }
}

int _firstDifferenceIndex<T>(List<T> a, List<T> b) {
  final int bound = min(a.length, b.length);
  for (int index = 0; index < bound; index++) {
    if (a[index] != b[index]) {
      return index;
    }
  }

  if (max(a.length, b.length) > bound) {
    return bound;
  } else {
    return null;
  }
}
