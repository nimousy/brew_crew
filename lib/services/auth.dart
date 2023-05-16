import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object based on firebase user
  MyUser? _userFromFirebaseUser(User? user){ 
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user{
    return _auth
      .authStateChanges()
      .map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try{ 
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in with email and pass
  Future signInWithEmailAndPassword(String email, String password) async { 
    try{ 
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch(e){ 
      print(e.toString());
      return null;
    }
  }

  //register with email and pass
  Future registerWithEmailAndPassword(String email, String password) async { 
    try{ 
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      await DatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);
    } catch(e){ 
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async { 
    try{ 
      return await _auth.signOut();
    } catch(e){ 
      print(e.toString());
      return null;
    }
  }

}

