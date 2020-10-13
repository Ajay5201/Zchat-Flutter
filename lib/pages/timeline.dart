import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zchat/models/user.dart';

import 'package:zchat/pages/home.dart';
import 'package:zchat/pages/search.dart';
import 'package:zchat/pages/show.dart';


//import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/post.dart';
import 'package:zchat/widgets/progressss.dart';

//FirebaseUser log;
final usersRef = Firestore.instance.collection('users');

//final  retrievall =Firestore.instance.collection('verification');
class Timeline extends StatefulWidget {
  final String Su;

  Timeline({this.Su});

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final User cu;
  _TimelineState({this.cu});
  List<Post> posts;
 // List<Post> posts;
  //List<Post> posts;
  List<String> followingList = [];


  @override
  void initState() {
    super.initState();
    //print(widget.currentUser.id);
    getTimeline();
    // print(widget.currentUser.id);
    getFollowing();
  }

  getTimeline() async {
    //print("hello${widget.currentUser.id}");
   // print("l"+widget.Su);
    QuerySnapshot snapshot = await timelineref
        .document(widget.Su)
        .collection('timelineposts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> posts1 = snapshot.documents.map((doc) => Post.fromDocument(doc)).toList();
    setState(() {
      posts = posts1;
    });
  }

  buildTimeline() {
    if (posts == null) {
      //print("hi da"+cu.id);
      return circularProgresssbar();
    } else if (posts.isEmpty) {
      return buildUsersToFollow();
    } else {
      return ListView(children: posts);
    }
  }
  getFollowing() async {
    //print("si"+Currentuser.id);
    QuerySnapshot snapshot = await followingref
        .document(Currentuser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingList = snapshot.documents.map((doc) => doc.documentID).toList();
    });
  }
  buildUsersToFollow() {
    print("21");
    return StreamBuilder<QuerySnapshot>(

      stream:reference.snapshots(),
      builder: (context,snapshot) {
        if (!snapshot.hasData) {
          return circularProgresssbar();
        }
        print(22);
        List<UserResult> userResults = [];
        print("99");
        snapshot.data.documents.forEach((doc) {
          print("95");
          User user = User.fromDocument(doc);
          final bool isAuthUser = Currentuser.id == user.id;
          print("35");
          final bool isFollowingUser = followingList.contains(user.id);
          // remove auth user from recommended list
          if (isAuthUser) {
            print("2");
            return;
          } else if (isFollowingUser) {
            print("1");
            return;
          } else {
            print("user u may ");
            UserResult userResult = UserResult(user: user);
            userResults.add(userResult);
          }
        });
        return Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_add,size: 25.0,
                    ),
                    SizedBox(
                      width: 15.0,

                    ),
                    Text(" Peoples You May Know",style: TextStyle(fontSize: 25.0),)
                  ],
                ),
              ),
              Column(
                  children: userResults),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.photo_camera,size: 25.0,color: Colors.white,),
          ),
          backgroundColor: Colors.blueGrey.shade900,
          title: Text("Z_CHAT",style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontFamily: "Signatra"
            ,

          ),),
          actions: <Widget>[
            IconButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowMessage())),
              icon: Icon(Icons.message,size: 25.0,color: Colors.white,),
            )
          ],
        ),
        //body:RefreshIndicator(
        //onRefresh:() => getTimeline(),
        //child: buildtimeline(),

        //  )
        body: RefreshIndicator(
            onRefresh: () => getTimeline(), child: buildTimeline()));
    //);
  }
}
