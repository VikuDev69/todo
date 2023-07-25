class NoteModel1 {
  int? id;
  final String tittle;
  final String desc;
  final String dateandtime;

  NoteModel1({
    this.id,
    required this.tittle,
    required this.desc,
    required this.dateandtime,
  });

  NoteModel1.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        tittle = res["tittle"],
        desc = res["desc"],
        dateandtime = res["dateandtime"];
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "tittle": tittle,
      "desc": desc,
      "dateandtime": dateandtime,
    };
  }
}
