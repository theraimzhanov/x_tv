import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/mock_data.dart';

/// Manages authentication state and user profile data.
class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isVip => _user?.isVip ?? false;
  String? get errorMessage => _errorMessage;

  /// Simulate checking for existing session on app launch.
  Future<bool> checkSession() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 2));
    _isLoading = false;
    notifyListeners();
    // Return false = no session, go to login.
    // In production, check Supabase session here.
    return false;
  }

  /// Sign in with email and password.
  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (!email.contains('@')) {
      _errorMessage = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    // Mock successful sign-in
    _user = UserProfile(
      id: 'user_001',
      email: email,
      displayName: email.split('@').first,
      isVip: false,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Register a new account.
  Future<bool> signUp(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill in all fields.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password != confirmPassword) {
      _errorMessage = 'Passwords do not match.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password must be at least 6 characters.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _user = UserProfile(
      id: 'user_new',
      email: email,
      displayName: name,
      isVip: false,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Send password reset email.
  Future<bool> sendPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (email.isEmpty || !email.contains('@')) {
      _errorMessage = 'Please enter a valid email address.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Social sign-in (mock).
  Future<bool> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1500));
    _user = UserProfile(
      id: 'google_user',
      email: 'user@gmail.com',
      displayName: 'Google User',
      isVip: false,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> signInWithApple() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1500));
    _user = UserProfile(
      id: 'apple_user',
      email: 'user@icloud.com',
      displayName: 'Apple User',
      isVip: false,
      createdAt: DateTime.now(),
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  /// Toggle VIP status (mock purchase).
  void toggleVip() {
    if (_user != null) {
      _user = _user!.copyWith(
        isVip: !_user!.isVip,
        vipExpiresAt: DateTime.now().add(const Duration(days: 30)),
      );
      notifyListeners();
    }
  }

  /// Sign out.
  void signOut() {
    _user = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Delete account.
  Future<void> deleteAccount() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// Manages drama content, episodes, likes, saves, and watch history.
class ContentProvider extends ChangeNotifier {
  List<Drama> _allDramas = [];
  List<Drama> _trendingDramas = [];
  List<Drama> _newReleases = [];
  List<Drama> _savedDramas = [];
  List<WatchHistoryItem> _watchHistory = [];
  final Map<String, List<Episode>> _episodesCache = {};
  final Set<String> _likedDramaIds = {};
  String _selectedGenre = 'All';
  bool _isLoading = false;

  // Feed state
  int _currentFeedIndex = 0;
  Drama? _currentFeedDrama;
  int _currentEpisodeNumber = 1;

  List<Drama> get allDramas => _allDramas;
  List<Drama> get trendingDramas => _trendingDramas;
  List<Drama> get newReleases => _newReleases;
  List<Drama> get savedDramas => _savedDramas;
  List<WatchHistoryItem> get watchHistory => _watchHistory;
  String get selectedGenre => _selectedGenre;
  bool get isLoading => _isLoading;
  int get currentFeedIndex => _currentFeedIndex;
  Drama? get currentFeedDrama => _currentFeedDrama;
  int get currentEpisodeNumber => _currentEpisodeNumber;

  List<Drama> get filteredDramas {
    if (_selectedGenre == 'All') return _allDramas;
    return _allDramas
        .where((d) => d.genres.contains(_selectedGenre))
        .toList();
  }

  /// Load all data.
  Future<void> loadContent() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 800));

    _allDramas = MockData.dramas;
    _trendingDramas = MockData.trendingDramas;
    _newReleases = MockData.newReleases;
    _savedDramas = List.from(MockData.savedDramas);
    _watchHistory = List.from(MockData.watchHistory);

    if (_allDramas.isNotEmpty) {
      _currentFeedDrama = _allDramas.first;
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Episode> getEpisodes(String dramaId) {
    if (!_episodesCache.containsKey(dramaId)) {
      _episodesCache[dramaId] = MockData.getEpisodesForDrama(dramaId);
    }
    return _episodesCache[dramaId]!;
  }

  void setSelectedGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  void setFeedIndex(int index) {
    _currentFeedIndex = index;
    if (index < _allDramas.length) {
      _currentFeedDrama = _allDramas[index];
      _currentEpisodeNumber = 1;
    }
    notifyListeners();
  }

  void setCurrentEpisode(int episodeNumber) {
    _currentEpisodeNumber = episodeNumber;
    notifyListeners();
  }

  void setCurrentDrama(Drama drama) {
    _currentFeedDrama = drama;
    _currentEpisodeNumber = 1;
    notifyListeners();
  }

  bool isLiked(String dramaId) => _likedDramaIds.contains(dramaId);

  void toggleLike(String dramaId) {
    if (_likedDramaIds.contains(dramaId)) {
      _likedDramaIds.remove(dramaId);
    } else {
      _likedDramaIds.add(dramaId);
    }
    notifyListeners();
  }

  bool isSaved(String dramaId) =>
      _savedDramas.any((d) => d.id == dramaId);

  void toggleSave(Drama drama) {
    if (isSaved(drama.id)) {
      _savedDramas.removeWhere((d) => d.id == drama.id);
    } else {
      _savedDramas.add(drama);
    }
    notifyListeners();
  }

  void removeSavedDrama(String dramaId) {
    _savedDramas.removeWhere((d) => d.id == dramaId);
    notifyListeners();
  }
}
