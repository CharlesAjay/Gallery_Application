import 'package:flutter/material.dart';
import 'package:gallery_application/Model/image_model.dart';

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
                  likesAndViewsWidget(widget.image)
                ],
              ),
            ),
          ),
          // likesAndViewsWidget(widget.image),
        ],
      ),
    );
  }
  likesAndViewsWidget(ImageModel image) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 8,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
              const Icon(Icons.favorite,color: Colors.red,),
              Text('${image.likes}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
              const Icon(Icons.remove_red_eye_outlined,),
              Text('${image.views}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],),
          ],),
      ),
    );
  }

  imageWidget(ImageModel image) {
    return InteractiveViewer(
      child: Image.network(image.imageUrl)
    );
  }
}
