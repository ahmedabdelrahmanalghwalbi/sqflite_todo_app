import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sql/db/notes_collection.dart';
import 'package:sql/models/note_model.dart';
import 'package:sql/views/edit_note_page.dart';

class NoteDetail extends StatefulWidget {
  final int noteId;
  const NoteDetail({required this.noteId});
  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late Note note;
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    note = await NotesCollection.instance.read(widget.noteId);
    setState(() {
      isLoading = false;
    });
  }

  Widget deleteButton() {
    return IconButton(
        onPressed: () async {
          await NotesCollection.instance.deleteNote(widget.noteId);
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.red,
        ));
  }

  Widget editButton() {
    return IconButton(
        onPressed: () async {
          if (isLoading) return;
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EditNotePage(note: note)));
          refreshNotes();
        },
        icon: const Icon(
          Icons.edit_outlined,
          color: Colors.yellow,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(
                        color: Colors.white38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                        color: Colors.white38, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
