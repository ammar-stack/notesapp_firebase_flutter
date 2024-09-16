import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:starting_firebase/services/firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //accessing the firestore class
  final FirestoreService firestoreService = FirestoreService();

  //text controller for having control of text entered
  final TextEditingController controllerText = TextEditingController();

  //open a dialogue box upon clicking a floating action button
  void openNoteBox({String? docId}){
     showDialog(context: context, builder: (context)=> AlertDialog(
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent
          ),
          onPressed: (){
            //add a new note
            if(docId == null){
              firestoreService.addNote(controllerText.text);
            }
            else{
              firestoreService.updateNote(docId, controllerText.text);
            }
            //clearing textfield after notes have been added
            controllerText.clear();
            //popping out to main screen
            Navigator.pop(context);
          }, 
          child:const Text("Save"))
      ],
      content: Container(
        decoration:const BoxDecoration(
        ),
        child: TextField(
          controller: controllerText,
          decoration:const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a Note'
          ),
        ),
      ),
     ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:const Text("Notes App",style: TextStyle(color: Colors.white),),
          centerTitle: true,
          backgroundColor: Colors.lightBlue,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue,
          onPressed: (){
            openNoteBox();
          },
          child:const Icon(Icons.add,color: Colors.white,),),
        body: StreamBuilder(
          stream: firestoreService.getNotesStream(), 
          builder: (context,snapshot){
            //if we have some data
            if(snapshot.hasData){
              List notesList = snapshot.data!.docs;

              //display a list
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context,index){
                //get individual document
                DocumentSnapshot document = notesList[index];
                String docId = document.id;
                //get note from each doc
                Map<String,dynamic> data = document.data() as Map<String,dynamic>;
                String noteText = data['note'];
                //display as a list tile
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal:8.0),
                  child: Card(
                    color: Colors.blueGrey,
                    child: ListTile(
                      title: Text(noteText,style:const TextStyle(color: Colors.white),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: (){
                              openNoteBox(docId: docId);
                            }, 
                            icon:const Icon(Icons.edit,color: Colors.white,)),
                          IconButton(
                            onPressed: (){
                              firestoreService.deleteNote(docId);
                            }, 
                            icon:const Icon(Icons.delete,color:Colors.white))
                        ],
                      ),
                    ),
                  ),
                );
              });
            }
            else{
              return const Center(child: Image(image: AssetImage('assets/nonotes.jpeg'),height: 150,width: 200,));
            }
          }),
     
    );
  }
}