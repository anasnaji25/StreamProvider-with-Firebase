import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class CheckFunction extends StatefulWidget {
  @override
  _CheckFunctionState createState() => _CheckFunctionState();
}

class _CheckFunctionState extends State<CheckFunction> {
  String response = 'no response';

  @override
  Widget build(BuildContext context) {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'addUser')
          ..timeout = const Duration(seconds: 30);

    return Scaffold(
      appBar: AppBar(
        title: Text('FireBase Cloud Function'),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: () async {
            try {
              final HttpsCallableResult result = await callable.call(
                <String, dynamic>{
                  'name': 'Jason Fridge',
                  'age': '27yrs',
                },
              );
              setState(() {
                response = result.toString();
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
          }),
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
//              MaterialButton(
//                color: Colors.grey[400],
//                onPressed: () async {
//                  try {
////                    final HttpsCallableResult result = await callable.call(
////                      <String, dynamic>{
////                        'message': 'hello world!',
////                        'count': _responseCount,
////                      },
////                    );
//                    dynamic result = await callable.call();
//                    print(result.data);
//                    setState(() {
//                      response = result.data;
//                    });
//                  } on CloudFunctionsException catch (e) {
//                    print('caught firebase functions exception');
//                    print(e.code);
//                    print(e.message);
//                    print(e.details);
//                  } catch (e) {
//                    print('caught generic exception');
//                    print(e);
//                  }
//                },
//                child: Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: Text(
//                    'Trigger Me',
//                    style: TextStyle(
//                      color: Colors.indigo,
//                      fontSize: 20.0,
//                    ),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }
}
