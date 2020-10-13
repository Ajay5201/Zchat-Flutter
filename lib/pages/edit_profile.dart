

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/comments.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/pages/timeline.dart';
import 'package:zchat/widgets/progressss.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  final _scaffold=GlobalKey<ScaffoldState>();
  bool bioup=true;
  bool dispup=true;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await reference.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayname;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Bio",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            errorText: bioup?null:"bio must not exceed 100 letters",
            hintText: "Update Bio",
          ),
        )
      ],
    );
  }
  validator()
  {
    setState(() {
      if(displayNameController.text.trim().length<3 || displayNameController.text.isEmpty)
      {
           dispup=false;
      }
      else{
        dispup=true;
      }
      if(bioController.text.length > 100)
        {
          bioup=false;
        }
      else
        {
          bioup=true;
        }
    });
    if(dispup==true && bioup==true)
      {
        reference.document(widget.currentUserId).updateData({
          "displayname":displayNameController.text,
          "bio":bioController.text
        });
        SnackBar snackBar =SnackBar(
          duration: Duration(
            seconds: 10
          ),
          content:Text("Profile updated!") ,);
        _scaffold.currentState.showSnackBar(snackBar);
       // Navigator.pop(context);

      }

    //Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgresssbar()
          : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                    CachedNetworkImageProvider(user.photourl),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            "Display Name",
                            style: TextStyle(color: Colors.grey),
                          )),
                      TextField(


                        controller: displayNameController,
                        decoration: InputDecoration(
                          hintText: "Update Display Name",
                          errorText: dispup?null:"Username must contain atleast 5 letters"
                        ),
                      ),
                      buildBioField(),
                    ],
                  ),
                ),
                RaisedButton(
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  ) ,
                  onPressed: validator,
                  color: Colors.deepOrange,
                  
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: ()  {
                         googleSignIn.signOut();
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    },
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
