
import 'package:bezier/bezier.dart';
import 'package:vector_math/vector_math.dart';

List<Bezier> shapeZero = [
  Bezier.fromPoints(
      [Vector2(78, 30), Vector2(122, 30), Vector2(110, 160), Vector2(66, 160)]),
  Bezier.fromPoints(
      [Vector2(66, 160), Vector2(22, 160), Vector2(34, 30), Vector2(78, 30)]),
];

List<Bezier> shapeOne = [
  Bezier.fromPoints([Vector2(40, 100), Vector2(58, 74), Vector2(76, 58)]),
  Bezier.fromPoints([Vector2(76, 58), Vector2(76, 114), Vector2(76, 180)]),
];

List<Bezier> shapeTwo = [
  Bezier.fromPoints(
      [Vector2(36, 70), Vector2(36, 72), Vector2(56, 32), Vector2(76, 32)]),
  Bezier.fromPoints(
      [Vector2(76, 32), Vector2(92, 32), Vector2(108, 46), Vector2(108, 60)]),
  Bezier.fromPoints([
    Vector2(108, 60),
    Vector2(108, 100),
    Vector2(60, 120),
    Vector2(40, 160)
  ]),
  Bezier.fromPoints([Vector2(40, 160), Vector2(76, 160), Vector2(112, 160)]),
];

List<Bezier> shapeThree = [
  Bezier.fromPoints([Vector2(30, 40), Vector2(65, 40), Vector2(100, 40)]),
  Bezier.fromPoints([Vector2(100, 40), Vector2(81, 60), Vector2(62, 80)]),
  Bezier.fromPoints(
      [Vector2(62, 80), Vector2(84, 80), Vector2(105, 90), Vector2(105, 112)]),
  Bezier.fromPoints([
    Vector2(105, 112),
    Vector2(105, 164),
    Vector2(50, 180),
    Vector2(30, 132)
  ]),
];

List<Bezier> shapeFour = [
  Bezier.fromPoints([Vector2(80, 170), Vector2(79, 96), Vector2(78, 22)]),
  Bezier.fromPoints([Vector2(78, 22), Vector2(49, 79), Vector2(20, 116)]),
  Bezier.fromPoints([Vector2(20, 116), Vector2(76, 112), Vector2(116, 108)]),
];

List<Bezier> shapeFive = [
  Bezier.fromPoints(
    [Vector2(120, 30), Vector2(80, 35), Vector2(40, 40)],
  ),
  Bezier.fromPoints(
    [Vector2(40, 40), Vector2(35, 75), Vector2(30, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(30, 110), Vector2(70, 90), Vector2(110, 85), Vector2(110, 130)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 130), Vector2(110, 175), Vector2(65, 180), Vector2(25, 160)],
  ),
];

List<Bezier> shapeSix = [
  Bezier.fromPoints(
    [Vector2(80, 38), Vector2(20, 38), Vector2(-10, 160), Vector2(50, 160)],
  ),
  Bezier.fromPoints(
    [Vector2(50, 160), Vector2(80, 160), Vector2(90, 140), Vector2(90, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(90, 110), Vector2(90, 80), Vector2(30, 90), Vector2(20, 120)],
  ),
];

List<Bezier> shapeSeven = [
  Bezier.fromPoints(
    [Vector2(36, 48), Vector2(35, 43), Vector2(34, 38)],
  ),
  Bezier.fromPoints(
    [Vector2(34, 38), Vector2(72, 34), Vector2(110, 30)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 30), Vector2(87, 90), Vector2(64, 150)],
  ),
  Bezier.fromPoints(
    [Vector2(60, 100), Vector2(80, 100), Vector2(100, 100)],
  ),
];

List<Bezier> shapeEight = [
  Bezier.fromPoints(
    [Vector2(70, 40), Vector2(40, 40), Vector2(38, 80), Vector2(68, 80)],
  ),
  Bezier.fromPoints(
    [Vector2(68, 80), Vector2(103, 80), Vector2(105, 40), Vector2(70, 40)],
  ),
  Bezier.fromPoints(
    [Vector2(60, 80), Vector2(38, 80), Vector2(20, 135), Vector2(60, 135)],
  ),
  Bezier.fromPoints(
    [Vector2(60, 135), Vector2(100, 135), Vector2(98, 80), Vector2(68, 80)],
  ),
];

List<Bezier> shapeNine = [
  Bezier.fromPoints(
    [Vector2(100, 70), Vector2(100, 100), Vector2(50, 100), Vector2(50, 70)],
  ),
  Bezier.fromPoints(
    [Vector2(50, 70), Vector2(50, 40), Vector2(100, 40), Vector2(100, 70)],
  ),
  Bezier.fromPoints(
    [Vector2(100, 70), Vector2(100, 90), Vector2(100, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(100, 110), Vector2(100, 150), Vector2(60, 150)],
  ),
  Bezier.fromPoints(
    [Vector2(60, 150), Vector2(50, 150), Vector2(50, 135)],
  ),
];

List<List<Bezier>> shapes = [
  shapeZero,
  shapeOne,
  shapeTwo,
  shapeThree,
  shapeFour,
  shapeFive,
  shapeSix,
  shapeSeven,
  shapeEight,
  shapeNine,
];
