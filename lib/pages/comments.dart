import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/progressss.dart';
import 'package:timeago/timeago.dart' as timeago;

class Comments extends StatefulWidget {
  final String postid;
  final String ownerid;
  final String mediaurl;
  Comments({this.postid,this.ownerid,this.mediaurl});
  @override
  CommentsState createState() => CommentsState(
    postid: this.postid,
    ownerid: this.ownerid,
    mediaurl: this.mediaurl
  );
}

class CommentsState extends State<Comments> {
  final String postid;
  final String ownerid;
  final String mediaurl;
  TextEditingController comm=TextEditingController();

  CommentsState({this.postid,this.ownerid,this.mediaurl});
  handlecom()
  {
 return StreamBuilder<QuerySnapshot>(
  stream: commentsref.document(postid).collection('comments').orderBy('timestamp' ,descending: false).snapshots(),
  // ignore: missing_return
  builder: (context,snapshot)
  // ignore: missing_return, missing_return
  {
 if(!snapshot.hasData)
   {
     return circularProgresssbar();
   }
   List<Comment> comment=[];
 snapshot.data.documents.forEach((doc){
   comment.add(Comment.fromDocument(doc));
 });
 return ListView(
   children: comment,
 );


  });
  }
  addcomment()
  {
    commentsref.document(postid).collection('comments').add({
      'username':Currentuser.username,
      'comment':comm.text,
      'userid':ownerid,
      'photourl':Currentuser.photourl,
      'timestamp':DateTime.now(),
    });
    bool isnotpost=ownerid!=Currentuser.id;
    if(isnotpost) {
      feedref.document(ownerid).collection('userfeed').add({
        "type": "comment",
        "username": Currentuser.username,
        "userid": Currentuser.id,
        "userprofilepic": Currentuser.photourl,
        "postid": postid,
        "medioarl": mediaurl,
        "timestamp": join,
        "comment": comm.text
      });
    }
    comm.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child:handlecom()
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: comm,
              decoration: InputDecoration(
                labelText: "Write a comment"
              ),

            ),
            trailing: OutlineButton(
              onPressed: addcomment,
              child: Text(
                "POST"
              ),
              borderSide: BorderSide.none,
            ),
          )
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userid;
  final String profileurl;
final String comment;
final Timestamp timestamp;

Comment({this.username,this.userid,this.profileurl,this.comment,this.timestamp});
factory Comment.fromDocument(DocumentSnapshot doc)
{
  return Comment(
    username: doc['username'],
    userid: doc['userid'],
    profileurl: doc['photourl'],
    comment: doc['comment'],
    timestamp: doc['timestamp'],
  );
}
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(comment),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profileurl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        ),
        Divider()
      ],
    );
  }
}
