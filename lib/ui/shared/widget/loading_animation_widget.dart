import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animations/loading_animations.dart';
 
class LoadingAnimationWidget extends StatefulWidget {
  LoadingAnimationWidget({Key? key}) : super(key: key);

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingBouncingGrid.square(
        backgroundColor:Colors.blueAccent,
        size: 50.w,
      ),
    );
  }
}
