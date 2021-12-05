import 'package:flutter/material.dart';
import 'package:sql/db/notes_collection.dart';
import 'package:sql/models/note_model.dart';

class EditNotePage extends StatefulWidget {
  Note note;

  EditNotePage({required this.note});
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String description;
  late String title;

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.pop(context);
    }
  }

  Future updateNote() async {
    final note = widget.note.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description);
    await NotesCollection.instance.updateNote(note);
  }

  Future addNote() async {
    final note = Note(
        title: title,
        isImportant: true,
        number: number,
        description: description,
        createdTime: DateTime.now());
    await NotesCollection.instance.insert(note);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
