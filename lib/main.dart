import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_application/Widgets/image_view.dart';
import 'package:gallery_application/Widgets/likes_views_widget.dart';
import 'Model/image_model.dart';
import 'Services/image_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImageService imageService = ImageService();
  List<ImageModel> images = [];
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();
  Orientation? screenOrientation;

  @override
  void initState() {
    super.initState();
    _loadImages();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadImages();
      }
    });
  }

  Future<void> _loadImages() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final newImages = await imageService.fetchImages();
    setState(() {
      images.addAll(newImages);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size localSize = MediaQuery.of(context).size;

    int columns = (localSize.width / 150).floor();

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: CustomScrollView(
        scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad
        },),
        controller: _scrollController,
        slivers: [
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext context, int index) {
            final image = images[index];
            return GestureDetector(
              onTap: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return ImageView(image: image);
                    });
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: image.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    LikesViews(image: image),
                  ],
                ),
              ),
            );
          },
          ),
          const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
