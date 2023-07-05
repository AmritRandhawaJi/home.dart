import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:okstitch/onboarding/slide_list.dart';

class SlideItem extends StatefulWidget {
  final int index;

  const SlideItem(this.index, {super.key});

  @override
  State<SlideItem> createState() => _SlideItemState();
}

class _SlideItemState extends State<SlideItem>  with SingleTickerProviderStateMixin{

  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
  _controller = AnimationController(vsync: this);
  super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
         Text(
          "Ok Stitch",
          style: TextStyle(
              fontFamily: "Mukta",
              fontSize: MediaQuery.of(context).size.width/20,
              color: Colors.black54,
              fontWeight: FontWeight.bold),
        ),
        Lottie.asset(
          slideList[widget.index].image,
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..repeat();
          },
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Text(
                    slideList[widget.index].title,
                    style:  TextStyle(
                        fontFamily: "Mukta",
                        fontSize: MediaQuery.of(context).size.height/35,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      slideList[widget.index].description,
                      style:  TextStyle(
                        fontFamily: "Mukta",
                        fontSize: MediaQuery.of(context).size.height/50,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
}
