/// Data models for the X TV app.

class UserProfile {
  final String id;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final bool isVip;
  final DateTime? vipExpiresAt;
  final String preferredLanguage;
  final String subtitleLanguage;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.avatarUrl,
    this.isVip = false,
    this.vipExpiresAt,
    this.preferredLanguage = 'en',
    this.subtitleLanguage = 'en',
    required this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      displayName: json['display_name'] as String? ?? 'User',
      avatarUrl: json['avatar_url'] as String?,
      isVip: json['is_vip'] as bool? ?? false,
      vipExpiresAt: json['vip_expires_at'] != null
          ? DateTime.tryParse(json['vip_expires_at'] as String)
          : null,
      preferredLanguage: json['preferred_language'] as String? ?? 'en',
      subtitleLanguage: json['subtitle_language'] as String? ?? 'en',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? displayName,
    String? avatarUrl,
    bool? isVip,
    DateTime? vipExpiresAt,
    String? preferredLanguage,
    String? subtitleLanguage,
  }) {
    return UserProfile(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVip: isVip ?? this.isVip,
      vipExpiresAt: vipExpiresAt ?? this.vipExpiresAt,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      subtitleLanguage: subtitleLanguage ?? this.subtitleLanguage,
      createdAt: createdAt,
    );
  }
}

class Drama {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String bannerUrl;
  final List<String> genres;
  final int totalEpisodes;
  final double rating;
  final int likeCount;
  final bool isCompleted;
  final DateTime releaseDate;

  const Drama({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.bannerUrl,
    required this.genres,
    required this.totalEpisodes,
    required this.rating,
    this.likeCount = 0,
    this.isCompleted = false,
    required this.releaseDate,
  });

  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      posterUrl: json['poster_url'] as String? ?? '',
      bannerUrl: json['banner_url'] as String? ?? '',
      genres: List<String>.from(json['genres'] as List? ?? []),
      totalEpisodes: json['total_episodes'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      likeCount: json['like_count'] as int? ?? 0,
      isCompleted: json['is_completed'] as bool? ?? false,
      releaseDate: DateTime.tryParse(json['release_date'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class Episode {
  final String id;
  final String dramaId;
  final int episodeNumber;
  final String videoUrl;
  final String? thumbnailUrl;
  final Duration duration;
  final bool isFree;

  const Episode({
    required this.id,
    required this.dramaId,
    required this.episodeNumber,
    required this.videoUrl,
    this.thumbnailUrl,
    required this.duration,
    this.isFree = false,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      dramaId: json['drama_id'] as String,
      episodeNumber: json['episode_number'] as int? ?? 1,
      videoUrl: json['video_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String?,
      duration: Duration(seconds: json['duration_seconds'] as int? ?? 0),
      isFree: json['is_free'] as bool? ?? false,
    );
  }
}

class WatchHistoryItem {
  final String dramaId;
  final String dramaTitle;
  final String posterUrl;
  final int lastEpisodeWatched;
  final int totalEpisodes;
  final DateTime watchedAt;

  const WatchHistoryItem({
    required this.dramaId,
    required this.dramaTitle,
    required this.posterUrl,
    required this.lastEpisodeWatched,
    required this.totalEpisodes,
    required this.watchedAt,
  });

  double get progressPercent =>
      totalEpisodes > 0 ? lastEpisodeWatched / totalEpisodes : 0.0;
}
