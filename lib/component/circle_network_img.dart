
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oh_my_shirt/data/app_theme.dart';

class CircleNetworkImg extends StatefulWidget {
  final String networkImage;
  final double radius;
  const CircleNetworkImg({this.networkImage, this.radius = 40});

  @override
  State<CircleNetworkImg> createState() => _CircleNetworkImgState();
}

class _CircleNetworkImgState extends State<CircleNetworkImg> {
  Widget errorCase() {
    return Icon(Icons.account_circle_rounded,
        size: widget.radius * 2, color: AppTheme.brandPrimary);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          foregroundColor: Colors.white,
          backgroundColor: AppTheme.uiGray_4,
          radius: widget.radius,
          child: widget.networkImage != null
              ? CachedNetworkImage(
                  imageUrl: widget.networkImage,
                  placeholder: (context, url) => Stack(
                        children: [
                          Center(
                              child: Icon(
                            Icons.account_circle_rounded,
                            color: AppTheme.uiGray_1,
                            size: widget.radius * 2,
                          )),
                          Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.uiGray_1,
                              ),
                            ),
                          ),
                        ],
                      ),
                  imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: widget.radius,
                      ),
                  errorWidget: (context, url, error) => errorCase())
              : errorCase(),
        ),
      ],
    );
  }
}
