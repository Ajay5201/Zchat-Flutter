import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String username;
  final _form=GlobalKey<FormState>();
  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        title: Text("Set  Up  Your  Profile",style: TextStyle(
          fontFamily: "signatra",
          fontSize: 30.0

        ),),
      ),
      body: Container(
       // decoration: BoxDecoration(
         /// gradient: LinearGradient(
            //begin: Alignment.topLeft,
            //end: Alignment.bottomRight,
            //colors: [
              //Colors.teal,
              //Colors.purple
           // ]
          //)
        //),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Padding(

                padding: const EdgeInsets.only(bottom:12.0),
                child: Text(
                  "CREATE YOUR USERNAME",style: TextStyle(
                  fontSize: 25.0,

                  fontWeight: FontWeight.bold
                ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Form(
                key: _form,
                child: TextFormField(
                  // ignore: missing_return
                  validator: (val){
                    if(val.trim().length<5||val.isEmpty)
                      {
                        // ignore: missing_return
                        return "Username is too short";
                      }
                    else if(val.trim().length>25)
                      {
                        return "Username is too long";
                      }
                    else
                      {
                        return null;
                      }
                  },
                  onChanged: (val){
                    username=val;
                  },
                  cursorColor: Colors.black45,
                  decoration: InputDecoration(
                    hintText: "Must have atleast 6 characters",

                    labelText: "username",
                    labelStyle: TextStyle(fontSize: 20.0),
                    border: OutlineInputBorder(
                    )
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                if(_form.currentState.validate()) {
                  _form.currentState.save();
                  Navigator.pop(context, username);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal
                        ,
                    borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  height: 55.0,
                  width: double.infinity,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
