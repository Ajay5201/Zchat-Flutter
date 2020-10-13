import 'package:flutter/material.dart';

Container circularProgresssbar() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 0.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
          Colors.pinkAccent
      ),
    ),
  );
}

Container linearProgresssbar() {
  return Container(
    child: LinearProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
            Colors.pinkAccent
        )
    ),
  );
}
