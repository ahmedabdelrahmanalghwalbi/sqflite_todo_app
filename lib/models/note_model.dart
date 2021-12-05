const String tableName = 'notes';

class NotesFields {
  static final List<String> values = [
    id,
    title,
    isImportant,
    description,
    createdTime,
    number
  ];
  static const String id = '_id';
  static const String isImportant = 'isImportant';
  static const String number = 'number';
  static const String title = 'title';
  static const String description = 'description';
  static const String createdTime = 'createdTime';
}

class Note {
  final int? id;
  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final DateTime createdTime;

  const Note(
      {required this.createdTime,
      required this.description,
      this.id,
      required this.isImportant,
      required this.number,
      required this.title});

  Note copy({
    int? id,
    bool? isImportant,
    int? number,
    String? title,
    String? description,
    DateTime? createdTime,
  }) =>
      Note(
          id: id ?? this.id,
          isImportant: isImportant ?? this.isImportant,
          number: number ?? this.number,
          title: title ?? this.title,
          description: description ?? this.description,
          createdTime: createdTime ?? this.createdTime);

  Map<String, Object?> toJson() => {
        NotesFields.id: id,
        NotesFields.title: title,
        NotesFields.number: number,
        NotesFields.description: description,
        NotesFields.isImportant: isImportant ? 1 : 0,
        NotesFields.createdTime: createdTime.toIso8601String()
      };

  static Note fromJson(Map<String, Object?> json) => Note(
      id: json[NotesFields.id] as int?,
      createdTime: DateTime.parse(json[NotesFields.createdTime] as String),
      description: json[NotesFields.description] as String,
      title: json[NotesFields.title] as String,
      isImportant: json[NotesFields.isImportant] == 1,
      number: json[NotesFields.number] as int);
}
