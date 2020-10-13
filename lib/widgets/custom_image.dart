

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zchat/widgets/progressss.dart';

Widget cachedNetworkImage(String mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context,url)=>circularProgresssbar(),
    errorWidget: (context,url,error)=>Icon(Icons.error),
  );
}
