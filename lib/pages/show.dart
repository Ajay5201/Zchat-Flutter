import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/Messages.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/pages/timeline.dart';
import 'package:zchat/widgets/progressss.dart';
class ShowMessage extends StatefulWidget {
  @override
  _ShowMessageState createState() => _ShowMessageState();
}

class _ShowMessageState extends State<ShowMessage> {
  List<String> messagelist=[];
  //int j=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowing();

  }
  getFollowing()async
  {
    QuerySnapshot snapshot=await msgretrival.document(Currentuser.id).collection('sender').orderBy("timestamp",descending: true).getDocuments();
    List<String> ms=snapshot.documents.map((doc)=>doc.documentID).toList();
    setState(() {
      messagelist=ms;
    });
    // for(int i=0;i<messagelist.length;i++)
    // {
    print(messagelist[0]);
    for(i=0;i<3;i++)
      {
        print(i);
      }
    //}

  }




  containsNoting()
  {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end:  Alignment.bottomRight,
              colors: [
                Colors.teal,
                Colors.purple.shade400
              ]
          )
      ),
      child: Column(
        children: <Widget>[
          Flexible(
            //  child: PNG,
            child: SvgPicture.asset("assets/images/no_content.svg"),
          )
        ],
      ),
    );
  }
  int i=0;
  biluf()
  {
    //for(int k=0;k<messagelist.length;i++) {
      //print(k);
      return Container(

        child: FutureBuilder<QuerySnapshot>(


          future:usersRef.getDocuments(),
          //msgretrival.document(Currentuser.id).collection('sender').orderBy("timestamp",descending: true).getDocuments(),

          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgresssbar();
            }
            //print(k);
            List<UserResultt> activities = [];
            snapshot.data.documents.forEach((doc){
            User user = User.fromDocument(doc);
            bool verify =messagelist.contains(user.id);
            if(!verify)
              {
                return;
              }
            else {
              UserResultt us = UserResultt(user: user);
              activities.add(us);
            }
            // activities.add(ActivityFeedItem.FromDocument(doc));
            });

            return ListView(
              children: activities,
            );

          },

        ),
      );

    //}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Messages"),
        ),
        body:messagelist==null?containsNoting(): biluf()
    );
  }
}
class UserResultt extends StatelessWidget {
  final User user;

  const UserResultt({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: GestureDetector(
            onTap: ()=>Showprofilee(context,profileId: user.id),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user.photourl),
              ),
              title: Text(user.username,style: TextStyle(
                  color: Colors.black,
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold
              ),),
              subtitle: Text(user.displayname,style: TextStyle(

              ),),
            ),

          ),



        ),
        Divider(
          height: 2.0,

        )
      ],
    );
  }
}
Showprofilee(BuildContext context,{String profileId}) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => Message(profileID: profileId,)));
}

