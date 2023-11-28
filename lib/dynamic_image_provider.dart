library dynamic_image_provider;

import 'package:flutter/foundation.dart';

import 'dart:typed_data' show Uint8List;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

import 'fav_icon_finder.dart';

Map<String, Uint8List> _imageMemmoryCache = {};

class DynamicImageBuilder extends StatefulWidget {
  final String path;
  final double? height;
  final double? width;

  const DynamicImageBuilder({
    super.key,
    required this.path,
    this.height,
    this.width,
  });

  factory DynamicImageBuilder.fromWebUrlFav({required String webUrl}) =>
      DynamicImageBuilder(path: webUrl);

  @override
  State<DynamicImageBuilder> createState() => _DynamicImageBuilderState();
}

class _DynamicImageBuilderState extends State<DynamicImageBuilder> {
  bool isLoading = false;
  List<String> urls = [];
  int urlIndex = 0;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    FaviconFinder.getAll(widget.path).then((favUrls) {
      urls = favUrls.map((e) => e.url).toList();
      isLoading = false;
      setState(() {});
    });
  }

  final loader = const CircularProgressIndicator(strokeWidth: 2);
  final defaultIcon = const Icon(Icons.ac_unit_rounded);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return loader;

    if (urls.isEmpty) return defaultIcon;

    return FutureBuilder(
      future: _loadImageFromWebUrl(urls[urlIndex]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == Uint8List(0)) return defaultIcon;

          return Image.memory(
            snapshot.data as Uint8List,
            height: widget.height,
            width: widget.width,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, err, _) => defaultIcon,
          );
        }

        return Container(
          height: widget.height,
          width: widget.width,
          color: Colors.grey,
        );
      },
    );
  }

  Future<Uint8List> _loadImageFromWebUrl(String path) async {
    if (_imageMemmoryCache[path] != null) return _imageMemmoryCache[path]!;

    try {
      final response = await http.get(Uri.parse(path));

      if (response.statusCode == 200) {
        final icoImage = img.decodeImage(response.bodyBytes);

        if (icoImage != null) {
          final png = img.encodePng(icoImage);

          _imageMemmoryCache[path] = png;

          return png;
        } else {
          debugPrint(
              'fav: Failed to decode icoImage file is null  urls: ${urls.length}  index: $urlIndex   -- source: $path');
          if (urlIndex < urls.length) urlIndex++;
          setState(() {});
        }
      } else {
        debugPrint(
            'fav: Failed to download .ico file urls: ${urls.length}  index: $urlIndex  -- source: $path');
        if (urlIndex < urls.length) urlIndex++;
        setState(() {});
      }
    } catch (e) {
      // handle error
    }
    return Uint8List(0);
  }
}
