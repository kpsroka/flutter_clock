
import 'package:bezier/bezier.dart';
import 'package:vector_math/vector_math.dart';

List<Bezier> shapeZero = [
  Bezier.fromPoints(
      [Vector2(78, 30), Vector2(122, 30), Vector2(110, 160), Vector2(66, 160)]),
  Bezier.fromPoints(
      [Vector2(66, 160), Vector2(22, 160), Vector2(34, 30), Vector2(78, 30)]),
];

List<Bezier> shapeOne = [
  Bezier.fromPoints([Vector2(40, 80), Vector2(58, 54), Vector2(76, 38)]),
  Bezier.fromPoints([Vector2(76, 38), Vector2(76, 109), Vector2(76, 170)]),
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
    [Vector2(70, 30), Vector2(35, 30), Vector2(32, 70), Vector2(67, 89)],
  ),
  Bezier.fromPoints(
    [Vector2(67, 89), Vector2(108, 89), Vector2(111, 30), Vector2(70, 30)],
  ),
  Bezier.fromPoints(
    [Vector2(67, 89), Vector2(24, 89), Vector2(10, 170), Vector2(64, 170)],
  ),
  Bezier.fromPoints(
    [Vector2(64, 170), Vector2(118, 170), Vector2(102, 89), Vector2(68, 89)],
  ),
];

List<Bezier> shapeNine = [
  Bezier.fromPoints(
    [Vector2(110, 60), Vector2(110, 90), Vector2(42, 90), Vector2(42, 60)],
  ),
  Bezier.fromPoints(
    [Vector2(42, 60), Vector2(42, 20), Vector2(110, 20), Vector2(110, 60)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 60), Vector2(110, 85), Vector2(110, 110)],
  ),
  Bezier.fromPoints(
    [Vector2(110, 110), Vector2(110, 160), Vector2(57, 160)],
  ),
  Bezier.fromPoints(
    [Vector2(57, 160), Vector2(40, 160), Vector2(40, 135)],
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
