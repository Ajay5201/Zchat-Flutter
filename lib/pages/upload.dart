import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zchat/models/user.dart';
import 'package:zchat/pages/home.dart';
import 'package:zchat/widgets/progressss.dart';
import 'package:image/image.dart' as Im;
class Upload extends StatefulWidget {
  final User current;
  Upload({this.current});
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> with AutomaticKeepAliveClientMixin<Upload>{
  bool isuploading=false;
File file1;
String postid=Uuid().v4();
TextEditingController cap=TextEditingController();
TextEditingController loc=TextEditingController();
compressImage()async
{
 final tempdir= await getTemporaryDirectory();
 final path=tempdir.path;
 Im.Image imgfile =Im.decodeImage(file1.readAsBytesSync());
 final compimg=File('$path/img_$postid.jpg')..writeAsBytesSync(Im.encodeJpg(imgfile,quality: 80));
 setState(() {
   file1=compimg;
 });

}
Future<String> uploadImage(imagefile)async
{
 StorageUploadTask uptask=storageref.child('post_$postid.jpg').putFile(imagefile);
 StorageTaskSnapshot task=await uptask.onComplete;
 String url=await task.ref.getDownloadURL();
 return url;
}
createpost({String url,String caption,String location})async
{
  await storeref.document(widget.current.id).collection("userposts").document(postid).setData({
    "postId":postid,
    "ownerId":widget.current.id,
    "username":widget.current.username,
    "mediourl":url,
    "caption":caption,
    "location":location,
    "timestamp":join
    ,
    "like":{}
  });
}
handlesubmit()async
{
setState(() {
  isuploading=true;
  print("true airuchu");
});
await compressImage();
print("compress airuchu");
String durl=await uploadImage(file1);
print("upload airuchu");
createpost(url: durl,caption: cap.text,location: loc.text);
print("post create airuchu");
loc.clear();
cap.clear();
//postid=Uuid().v4();

setState(() {
  isuploading=false;
  file1=null;

postid=Uuid().v4();
});

}
selectImage(parentcontext)
{
  return showDialog(
    context: parentcontext,
    // ignore: missing_return
    builder: (context){
      return SimpleDialog(
        title: Text("Select your option"),

        children: <Widget>[
          SimpleDialogOption(
            child: Text("Picture from camera"),
            onPressed: ()async{Navigator.pop(context);
            File file=await ImagePicker.pickImage(source:ImageSource.camera,maxHeight: 700,maxWidth: 900 );
             setState(() {
               file1=file;

             });
            },
          ),
          SimpleDialogOption(
            child: Text("Picture from gallery"),
            onPressed: ()async{
              Navigator.pop(context);
             File file=await ImagePicker.pickImage(source: ImageSource.gallery,maxWidth: 900,maxHeight: 700);
             setState(() {
               file1=file;
             });
              },
          ),
          SimpleDialogOption(
            child: Text("close"),
            onPressed: ()=>Navigator.pop(context),
          ),
        ],
      );
    }
  );
}


  Container svgcontainer()
  {

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pinkAccent,
            Colors.teal
          ]
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
           child:SvgPicture.asset("assets/images/upload.svg",height: 260,)),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: RaisedButton(
              onPressed: ()=>selectImage(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              ),
              color: Colors.deepOrange,
              child: Text("Upload Image",style: TextStyle(
                fontSize: 22.0,
                color: Colors.white
              ),),
            ),
          )
        ],
      ),
    );
  }
  Scaffold uploader()
  {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: (){
            setState(() {
              file1=null;
            });

          },

        ),
        backgroundColor: Colors.blueGrey,
        title: Text("               Upload Image",style: TextStyle(
          color: Colors.black
              ,
          fontWeight: FontWeight.bold
        ),),
actions: <Widget>[
  FlatButton(
    onPressed: isuploading?null:()=>handlesubmit(),
    child: Text("POST",style: TextStyle(
      color: Colors.black,
      fontSize: 19.0,
      fontWeight: FontWeight.bold
    ),),
  )
],
      ),
      body: Column(
        children: <Widget>[
          isuploading?linearProgresssbar():Text(""),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 20.0),

                child: Container(
                  //color: Colors.black,

                  height: 300.0,
                  width:MediaQuery.of(context).size.width *0.9,

  child:AspectRatio(
    aspectRatio: 16/9,
  child:   Container(

                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(file1),
                          fit: BoxFit.cover,
                        )
                      ),

  ),
),

              ),
            ),
          ),
          Flexible(
              child: Padding(
              padding: const EdgeInsets.only(top:10.0),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(widget.current.photourl),

                  ),
                  title: Container(
                    width: 250.0,
                    child: TextField(
                      controller: cap,
                      decoration: InputDecoration(
                        hintText: "Enter the caption"
                            ,
                        border: InputBorder.none
                      ),
                    ),
                  ),

                ),


            ),
          ),
          Divider(
            height: 0.3,
          ),

             Flexible(
               child: Padding(
                 padding: const EdgeInsets.only(top:10.0),
                 child: ListTile(
                  leading: Icon(
                    Icons.pin_drop,color: Colors.deepOrange,size: 35.0,

                  ),

                  title: TextField(
                    controller: loc,
                    decoration: InputDecoration(
                        hintText: "Mark your Location"
                        ,
                        border: InputBorder.none

                    ),
                  ),
            ),
               ),
             ),
          Padding(
            padding: const EdgeInsets.only(top:20.0),
            child: Container(
              height: 50.0,
              child: RaisedButton.icon(onPressed: getLocation, icon: Icon(Icons.my_location,color: Colors.white,),
                  color:Colors.blue,


                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                  )
                  ,label: Text("Get Current location",style: TextStyle(
                color: Colors.white,fontWeight: FontWeight.bold,
              ),)
              ),
            ),
          )

        ],
      ),
    );
  }
   getLocation()async
  {
    Position position=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark=await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemarks=placemark[0];
    String formattedaddres="${placemarks.locality},${placemarks.country}";
    loc.text=formattedaddres;


  }
  bool get wantKeepAlive =>true;
 @override
  Widget build(BuildContext context) {
   super.build(context);
    return file1==null?svgcontainer():uploader();
  }
}
