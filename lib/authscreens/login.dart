import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';




import 'package:firebase_auth/firebase_auth.dart'; 

class LoginPage extends StatefulWidget {
  
  @override
  LoginPageState createState() => LoginPageState();
}


class LoginPageState extends State<LoginPage> {

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;

  Widget logintext(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new Text("Stein Home", style: new TextStyle(color: Colors.red, fontSize: 25.0)),
    );
  }

  Widget createaccounttext(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new GestureDetector(
        child: new Text("Create New Account", style: new TextStyle(color: Colors.red, fontSize: 18.0)),
        onTap: (){
          Navigator.of(context).pushReplacementNamed('/signup');
        },
      )
    );
  }

  Widget forgotpasswordtext(){
    return new Padding(
      padding: EdgeInsets.only(top:40.0),
      child: new GestureDetector(
        child: new Text("Forget your password", style: new TextStyle(color: Colors.red, fontSize: 18.0)),
        onTap: (){

        },
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

   signin(){
     setState(() {
      isLoading = true; 
     });
    FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text, password: passwordController.text)
                      .then((user) {
                        setState(() {
                          isLoading = false; 
                        });
                        print(user);
                    Navigator.of(context).pushReplacementNamed('/board');
                  }).catchError((e) {
                    setState(() {                      
                            isLoading = false; 
                    });
                    myToast(context, e);
                    print(e);
                  });
  }

  void myToast(BuildContext context, var e){
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        duration: Duration(seconds: 5),
      )
    );
  }

  Widget loginbutton(){
    return new Padding(
      padding: EdgeInsets.only(top: 20.0),
           
      child: new RaisedButton(
        color: Colors.red,
        onPressed: (){
          signin();
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
          loginbutton(),
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
          child: isLoading
          ? new Center(
            child: SpinKitCubeGrid (
              color: Colors.green,
              size: 50.0,
              //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
)
          ) :
          new Center(
            child: ListView(
              children: <Widget>[
                new Column(
              children: <Widget>[
                logintext(),
                emailfield(),
                passwordfield(),
                rowpad(),
                createaccounttext(),
                forgotpasswordtext()
               
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
