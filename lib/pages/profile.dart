import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/Messages.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/post.dart';
import 'package:zchat/widgets/post_tile.dart';
import 'package:zchat/widgets/progressss.dart';
import 'edit_profile.dart';





class Profile extends StatefulWidget {
  final String profileId;

  const Profile({Key key, this.profileId}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isfollowing=false;
  final String userid=Currentuser?.id;
  bool isloadong=false;
  List<Post> post=[];
  int postcount=0;
  String toggle="grid";
  int followingcount=0;
  int followerscount=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusersPosts();
    chechiffollowing();
    getfollowingcount();
    getfollowerscount();
  }
  getfollowerscount()async
  {
    QuerySnapshot snapshot=await followersref.document(widget.profileId).collection('userfollowers').getDocuments();
    setState(() {
      followerscount=snapshot.documents.length;
    });
  }
  getfollowingcount()async
  {
    QuerySnapshot snapshot=await followingref.document(widget.profileId).collection('userfollowing').getDocuments();
    setState(() {
      followingcount=snapshot.documents.length;
    });
  }
  chechiffollowing()async
  {
    DocumentSnapshot doc= await followersref.document(widget.profileId).collection('userfollowers').document(userid).get();
    setState(() {
      isfollowing=doc.exists;
    });
  }
  editprofile()//async
  {

  }

  
  Padding choice({String text,Function function})
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(30.0)
        ),
        width: 250,
        height: 27,
        child: FlatButton(
          onPressed:  ()async=> await Navigator.push(context, MaterialPageRoute(
              builder: (context)=>EditProfile(currentUserId: widget.profileId)
          )),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
  Padding choice1({String text})
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Colors.white
                ,
                border: Border.all(
                  color: Colors.black
                ),
                borderRadius: BorderRadius.circular(30.0)
            ),
            width: 125,
            height: 27,
            child: FlatButton(
              onPressed:()=>handleunfollowuser(),
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black,
                  fontWeight: FontWeight.w900
                ),
              ),

            ),

          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white
                ,
                border: Border.all(
                    color: Colors.black
                ),
                borderRadius: BorderRadius.circular(30.0)
            ),
            width: 125,
            height: 27,
            child: FlatButton(
              onPressed:()=>Navigator.push(context, MaterialPageRoute(builder:(context)=>Message(profileID: widget.profileId,) )),
              child: Text(
                "Message",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900
                ),
              ),

            ),

          ),
        ],
      ),
    );
  }
  Padding choice12({String text})
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(30.0)
        ),
        width: 250,
        height: 27,
        child: FlatButton(
          onPressed:()=>handlefollowuser(),
          child: Text(
            text,
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
  handlesubmit() {
    bool verification = userid == widget.profileId;
    if (verification) {
      return choice(text: "Edit Profile", function: editprofile());
    }
    else if (isfollowing==true) {
      return choice1(text: "UnFollow");
    }
    else if(isfollowing==false)
      {
        return choice12(text: "Follow");
      }
   // else
     // {
       // return Text("button");
      //}
  }
  handleunfollowuser()
  {
    setState(() {
      isfollowing=false;
    });
    followersref.document(widget.profileId).collection('userfollowers').document(userid).get().then((doc){
      if(doc.exists)
        {
          doc.reference.delete();
    }});
    followingref.document(userid).collection('userfollowing').document(widget.profileId).get().then((doc){
      if(doc.exists)
        {
          doc.reference.delete();
        }
    });
    feedref.document(widget.profileId).collection('userfeed').document(userid).get().then((doc){
      if(doc.exists)
      {
        doc.reference.delete();
      }
    });
  }

  handlefollowuser()
  {
     setState(() {
       isfollowing=true;
     });
     followersref.document(widget.profileId).collection('userfollowers').document(userid).setData({});
     followingref.document(userid).collection('userfollowing').document(widget.profileId).setData({});
     feedref.document(widget.profileId).collection('userfeed').document(userid).setData({
"type":"follow",
       "userid":userid,
       "ownerid":widget.profileId,
       "username":Currentuser.username,
       "timestamp":join,
       "userprofilepic":Currentuser.photourl,

     });
  }
  Column userinfo(String name,int count)
  {
    return Column(
      children: <Widget>[
        Text(
          count.toString(),style: TextStyle(
          fontWeight: FontWeight.bold,fontSize: 22.0
        ),
        ),
        Text(
          name,style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey
        ),
        )
      ],
    );
  }
  handleprofile()
  {
    return FutureBuilder(
      future: reference.document(widget.profileId).get(),
      // ignore: missing_return
      builder: (context,snapshot){
        if(!snapshot.hasData)
          {
            return circularProgresssbar();
          }
        //else {
          //return Container();
        //}
        User user=User.fromDocument(snapshot.data);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: CachedNetworkImageProvider("https://lh3.googleusercontent.com/a-/AOh14GidR5YgZKTqKR664ad5cLJMJn7QIBmnVcxNrO6N=s96-c"),
                  ),

              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        userinfo("Posts",postcount),
                        userinfo("following",followingcount),
                         userinfo("followers",followerscount),

                      ],
                    ),
                    handlesubmit(),
                  ],
                ),
              )
            ],
          ),
              Container(
                padding: EdgeInsets.only(top: 15.0),
                alignment: Alignment.centerLeft,
                child: Text(user.username,style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Container(
                padding: EdgeInsets.only(top: 4.0),
                alignment: Alignment.centerLeft,
                child: Text(user.displayname,style: TextStyle(

                  //color: Colors.black54,
                  fontWeight: FontWeight.bold
                ),),
              ),
              Container(
                padding: EdgeInsets.only(top: 4.0),
                alignment: Alignment.centerLeft,
                child: Text(user.bio,style: TextStyle(

                  //color: Colors.black54,
                    fontWeight: FontWeight.bold
                ),),
              )
            ],
          ),
        );
      },
    );
  }
  handleposts()
  {
     if(isloadong)
       {
        return circularProgresssbar() ;
       }
     else if(toggle=="list") {

        return Column(
        children: post,
       );
     }
     else if(toggle=="grid") {
       List<GridTile> gridtile = [];
       post.forEach((posts) => gridtile.add(GridTile(child: PostTile(posts),)));
       return GridView.count(crossAxisCount: 3,
         childAspectRatio: 1.0
         ,
         mainAxisSpacing: 2.5,
         crossAxisSpacing: 2.5,
         shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
         children: gridtile,
       );
     }
  }
  toggleScreen(String name)
  {
    if(name=="grid")
      {
        setState(() {
          toggle="grid";
        });
      }
    if(name=="list")
      {
        setState(() {
          toggle="list";
        });
      }
  }

  getusersPosts()async
  {
    setState(() {
      isloadong=true;
    });
    QuerySnapshot snapshot=await storeref.document(widget.profileId).collection('userposts').orderBy('timestamp',descending: true).getDocuments();
    setState(() {
      post=snapshot.documents.map((doc)=>Post.fromDocument(doc)).toList();
      postcount=snapshot.documents.length;
      isloadong=false;
    });

  }
  handleToggle()
  {
     return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          onPressed:()=> toggleScreen("grid"),
          icon: Icon(Icons.grid_on),
          color: toggle=="grid"?Colors.purple:Colors.blueGrey,
        ),
        IconButton(
          onPressed:()=> toggleScreen("list"),
          icon: Icon(Icons.list),
          color: toggle=="list"?Colors.purple:Colors.blueGrey,
        ),

      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: Center(
          child: Text("profile",style: TextStyle(
            fontSize: 30.0,
            fontFamily: "Signatra",
            color: Colors.white
          ),),
        ),
      ),
      body: ListView(
        children: <Widget>[
          handleprofile(),
          Divider(),
          handleToggle(),
          Divider(
            height: 0.0,
          ),
          handleposts(),
        ],
      ),
    );
  }
}
