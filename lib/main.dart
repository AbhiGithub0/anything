import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

TextEditingController numberController = TextEditingController();
TextEditingController otpController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
FirebaseMessaging firebaseMessaging = FirebaseMessaging();

String verifyId;


phoneAuthMethod() async{
  print("object");

  print("+91${numberController.text}");

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
        phoneNumber: "+91${numberController.text}",
        timeout: Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) async{
          print("verificationCompleted");
          await auth.signInWithCredential(credential);

        },
        verificationFailed: (FirebaseAuthException e) {


          print(e.message);

          if (e.code == 'invalid') {
            print('Number is not valid');
          }
          print("verificationFailed");

        },
        codeSent: (String verificationId,int smsToken) async {
          verifyId = verificationId;
          print("codeSent");



        },
        codeAutoRetrievalTimeout: (String verificationId) async {
          print("codeAutoRetrievalTimeout");


        }
        ).catchError((onError){
          print(onError.message);
    });
}
otpFun() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  String smsCode = "${otpController.text}";
  PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verifyId, smsCode: smsCode);
  await auth.signInWithCredential(phoneAuthCredential);
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();

    firebaseMessaging.getToken().then((value) {
      print(value);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:80.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: numberController,

                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Mobile No.'


                  ),
                ),
                SizedBox(height: 50,),
                RaisedButton(child:Text('Submit'),onPressed: (){
                  phoneAuthMethod();
                  setState(() {

                  });
                }),
                SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: otpController,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: 'OTP'
                  ),
                ),
                SizedBox(height: 50,),

                RaisedButton(child:Text('Login'),onPressed: (){
                  otpFun();
                  setState(() {

                  });
                  if (_formKey.currentState.validate()) {

                  }
                }),



              ],
            ),
          ),
        ),
      ),
    );
  }
}

