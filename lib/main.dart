import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_application/Widgets/image_view.dart';
import 'package:gallery_application/Widgets/likes_views_widget.dart';
import 'Model/image_model.dart';
import 'Services/image_service.dart';

// Main entry point of the application
void main() => runApp(const GalleryApp());

// Main widget of the application
class GalleryApp extends StatelessWidget {
  const GalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const GalleryScreen(),
    );
  }
}

// Gallery screen that displays images in a grid
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ImageService imageService = ImageService();
  List<ImageModel> images = []; // List to store image data
  bool isLoading = false; // Indicator for loading state
  final ScrollController _scrollController = ScrollController();
  Orientation? screenOrientation;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _loadImages(); // Load initial images
    /// Load more images when scrolling to the bottom of the list
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadImages();
      }
    });
  }

  /// Fetch images from the Pixabay API
  Future<void> _loadImages() async {
    if (isLoading) return; // Prevent multiple simultaneous requests

    setState(() {
      isLoading = true;
    });

    final newImages = await imageService.fetchImages(_currentPage);
    setState(() {
      images.addAll(newImages);
      _currentPage++;
      isLoading = false; // Reset loading state
    });
  }

  @override
  Widget build(BuildContext context) {
    Size localSize = MediaQuery.of(context).size;

    int columns = (localSize.width / 150).floor(); // Determine number of columns for grid

    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: CustomScrollView(
        scrollBehavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad
        },
        ),
        controller: _scrollController,
        slivers: [
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: images.length,
            itemBuilder: (BuildContext ctx, int index) {
              WidgetsBinding.instance.addPostFrameCallback((_){
                if( _currentPage == 2 && localSize.height * localSize.width > 840000){
                  _loadImages(); // Load second page if the device has more screen space. Prevents from scroll locking.
                }
              });
            final image = images[index];
            return GestureDetector( // Open image view on clicking a grid
              onTap: () async {
                await showDialog( // Show Image view Dialog
                    context: ctx,
                    builder: (context) {
                      return ImageView(image: image);
                    });
              },
              child: Card( // Build image card
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
