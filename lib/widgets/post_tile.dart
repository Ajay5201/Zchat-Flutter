import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zchat/pages/post_screen.dart';
import 'package:zchat/widgets/post.dart';

import 'custom_image.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);
  showpost(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(postid: post.postId,userid: post.ownerId,)));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>showpost(context),
      child: cachedNetworkImage(post.mediourl),
    );
  }
}
