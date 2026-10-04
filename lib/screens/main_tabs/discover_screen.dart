import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../../widgets/common_widgets.dart';

/// Tab 2: Discover screen with hero carousel, categories, and trending content.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late PageController _heroPageController;
  int _currentHeroPage = 0;
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    _heroPageController = PageController(viewportFraction: 0.92);
    _startAutoSlide();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_heroPageController.hasClients) {
        final nextPage = (_currentHeroPage + 1) % 5;
        _heroPageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _heroPageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  void _onDramaSelected(Drama drama) {
    final content = context.read<ContentProvider>();
    content.setCurrentDrama(drama);
    // Switch to shorts tab — done via the dashboard parent
    // For now, show a snack bar as feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${drama.title}'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, content, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                // App Bar with search
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Discover',
                              style: AppTextStyles.displayMedium,
                            ),
                            const Spacer(),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Search bar
                        GestureDetector(
                          onTap: () {
                            // Navigate to search screen
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.search_rounded,
                                  color: AppColors.textMuted,
                                  size: 22,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Search dramas, genres...',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Hero Featured Carousel
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 280,
                    child: PageView.builder(
                      controller: _heroPageController,
                      itemCount:
                          content.trendingDramas.take(5).length,
                      onPageChanged: (index) {
                        setState(() => _currentHeroPage = index);
                      },
                      itemBuilder: (context, index) {
                        final drama = content.trendingDramas[index];
                        return _HeroCard(
                          drama: drama,
                          onTap: () => _onDramaSelected(drama),
                        );
                      },
                    ),
                  ),
                ),

                // Hero page indicator
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        content.trendingDramas.take(5).length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: index == _currentHeroPage ? 24 : 8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: index == _currentHeroPage
                                ? AppColors.primary
                                : AppColors.textMuted.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Category Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: AppConstants.genres.length,
                        itemBuilder: (context, index) {
                          final genre = AppConstants.genres[index];
                          final isSelected = content.selectedGenre == genre;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () => content.setSelectedGenre(genre),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? AppColors.primaryGradient
                                      : null,
                                  color: isSelected
                                      ? null
                                      : AppColors.surfaceLight,
                                  borderRadius: BorderRadius.circular(20),
                                  border: isSelected
                                      ? null
                                      : Border.all(color: AppColors.divider),
                                ),
                                child: Text(
                                  genre,
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),

                // Top 10 Trending
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'Top 10 Trending Today'),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          content.trendingDramas.take(10).length,
                      itemBuilder: (context, index) {
                        final drama = content.trendingDramas[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 140,
                            child: DramaPosterCard(
                              title: drama.title,
                              imageUrl: drama.posterUrl,
                              rating: drama.rating,
                              rank: index + 1,
                              onTap: () => _onDramaSelected(drama),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // New Releases
                const SliverToBoxAdapter(
                  child: SectionHeader(title: 'New Releases'),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: content.newReleases.take(8).length,
                      itemBuilder: (context, index) {
                        final drama = content.newReleases[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: SizedBox(
                            width: 140,
                            child: DramaPosterCard(
                              title: drama.title,
                              imageUrl: drama.posterUrl,
                              rating: drama.rating,
                              episodeCount: drama.totalEpisodes,
                              onTap: () => _onDramaSelected(drama),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Genre grid — filtered dramas
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: content.selectedGenre == 'All'
                        ? 'All Dramas'
                        : '${content.selectedGenre} Hits',
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final drama = content.filteredDramas[index];
                        return DramaPosterCard(
                          title: drama.title,
                          imageUrl: drama.posterUrl,
                          rating: drama.rating,
                          episodeCount: drama.totalEpisodes,
                          onTap: () => _onDramaSelected(drama),
                        );
                      },
                      childCount: content.filteredDramas.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Drama drama;
  final VoidCallback? onTap;

  const _HeroCard({required this.drama, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  drama.bannerUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.surfaceLight,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.3, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Genre chips
                      Wrap(
                        spacing: 6,
                        children: drama.genres.take(2).map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              g,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        drama.title,
                        style: AppTextStyles.headlineLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        drama.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              'Watch Now',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
