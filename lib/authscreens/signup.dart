import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:steinhome/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

class SignupPage extends StatefulWidget {
  
  @override
  SignupPageState createState() => SignupPageState();
}


class SignupPageState extends State<SignupPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController verifypasswordController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  bool isLoading = false;

  void myToast(BuildContext context, var e){
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 10),
      )
    );
  }

  signup() {
    setState(() {                      
                            isLoading = true; 
                    });
    if(passwordController.text == verifypasswordController.text){
      print(emailController.text);
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text)
    .then((signedInUser) {
      setState(() {                      
                            isLoading = false; 
                    });
      print(signedInUser);
    
      UserManagement().storeNewUser(mobileController.text, passwordController.text, signedInUser, context);
    }).catchError((e) {
      setState(() {                      
                            isLoading = false; 
                    });
      print(e);
      myToast(context, e);
    });
    }else{
      print('password mismatch');
      myToast(context, 'password mismatch');
    }
    
  }

  Widget welcometext(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new Text("Stein Home", style: new TextStyle(color: Colors.red, fontSize: 25.0)),
    );
  }

  Widget logintext(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new GestureDetector(
        onTap: (){
          Navigator.of(context).pushReplacementNamed('/login');
        },
        child: new Text("Login into your Account", style: new TextStyle(color: Colors.red, fontSize: 18.0)),
      )
    );
  }

 
  Widget emailfield(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new TextField(
        controller: emailController,
        decoration: new InputDecoration(
          icon: new Icon(Icons.email, color: Colors.green,),
          labelText: "Email Address",
          hintText: 'Enter Email Address',
          fillColor: Colors.amber,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
         ),
          keyboardType: TextInputType.emailAddress,
          style: new TextStyle(
            fontFamily: "Poppins",
                         

        ),
      )
    );
  }

   Widget mobilefield(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new TextField(
        controller: mobileController,
        decoration: new InputDecoration(
          icon: new Icon(Icons.phone, color: Colors.green,),
          labelText: "Mobile",
          hintText: 'Enter Mobile Digits',
          fillColor: Colors.amber,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
         ),
          keyboardType: TextInputType.phone,
          style: new TextStyle(
            fontFamily: "Poppins",
                         

        ),
      )
    );
  }


   Widget passwordfield(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new TextField(
        
        controller: passwordController,
        decoration: new InputDecoration(
          icon: new Icon(Icons.lock, color: Colors.green,),
          labelText: "Password",
          hintText: 'Enter Password',
          fillColor: Colors.amber,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
         ),
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          style: new TextStyle(
            fontFamily: "Poppins",
                         

        ),
      )
    );
  }

Widget verifypasswordfield(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new TextField(
        controller: verifypasswordController,
        decoration: new InputDecoration(
          icon: new Icon(Icons.lock, color: Colors.green,),
          labelText: "Verify Password",
          hintText: 'Enter Verify Password',
          fillColor: Colors.amber,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(),
          ),
         ),
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          style: new TextStyle(
            fontFamily: "Poppins",
                         

        ),
      )
    );
  }


  Widget signupbutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: new RaisedButton(
        color: Colors.red,
        onPressed: (){
          signup();
        },
        child: new Text("Continue"),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
    );
  }

  Widget cancelbutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: new RaisedButton(
        color: Colors.amberAccent,
        onPressed: (){
          emailController.text = "";
          passwordController.text = "";
          verifypasswordController.text = "";
          mobileController.text = "";
        },
        child: new Text("Cancel"),
        elevation: 8.0,
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),

     
    )
    );
  }

  Widget rowpad(){
    return new Padding(
      padding: EdgeInsets.all(10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          signupbutton(),
          cancelbutton()
        ],
      ),
    );
  }


  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Board"),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white10,
        child: new Container(
          child: new Center(
            child: ListView(
              children: <Widget>[
                new Column(
              children: <Widget>[
                welcometext(),
                mobilefield(),
                emailfield(),
                passwordfield(),
                verifypasswordfield(),
                rowpad(),
                logintext(),
               
               
              ],
            ),
              ],
            )
          ),
        ),
      )
    );
  }
}
