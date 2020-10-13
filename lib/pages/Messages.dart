import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/progressss.dart';
import 'package:timeago/timeago.dart' as timeago;
class Message extends StatefulWidget {
  final String profileID;
  Message({this.profileID});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  TextEditingController comm=TextEditingController();
  handlecom()
  {
    print("vijay");
    return StreamBuilder<QuerySnapshot>(
        stream: messref.document(Currentuser.id).collection('sender').document(widget.profileID).collection('messs').orderBy('timestamp',descending: true).snapshots(),
        //orderBy('timestamp',descending: true).snapshots(),//orderBy('timestamp' ,descending: false).snapshots(),
        // ignore: missing_return
        builder: (context,snapshot)
        // ignore: missing_return, missing_return
        {
          if(!snapshot.hasData)
          {
            return circularProgresssbar();
          }
          print("v2");
          List<Messages> comment=[];

          snapshot.data.documents.forEach((doc){
            print("ajay");
            comment.add(Messages.fromDocument(doc));
          });
          return ListView(
            reverse: true,
            children: comment,
          );


        });
  }
  addMess()
  {
    messref.document(Currentuser.id).collection('sender').document(widget.profileID).collection('messs').add({
      'username':Currentuser.username,
      'message':comm.text,
      'userid':widget.profileID,
      'photourl':Currentuser.photourl,
      'timestamp':DateTime.now(),
    });//{
    messref.document(widget.profileID).collection('sender').document(Currentuser.id).collection('messs').add({
      'username':Currentuser.username,
      'message':comm.text,
      'userid':widget.profileID,
      'photourl':Currentuser.photourl,
      'timestamp':DateTime.now(),
    });
    msgretrival.document(Currentuser.id).collection('sender').document(widget.profileID).setData({
      "timestamp":DateTime.now()
    });
    msgretrival.document(widget.profileID).collection('sender').document(Currentuser.id).setData({
      "timestamp":DateTime.now()
    });

    //{
    comm.clear();
    //});
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
     // ,
      //  ),
        title: Text("                      Chat",style: TextStyle(
          fontFamily: "signatra",
          fontSize: 35.0
        ),),
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
                  labelText: "Write a message"
              ),

            ),
            trailing: OutlineButton(
              onPressed: addMess,
              child: Text(
                  "SEND"
              ),
              borderSide: BorderSide.none,
            ),
          )
        ],
      ),
    );
  }
}
class Messages extends StatelessWidget {
  final String username;
  final String userid;
  final String profileurl;
  final String message;
  final Timestamp timestamp;

  Messages({this.username,this.userid,this.profileurl,this.message,this.timestamp});
  factory Messages.fromDocument(DocumentSnapshot doc)
  {
    return Messages(
      username: doc['username'],
      userid: doc['userid'],
      profileurl: doc['photourl'],
      message: doc['message'],
      timestamp: doc['timestamp'],
    );
  }
  @override
  Widget build(BuildContext context) {
    return// Column(
      //children: <Widget>[
        ListTile(
          title: Text(message),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(profileurl),
          ),
          subtitle: Text(timeago.format(timestamp.toDate())),
        );
        //Divider()
      //],
    //);
  }
}
