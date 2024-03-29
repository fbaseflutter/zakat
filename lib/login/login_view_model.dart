import 'package:firebase_auth/firebase_auth.dart';

import '../base.dart';
import '../database_utils.dart';
import 'navigator.dart';

class LoginViewModel extends BaseViewModel<LoginNavigator>{

  var firebaseAuth = FirebaseAuth.instance;
  void login(String email,String password)async{
    String? message=null;
    try {
      navigator?.showLoading(isDismissable: true);
      print('dialog shown');
      var result = await firebaseAuth.signInWithEmailAndPassword(email: email,
          password: password);
      // read user from Database
      var userObj =  await DataBaseUtils.readUser(result.user?.uid ??"");
      if(userObj==null){
        message = 'Failed to complete Sign in , please try register again';
      }else {
        // goto home
        navigator?.gotoHome(userObj);
      }
    } on FirebaseAuthException catch (e) {
      message = 'Wrong Email or password';
    } catch (e) {
      message = 'something went wrong';
    }
    navigator?.hideDialog();
    if(message!=null){
      navigator?.showMessage(message);
    }
  }
}