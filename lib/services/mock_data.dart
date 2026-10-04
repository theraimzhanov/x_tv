import '../models/models.dart';
import '../config/constants.dart';

/// Mock data generator for development. Replace with real Supabase queries
/// when connecting to your backend.
class MockData {
  MockData._();

  static final List<Drama> dramas = [
    Drama(
      id: '1',
      title: 'The Hidden Billionaire',
      description:
          'A secretly wealthy heir disguises himself as a janitor to find true love, only to discover a conspiracy threatening his family empire.',
      posterUrl: 'https://picsum.photos/seed/drama1/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama1b/800/450',
      genres: ['Billionaire', 'Romance'],
      totalEpisodes: 85,
      rating: 4.8,
      likeCount: 24500,
      isCompleted: true,
      releaseDate: DateTime(2025, 3, 15),
    ),
    Drama(
      id: '2',
      title: 'Sweet Revenge',
      description:
          'After being betrayed by her fiancé and his mistress, she returns three years later as a powerful CEO to reclaim everything they stole.',
      posterUrl: 'https://picsum.photos/seed/drama2/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama2b/800/450',
      genres: ['Revenge', 'CEO'],
      totalEpisodes: 60,
      rating: 4.6,
      likeCount: 18200,
      isCompleted: true,
      releaseDate: DateTime(2025, 5, 1),
    ),
    Drama(
      id: '3',
      title: 'CEO\'s Secret Wife',
      description:
          'A contract marriage between a cold CEO and an ordinary girl turns into an unexpected love story that shakes the corporate world.',
      posterUrl: 'https://picsum.photos/seed/drama3/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama3b/800/450',
      genres: ['CEO', 'Romance'],
      totalEpisodes: 72,
      rating: 4.7,
      likeCount: 31000,
      isCompleted: false,
      releaseDate: DateTime(2025, 8, 20),
    ),
    Drama(
      id: '4',
      title: 'Trapped in Suspense',
      description:
          'Five strangers wake up in a locked mansion with no memory. They must solve puzzles to survive before midnight — or face a terrifying truth.',
      posterUrl: 'https://picsum.photos/seed/drama4/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama4b/800/450',
      genres: ['Suspense'],
      totalEpisodes: 45,
      rating: 4.9,
      likeCount: 42000,
      isCompleted: true,
      releaseDate: DateTime(2025, 1, 10),
    ),
    Drama(
      id: '5',
      title: 'Family Bonds',
      description:
          'Three siblings separated at birth reunite 20 years later, but dark family secrets threaten to tear them apart once more.',
      posterUrl: 'https://picsum.photos/seed/drama5/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama5b/800/450',
      genres: ['Family Drama'],
      totalEpisodes: 55,
      rating: 4.5,
      likeCount: 15600,
      isCompleted: true,
      releaseDate: DateTime(2025, 6, 30),
    ),
    Drama(
      id: '6',
      title: 'Revenge of the Heir',
      description:
          'Thrown out of his own empire by corrupt relatives, the young heir returns with a new identity and a ruthless plan.',
      posterUrl: 'https://picsum.photos/seed/drama6/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama6b/800/450',
      genres: ['Billionaire', 'Revenge'],
      totalEpisodes: 90,
      rating: 4.7,
      likeCount: 28700,
      isCompleted: false,
      releaseDate: DateTime(2025, 9, 5),
    ),
    Drama(
      id: '7',
      title: 'Love in the Shadows',
      description:
          'A shy bookstore owner and a mysterious nightclub singer discover they share a past neither can remember.',
      posterUrl: 'https://picsum.photos/seed/drama7/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama7b/800/450',
      genres: ['Romance', 'Suspense'],
      totalEpisodes: 50,
      rating: 4.4,
      likeCount: 12800,
      isCompleted: true,
      releaseDate: DateTime(2025, 4, 12),
    ),
    Drama(
      id: '8',
      title: 'The CEO\'s Substitute Bride',
      description:
          'When the real bride runs away, her twin sister is forced to marry the ruthless CEO. But what starts as deception becomes dangerously real.',
      posterUrl: 'https://picsum.photos/seed/drama8/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama8b/800/450',
      genres: ['CEO', 'Romance'],
      totalEpisodes: 82,
      rating: 4.8,
      likeCount: 35400,
      isCompleted: true,
      releaseDate: DateTime(2025, 2, 14),
    ),
    Drama(
      id: '9',
      title: 'Billionaire\'s Lost Daughter',
      description:
          'Raised in poverty, she discovers she is the missing heiress to a billion-dollar dynasty — but someone will kill to keep her from the truth.',
      posterUrl: 'https://picsum.photos/seed/drama9/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama9b/800/450',
      genres: ['Billionaire', 'Family Drama'],
      totalEpisodes: 68,
      rating: 4.6,
      likeCount: 22100,
      isCompleted: true,
      releaseDate: DateTime(2025, 7, 18),
    ),
    Drama(
      id: '10',
      title: 'Double Identity',
      description:
          'By day she\'s a meek office worker; by night, the city\'s most feared underground fighter. When her boss discovers her secret, the stakes double.',
      posterUrl: 'https://picsum.photos/seed/drama10/400/600',
      bannerUrl: 'https://picsum.photos/seed/drama10b/800/450',
      genres: ['Suspense', 'Revenge'],
      totalEpisodes: 40,
      rating: 4.5,
      likeCount: 19300,
      isCompleted: true,
      releaseDate: DateTime(2025, 10, 1),
    ),
  ];

  static List<Episode> getEpisodesForDrama(String dramaId) {
    final drama = dramas.firstWhere(
      (d) => d.id == dramaId,
      orElse: () => dramas.first,
    );
    return List.generate(
      drama.totalEpisodes,
      (index) => Episode(
        id: '${dramaId}_ep_${index + 1}',
        dramaId: dramaId,
        episodeNumber: index + 1,
        videoUrl:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        thumbnailUrl:
            'https://picsum.photos/seed/${dramaId}_ep${index + 1}/320/180',
        duration: Duration(minutes: 1 + (index % 3), seconds: 30 + (index % 30)),
        isFree: (index + 1) <= AppConstants.freeEpisodeLimit,
      ),
    );
  }

  static List<WatchHistoryItem> watchHistory = [
    WatchHistoryItem(
      dramaId: '1',
      dramaTitle: 'The Hidden Billionaire',
      posterUrl: 'https://picsum.photos/seed/drama1/400/600',
      lastEpisodeWatched: 12,
      totalEpisodes: 85,
      watchedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WatchHistoryItem(
      dramaId: '3',
      dramaTitle: 'CEO\'s Secret Wife',
      posterUrl: 'https://picsum.photos/seed/drama3/400/600',
      lastEpisodeWatched: 45,
      totalEpisodes: 72,
      watchedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static final List<Drama> savedDramas = [dramas[0], dramas[2], dramas[7]];

  static final List<Drama> trendingDramas =
      List.from(dramas)..sort((a, b) => b.likeCount.compareTo(a.likeCount));

  static final List<Drama> newReleases =
      List.from(dramas)..sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
}
