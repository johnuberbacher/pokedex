import 'package:flutter/material.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Widget getBaseStat(double stat, String color) {
  return Padding(
      padding: const EdgeInsets.only(
        bottom: 15.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: generateBaseStatsIndicator(stat, color),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  left: 20.0,
                ),
                child: Text(
                  stat.toInt().toString() + "/255",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
          )
        ],
      ));
}

Widget generateBaseStatsIndicator(double stat, String bgColor) {
  return ClipRRect(
    borderRadius: BorderRadius.all(
      Radius.circular(100),
    ),
    child: LinearProgressIndicator(
      color: getPrimaryTypeColor(bgColor),
      backgroundColor: getPrimaryTypeColor(bgColor).withOpacity(0.5),
      minHeight: 10,
      value: getBaseStatsIndicators(stat),
    ),
  );
}

double getBaseStatsIndicators(double value) {
  // Max Pokemon Base Stat value is 255
  double baseStatIndicatorValue = (value.round() / 255);
  print(baseStatIndicatorValue / 1.0);
  return baseStatIndicatorValue / 1.0;
}

Color getPrimaryTypeColor(String primaryType) {
  Color color;
  final value = primaryType;

  if (value == "Grass") {
    return color = Color(0xFF60bd58);
  } else if (value == "Water") {
    return color = Color(0xFF539ddf);
  } else if (value == "Fire") {
    return color = Color(0xFFfba64c);
  } else if (value == "Electric") {
    return color = Color(0xFFf2d94e);
  } else if (value == "Bug") {
    return color = Color(0xFF92bd2d);
  } else if (value == "Psychic") {
    return color = Color(0xFFef90e6);
  } else if (value == "Fairy") {
    return color = Color(0xFFfa8582);
  } else if (value == "Ghost") {
    return color = Color(0xFF5f6dbc);
  } else if (value == "Flying") {
    return color = Color(0xFFa1bbec);
  } else if (value == "Fighting") {
    return color = Color(0xFFd3425f);
  } else if (value == "Ice") {
    return color = Color(0xFF85c6d9);
  } else if (value == "Normal") {
    return color = Color(0xFFa0a29f);
  } else if (value == "Rock") {
    return color = Color(0xFFc9bc8a);
  } else if (value == "Ground") {
    return color = Color(0xFFda7c4d);
  } else if (value == "Dark") {
    return color = Color(0xFF595761);
  } else if (value == "Poison") {
    return color = Color(0xFFb763cf);
  } else if (value == "Steel") {
    return color = Color(0xFF5795a3);
  } else if (value == "Dragon") {
    return color = Color(0xFF76d1c1);
  } else {
    return color = Color(0xFFd6dee5);
  }
}
