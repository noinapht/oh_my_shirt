
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class AdvApp extends StatefulWidget {
  const AdvApp({Key key}) : super(key: key);

  @override
  State<AdvApp> createState() => _AdvAppState();
}

class _AdvAppState extends State<AdvApp> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  final List<String> imgList = [
    'https://cdn.discordapp.com/attachments/847444443916271667/980354758814605362/Mask_group_1.png',
    'https://cdn.discordapp.com/attachments/847444443916271667/980354947407282196/Group_15.png',
    'https://cdn.discordapp.com/attachments/847444443916271667/980356031756517396/washing-machine-gf072cbb7d_1920.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                       
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();
    return Column(children: [
      ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
        child: CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              viewportFraction: 1,
              aspectRatio: 2,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => _controller.animateToPage(entry.key),
            child: Container(
              width: 6.0,
              height: 6.0,
              margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            ),
          );
        }).toList(),
      )
    ]);
  }
}
