import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/activity_feed.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/progressss.dart';

class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search>{
  Future<QuerySnapshot> results;
  TextEditingController textEditingController=TextEditingController();
  searchhandler(String person)
  {
   Future<QuerySnapshot> res=reference.where("username",isGreaterThanOrEqualTo:person ).getDocuments();
setState(() {
  results=res;
});
  }
  Container containsNoting()
  {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal,
                Colors.purple.shade400
              ]
          )
      ),
      child: Column(
        children: <Widget>[
          Flexible(child: SvgPicture.asset("assets/images/search.svg"))
        ],
      ),
    );
  }
  FutureBuilder containsSomething()
  {
    return FutureBuilder(
      future: results,
      // ignore: missing_return
      builder: (context,snapshot){
        if(!snapshot.hasData)
          {
             return circularProgresssbar();
          }
        List<UserResult> addedSearch=[];
        snapshot.data.documents.forEach((doc){

          User user=User.fromDocument(doc);
          UserResult userResult=UserResult(user: user);
          addedSearch.add(userResult);
        });
      return ListView(
        children: addedSearch,
      );
      },

    );
  }
  bool get wantKeepAlive =>true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Form(

          child: TextFormField(
            onFieldSubmitted:searchhandler,
            controller: textEditingController,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              hoverColor: Colors.black,
                hintText: "Search for a users",
                filled: true,
                focusColor: Colors.black,



              prefixIcon: Icon(Icons.account_box,size: 35.0,color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(Icons.close,color: Colors.black,),
                onPressed:(){
                  textEditingController.clear();
                  },
              )
            ),
          ),

        ),
      ),
      body:results==null?containsNoting():containsSomething()
    );
  }
}

class UserResult extends StatelessWidget {
  final User user;

  const UserResult({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: GestureDetector(
          onTap: ()=>Showprofile(context,profileId: user.id),
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
