class GameTile {
  final String id;
  int value;
  bool isNew;
  bool isMerged;
  bool isHighlight;

  GameTile({
    required this.id,
    required this.value,
    this.isNew = false,
    this.isMerged = false,
    this.isHighlight = false,
  });

  GameTile copyWith({
    String? id,
    int? value,
    bool? isNew,
    bool? isMerged,
    bool? isHighlight,
  }) {
    return GameTile(
      id: id ?? this.id,
      value: value ?? this.value,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
      isHighlight: isHighlight ?? this.isHighlight,
    );
  }

  @override
  String toString() => 'Tile($value, id:$id)';
}

