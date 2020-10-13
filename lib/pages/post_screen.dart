import 'package:flutter/material.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/post.dart';
import 'package:zchat/widgets/progressss.dart';

class PostScreen extends StatelessWidget {
  final String postid;
  final String userid;
  PostScreen({this.postid,this.userid});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: storeref.document(userid).collection('userposts').document(postid).get(),
      builder: (context,snapshot)
      {
        if(!snapshot.hasData)
          {
            return circularProgresssbar();
          }
        Post post=Post.fromDocument(snapshot.data);
        return Center(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blueGrey.shade900,
              title: Center(child: Text("Post",style: TextStyle(
                fontFamily: "signatra",
                fontSize: 36.0
              ),)),
            ),
            body: ListView(
              children: <Widget>[
               Container(
                child:post ,
              ),
              ],
            ),
          ),
        );
      },
    );
  }
}
