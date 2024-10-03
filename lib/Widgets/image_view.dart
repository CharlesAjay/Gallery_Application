import 'package:flutter/material.dart';
import 'package:gallery_application/Model/image_model.dart';
import 'package:gallery_application/Widgets/likes_views_widget.dart';

///Show single image view
class ImageView extends StatefulWidget {
  ImageView({super.key, required this.image});
  ImageModel image;
  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    Size localSize = MediaQuery.of(context).size;
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    height: widget.image.imageHeight > localSize.height * 0.7 ? localSize.height * 0.7 : widget.image.imageHeight.toDouble(),
                    child: imageWidget(widget.image),
                  ),
                  LikesViews(image: widget.image)
                ],
              ),
            ),
          ),
          // likesAndViewsWidget(widget.image),
        ],
      ),
    );
  }

  imageWidget(ImageModel image) {
    return InteractiveViewer(
      child: Image.network(image.imageUrl)
    );
  }
}
