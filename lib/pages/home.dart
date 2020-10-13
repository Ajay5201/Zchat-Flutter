

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/create_account.dart';
import 'activity_feed.dart';
import 'profile.dart';
import 'search.dart';
import 'timeline.dart';
import 'upload.dart';
final GoogleSignIn googleSignIn=GoogleSignIn( scopes: <String>[
  'email',
],);
final msgretrival=Firestore.instance.collection('messuser');
final messref=Firestore.instance.collection('messages');
final reference=Firestore.instance.collection("users");
final storeref=Firestore.instance.collection("posts");
final commentsref=Firestore.instance.collection('comments');
final feedref=Firestore.instance.collection('feed');
final followersref=Firestore.instance.collection('followers');
final followingref=Firestore.instance.collection('following');
final timelineref=Firestore.instance.collection('timeline');
final StorageReference storageref=FirebaseStorage.instance.ref();
User Currentuser;

DateTime join=DateTime.now();
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  bool auth=false;
  PageController pageController;
  int pindex=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print("hey buddy");
    pageController=PageController();
    googleSignIn.onCurrentUserChanged.listen((account){
     handleSignIn(account);
    },onError: (err){
      print("the error is $err");
    });
    googleSignIn.signInSilently(suppressErrors: false).then((account){
    handleSignIn(account);
    }).catchError((err){
      print(err);
    });

  }
  handleSignIn(GoogleSignInAccount account) async {
    if(account!=Null)
    {
      await handleusername();
      setState(() {
        auth=true;
      });

    }
    else{
      setState(() {
        auth=false;
      });
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  handleusername()async
  {
    final GoogleSignInAccount user=googleSignIn.currentUser;
    DocumentSnapshot doc=await reference.document(user.id).get();
    if(!doc.exists)
      {
        final username= await Navigator.push(context, MaterialPageRoute(builder: (context) =>
          CreateAccount()
        ));
        print("12");
        reference.document(user.id).setData({
          "id":user.id,
          "username":username,
          "photourl":user.photoUrl,
          "bio":"",
          "email":user.email,
          "displayname":user.displayName,
          "joinedDate":join,



        });
        await followersref.document(user.id).collection('userfollowers').document(user.id).setData({});

        doc=await reference.document(user.id).get();
      }
     Currentuser=User.fromDocument(doc);
    print(Currentuser);
    print(Currentuser.id);
    print(Currentuser
    .photourl);


  }


  login()
  {
    googleSignIn.signIn();
  }
Onchanged(int pindex)
{
  setState(() {
    this.pindex=pindex;
  });
}
Ontap(int pindex)
{
  pageController.animateToPage(
      pindex,duration: Duration(
    seconds: 2,

  ),
    curve: Curves.easeIn
  );
}
logout()
{
  googleSignIn.signOut();
}

  Scaffold authorised()
  {
    return Scaffold(
     body: PageView(
       children: <Widget>[
         //RaisedButton(
           //child: Text("logout"),
           //onPressed:logout,
         //),
         Timeline(Su:Currentuser?.id),
         Search(),


         //Search(),

         Upload(current:Currentuser),
         ActivityFeed(),

         Profile(profileId:Currentuser?.id),
       ],

       controller: pageController,
       onPageChanged: Onchanged,
       physics:NeverScrollableScrollPhysics(),


     ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pindex,
        onTap: Ontap,
        activeColor: Colors.red,

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.search)),


          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,size: 35.0,)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),


        ],

      ),


    );

  }
  Scaffold unauthorised()
  {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft
                ,
            end: Alignment.bottomLeft,
            colors: [
              Colors.teal,
              Colors.purple
            ]
          )
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Z_Chat",
            style: TextStyle(
              fontFamily: "Signatra",
              fontSize: 90.0
            ),),
            GestureDetector(
              onTap: (){
                login();
              },
              child: Container(
                width: 260.0,
                height: 60,

                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_sign.png'),
                    fit: BoxFit.cover
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return auth?authorised():unauthorised();
  }
}
