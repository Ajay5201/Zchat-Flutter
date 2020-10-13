import 'dart:async';
//import 'dart:html';

import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/activity_feed.dart';
import 'package:zchat/pages/comments.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/custom_image.dart';
import 'package:zchat/widgets/progressss.dart';

class Post extends StatefulWidget {
  final String caption;
  final String location;
  final String mediourl;
  final String ownerId;
  final String postId;
  final String username;
  final dynamic likes;

  Post({
    this.caption,
    this.location,
    this.mediourl,
    this.ownerId,
    this.postId,
    this.username,
    this.likes,


  });

 factory Post.fromDocument(DocumentSnapshot doc)
 {
return Post(
  caption: doc['caption'],
  location: doc['location'],
  mediourl: doc['mediourl'],
  ownerId: doc['ownerId'],
  postId: doc['postId'],
  username: doc['username'],
  likes: doc['like'],

);
 }
 int getCount(likes)
 {
   if(likes==null)
     {
       return 0;
     }
   int count=0;
   likes.values.forEach((val){
     if(val==true)
       {
         count+=1;
       }
   });
   return count;
 }
  @override
  _PostState createState() => _PostState(
    caption: this.caption,
    mediourl: this.mediourl,
    location: this.location,
    postId: this.postId,
    username: this.username,
    ownerId: this.ownerId,
    likes: this.likes,
    likecount: getCount(this.likes)
  );
}

class _PostState extends State<Post> {
  final String currentuser=Currentuser?.id;
  final String caption;
  final String location;
  final String mediourl;
  final String ownerId;
  final String postId;
  final String username;
  Map likes;
  int likecount;
  bool isliked;
  bool showlike=false;

  _PostState({
    this.caption,
    this.location,
    this.mediourl,
    this.ownerId,
    this.postId,
    this.username,
    this.likes,
     this.likecount

  });
  buildheader() {
    return FutureBuilder(
      future: reference.document(ownerId).get(),
      // ignore: missing_return
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgresssbar();
          // ignore: missing_return
        }
        User user = User.fromDocument(snapshot.data);
        bool isowner=currentuser==ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(user.photourl),
          ),
          title: GestureDetector(
              onTap: ()=>Showprofile(context,profileId: user.id),
              child: Text(user.username)),
          subtitle: Text(location),
          trailing: isowner?IconButton(
            onPressed: () => shodepost(context),
            icon: Icon(Icons.more_vert),
          ):Text(""),
        );
      },
    );
  }
  shodepost(BuildContext pcontext)
  {
    return showDialog(context: pcontext,
    builder: (context)
    {
      return SimpleDialog(
        title: Text("Are you sure?"),
        children: <Widget>[
        SimpleDialogOption(
          onPressed:(){
            Navigator.pop(context);
            deletepost();
          },
          child: Text("Delete",style: TextStyle(color: Colors.redAccent),),
        ),
          SimpleDialogOption(
            onPressed:()=> Navigator.pop(context),
             child: Text("Cancel"),
          )
        ],
      );
    });
  }
  deletepost()async
  {
  storeref.document(ownerId).collection('userposts').document(postId).get().then((doc){
    if(doc.exists)
      {
        doc.reference.delete();
      }
  });
   storageref.child('post_$postId.jpg').delete();

  QuerySnapshot acti= await feedref.document(ownerId).collection('userfeed').where('postid',isEqualTo: postId).getDocuments();
  acti.documents.forEach((doc){
    if(doc.exists)
      {
        doc.reference.delete();
      }
  });
  QuerySnapshot com=await commentsref.document(postId).collection('comments').getDocuments();
  com.documents.forEach((doc){
    if(doc.exists)
      {
        doc.reference.delete();
      }
  });
  }
  handlepost()
  {
    bool _isliked=likes[currentuser]==true;
    if(_isliked)
      {
        storeref.document(ownerId).collection('userposts').document(postId).updateData({'like.$currentuser':false});
        setState(() {
          likecount-=1;
          isliked=false;
          likes[currentuser]=false;
        });
        removefeed();
      }
    else if(!_isliked)
      {
        storeref.document(ownerId).collection('userposts').document(postId).updateData({'like.$currentuser':true});
        setState(() {
          likecount+=1;
          isliked=true;
          likes[currentuser]=true;
          showlike=true;
        });
        feedref.
            document(ownerId).collection('userfeed').document(postId).setData({
          "type":"like",
          "username":Currentuser.username,
        "userid":Currentuser.id,
          "userprofilepic":Currentuser.photourl,
          "postid":postId,
          "medioarl":mediourl,
          "timestamp":join
        });
Timer(Duration(seconds: 1),(){
  setState(() {
    showlike=false;
  });
});
      }
  }
  removefeed()
  {
    feedref.document(ownerId).collection('userfeed').document(postId).get().then((doc){
      if(doc.exists)
        {
          doc.reference.delete();
        }
    });
  }
    buildimg()
    {
      return GestureDetector(
        onDoubleTap: handlepost,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            cachedNetworkImage(mediourl),
            showlike?Animator(
              duration: Duration(
                seconds: 1
              ),

              cycles: 0,
              curve: Curves.elasticOut,
              tween: Tween(begin: 0.8,end: 1.4),
                builder: (context, animatorState, child ) =>


                    Container(
                       // height: animatorState.value,
                        child: Icon(Icons.favorite,size: 120.0,color: Colors.deepOrange)),
              //builder: (anim)=>Transform.scale(
                //  scale:anim.value,
              //child: Icon(Icons.favorite,size: 80.0,color: Colors.redAccent),)

            ):Text("")
            //showlike?:Text(""),
          ],
        ),
      );
    }
    buildfooter()
    {
      return Column(

        children: <Widget>[

          Padding(padding: EdgeInsets.only(top: 20.0,),),
          Row(
            children: <Widget>[
            GestureDetector(
              onTap: handlepost,
              child: Icon(

                isliked?Icons.favorite:Icons.favorite_border,
                size: 28.0,
                color: Colors.pink,
              ),
            ),
              Padding(padding: EdgeInsets.only(right: 20.0)),
              GestureDetector(
                onTap: ()=>ShowComments(
                  context,
                  mediaurl: mediourl,
                  postid: postId,
                  ownerid: ownerId
                ),
                child: Icon(
                  Icons.message,
                  size: 28.0,
                  color: Colors.blue
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Text(" $likecount likes ",style: TextStyle(
                 fontWeight: FontWeight.bold,
                color: Colors.black
              ),)
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text("$username",style: TextStyle(
                       fontWeight: FontWeight.bold,
                    color: Colors.black
                ),),
              ),
              SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Text(caption),
              )
            ],
          ),

      SizedBox(
        height: 10.0,
      )
        ],
      );
    }

  @override
  Widget build(BuildContext context) {
    isliked=(likes[currentuser]==true);
    return  Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildheader(),
          buildimg(),
          buildfooter(),
        ],
      );

  }
}
ShowComments(BuildContext context,{String mediaurl,String postid,String ownerid})
{
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return Comments(
        mediaurl:mediaurl,
        postid:postid,
        ownerid:ownerid
    );
  }));
}