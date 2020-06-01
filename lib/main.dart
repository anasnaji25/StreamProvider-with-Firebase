import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterstreamprovider/logic/model/user_model.dart';
import 'package:flutterstreamprovider/logic/services/firebase_services.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

void main() {
  runApp(
    MaterialApp(
      home: AuthenticateUser(),
    ),
  );
}

class AuthenticateUser extends StatefulWidget {
  @override
  _AuthenticateUserState createState() => _AuthenticateUserState();
}

class _AuthenticateUserState extends State<AuthenticateUser> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    FirebaseUser firebaseUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Firebase Auth'),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 7,
                  right: MediaQuery.of(context).size.width / 3,
                ),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.indigo,
                          width: 4.0,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width / 7,
                  right: MediaQuery.of(context).size.width / 3,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'enter password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.indigo,
                        width: 4.0,
                      ),
                    ),
                  ),
                  controller: passwordController,
                  keyboardType: TextInputType.number,
                ),
              ),
              MaterialButton(
                onPressed: () async{
                  if(formKey.currentState.validate()){
                    registerUser();
                  }
                },
                color: Colors.grey[500],
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )).user;
    if (user != null) {
      setState(() {
        print(user.uid);
      });
    }
  }
}

class CheckFunction extends StatefulWidget {
  @override
  _CheckFunctionState createState() => _CheckFunctionState();
}

class _CheckFunctionState extends State<CheckFunction> {
  String response = 'no response';

  @override
  Widget build(BuildContext context) {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'helloWorld')
          ..timeout = const Duration(seconds: 30);

    return Scaffold(
      appBar: AppBar(
        title: Text('FireBase Cloud Function'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                response,
                style: TextStyle(
                  fontSize: 50.0,
                ),
              ),
              MaterialButton(
                color: Colors.grey[400],
                onPressed: () async {
                  try {
//                    final HttpsCallableResult result = await callable.call(
//                      <String, dynamic>{
//                        'message': 'hello world!',
//                        'count': _responseCount,
//                      },
//                    );
                    dynamic result = await callable.call();
                    print(result.data);
                    setState(() {
                      response = result.data;
                    });
                  } on CloudFunctionsException catch (e) {
                    print('caught firebase functions exception');
                    print(e.code);
                    print(e.message);
                    print(e.details);
                  } catch (e) {
                    print('caught generic exception');
                    print(e);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Trigger Me',
                    style: TextStyle(
                      color: Colors.indigo,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FirebaseServices firebaseServices = FirebaseServices();

    return MaterialApp(
      home: StreamProvider(
        create: (BuildContext context) => firebaseServices.getUserList(),
        child: ViewUserPage(),
      ),
    );
  }
}

class ViewUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    List userList = Provider.of<List<UserModel>>(context);
    FirebaseServices firebaseServices = FirebaseServices();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Stream Provider'),
      ),
      body: userList == null ? CircularProgressIndicator() :  ListView.builder(
        itemCount: userList.length,
        itemBuilder: (_, int index) => Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
            ),
            title: Text(
              userList[index].name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            subtitle: Text(
              userList[index].age,
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          firebaseServices.addUser();
        },
        backgroundColor: Colors.amber,
      ),
    );
  }
}*/
