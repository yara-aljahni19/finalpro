



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'database.dart';




class Authentication with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createNewUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
      User? user = result.user;
      user = FirebaseAuth.instance.currentUser;

      if (user!= null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

        await database().createUserData(name, email, password, user!.uid);
        return user;


    } catch (e) {
      print(e.toString());
    }
  }


  Future loginUser(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return result.user;
    } catch (e) {

    }
  }

  Future sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }
/*
  Future<UserCredential> signInWithFacebook() async {
    final AccessToken result = (await FacebookAuth.instance.login()) as AccessToken;
// Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(result.token);
    //return the UserCredential
    return await _auth.signInWithCredential(facebookAuthCredential);
  }

*/
  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        UserCredential result = await _auth.signInWithCredential(
          GoogleAuthProvider.credential(
              idToken: googleAuth.idToken, accessToken: googleAuth.accessToken),
        );
        if (result.user != null) {
          return result .user;
        } else {
          return;
        }
      } else {
        throw FirebaseAuthException(
          message: "Sign in aborded by user",
          code: "ERROR_ABORDER_BY_USER",
        );
      }
    }
  }





}