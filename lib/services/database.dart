import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';

class DatabaseService{ 
  final String uid;
  DatabaseService({required this.uid});
  
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async { 
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.docs.map((doc){ 
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Brew(
        name: data['name'] ?? '',
        strength: data['strength'] ?? 0,
        sugars: data['sugars'] ?? '0'
      );
    }).toList();
  }
  
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
    if (data != null){
      return UserData(
        uid: uid,
        name: data['name'] ?? '',
        sugars: data['sugars'] ?? '',
        strength: data['stregth'] ?? 0,
      );
    } else {
      throw Exception('Data is null');
    }
  }

  //get brews stream
  Stream<List<Brew>> get brews { 
    return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData{ 
    return brewCollection.doc(uid).snapshots()
    .map(_userDataFromSnapshot);
  }
}