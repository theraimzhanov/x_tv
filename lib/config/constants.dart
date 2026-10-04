/// Constants used throughout the app.
class AppConstants {
  AppConstants._();

  // Supabase — replace with your own project credentials
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // RevenueCat
  static const String revenueCatApiKey = 'YOUR_REVENUECAT_API_KEY';

  // Free episode threshold
  static const int freeEpisodeLimit = 5;

  // Video controller pool size
  static const int videoPoolSize = 3;

  // App info
  static const String appName = 'X TV';
  static const String appVersion = 'v1.0.2';
  static const String appTagline = 'Short Drama, Big Stories';

  // Subscription
  static const String monthlyPlanId = 'xtv_vip_monthly';
  static const String yearlyPlanId = 'xtv_vip_yearly';
  static const String monthlyPrice = '\$9.99 / month';
  static const String yearlyPrice = '\$59.99 / year';

  // Genre categories
  static const List<String> genres = [
    'All',
    'Billionaire',
    'Revenge',
    'Romance',
    'CEO',
    'Suspense',
    'Family Drama',
  ];

  // Supported languages
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'es': 'Spanish',
    'id': 'Indonesian',
    'vi': 'Vietnamese',
  };
}
