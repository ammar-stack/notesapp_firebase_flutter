import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  //get collection from database
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');
  //CREATE - inserting a data
  Future<void> addNote(String note){
    return notes.add({
      'note' : note,
      'timestamp' : Timestamp.now()
    });
  }
  //UPDATE - updating existing note
  Future<void> updateNote(String docId,String newNote){
    return notes.doc(docId).update({
      'note' : newNote,
      'timestamp' : Timestamp.now()
    });
  }
  //DELETE - deleting data from database
  Future<void> deleteNote(String docId){
    return notes.doc(docId).delete();
  }
  //VIEW - viewing every note
  Stream<QuerySnapshot> getNotesStream(){
    final notesStream = notes.orderBy('timestamp', descending: false).snapshots();

    return notesStream;
  }
}