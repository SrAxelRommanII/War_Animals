class PlayerProfile {
  final String id;
  final String username;
  final int level;
  final bool tutorialCompleted;

  PlayerProfile({
    required this.id,
    required this.username,
    required this.level,
    required this.tutorialCompleted,
  });

  bool get shouldShowGuide => level < 5 && !tutorialCompleted;

  factory PlayerProfile.fromMap(Map<String, dynamic> map) {
    return PlayerProfile(
      id: map['id'] ?? '',
      username: map['username'] ?? 'Recluta',
      level: map['level'] ?? 1,
      tutorialCompleted: map['tutorial_completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'level': level,
      'tutorial_completed': tutorialCompleted,
    };
  }
}