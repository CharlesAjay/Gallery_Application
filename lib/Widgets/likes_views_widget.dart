import 'package:flutter/material.dart';
import 'package:gallery_application/Model/image_model.dart';
class LikesViews extends StatelessWidget {
  LikesViews({super.key,required this.image});
  ImageModel image;

  @override
  Widget build(BuildContext context) {
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
    );;
  }
}
