import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/pages/post_screen.dart';
import 'package:zchat/pages/profile.dart';
import 'package:zchat/widgets/progressss.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Center(child: Text("Activity feed",style: TextStyle(fontFamily: "signatra",fontSize: 30.0),)),

      ),
      body: Container(
        child: FutureBuilder (
          future: feedref.document(Currentuser.id).collection('userfeed').orderBy("timestamp",descending: true).getDocuments(),
          builder: (context,snapshot){
            if(!snapshot.hasData)
              {
                return circularProgresssbar();
              }
            List<ActivityFeedItem> activities=[];
            snapshot.data.documents.forEach((doc){

              activities.add(ActivityFeedItem.FromDocument(doc));
            });
            return ListView(
              children: activities,
            );
          },
        ),
      ),
    );
  }
}
Widget mediapreview;
String Actifeed;
class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userid;
  final String type;
  final String mediaurl;
  final String postid;
  final String photourl;
  final String commentstring;
  final Timestamp timestamp;
  ActivityFeedItem({this.username,this.userid,this.type,this.mediaurl,this.postid,this.photourl,this.commentstring,this.timestamp});

  factory ActivityFeedItem.FromDocument(DocumentSnapshot doc)
  {
    return ActivityFeedItem(
      username: doc['username'],
      userid: doc['userid'],

      type:doc['type'] ,
      mediaurl: doc['medioarl'],
      postid: doc['postid'],
      photourl: doc['userprofilepic'],
      commentstring: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
  showpost(context)
  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen(postid: postid,userid: userid,)));
  }
  configuremediapreview(context)
  {
    if(type=='like'||type=='comment')
      {
        mediapreview=GestureDetector(
          onTap: ()=>showpost(context),
          child: Container(
            height: 50.0,
            width: 50.0,
            child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(mediaurl)
                  )
                ),
              ),
            ),


          ),
        );
      }else{
      mediapreview=Text('');

    }
    if(type=='like')
      {
        Actifeed=" Liked your Post";
      }
    else if(type=='comment')
      {
        Actifeed=" Replies $commentstring";
      }
    else if(type=='follow')
      {
        Actifeed=" Started Following you";
      }
  }
  @override
  Widget build(BuildContext context) {
    configuremediapreview(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.blueGrey,
        child: ListTile(
          leading:CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(photourl),
          ),
          title: GestureDetector(
            onTap:()=> Showprofile(context,profileId: userid),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
children: [
       TextSpan(
         text: username,
         style: TextStyle(
             fontWeight: FontWeight.bold,

         )
       ),
       TextSpan(
         text: Actifeed
       )
                  ]
              ),

            ),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate())
          ),
          trailing: mediapreview,
        ),

      ),
    );
  }
}
 Showprofile(BuildContext context,{String profileId})
 {
   Navigator.push(context, MaterialPageRoute(builder: (context)=>Profile(profileId: profileId,)));
 }