import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sql/db/notes_collection.dart';
import 'package:sql/models/note_model.dart';
import 'package:sql/views/edit_note_page.dart';
import 'package:sql/views/note_detail.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    super.dispose();
    NotesCollection.instance.close();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NotesCollection.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : notes.isEmpty
                  ? const Text("No Notes")
                  : buildNotes()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => EditNotePage()));
          refreshNotes();
        },
        child: const Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildNotes() {
    return StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: notes.length,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          final note = notes[index];
          return GestureDetector(
            // child: NoteCardWidget(note:note,index:index),
            child: Container(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
                  [Random().nextInt(9) * 100],
              child: Center(
                child: Text(
                  notes[index].title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NoteDetail(noteId: note.id!)));
              refreshNotes();
            },
          );
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2));
  }
}
