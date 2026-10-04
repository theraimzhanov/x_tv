import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import '../overlays/episode_selector_sheet.dart';
import '../overlays/vip_paywall_sheet.dart';

/// Tab 1: TikTok-style vertical scrolling shorts feed.
class ShortsFeedScreen extends StatefulWidget {
  const ShortsFeedScreen({super.key});

  @override
  State<ShortsFeedScreen> createState() => _ShortsFeedScreenState();
}

class _ShortsFeedScreenState extends State<ShortsFeedScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, content, _) {
        final dramas = content.allDramas;

        if (dramas.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: dramas.length,
            onPageChanged: (index) {
              content.setFeedIndex(index);
            },
            itemBuilder: (context, index) {
              final drama = dramas[index];
              return _VideoFeedItem(drama: drama);
            },
          ),
        );
      },
    );
  }
}

class _VideoFeedItem extends StatefulWidget {
  final Drama drama;

  const _VideoFeedItem({required this.drama});

  @override
  State<_VideoFeedItem> createState() => _VideoFeedItemState();
}

class _VideoFeedItemState extends State<_VideoFeedItem>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = true;
  bool _showPlayPause = false;
  bool _showHeart = false;
  double _videoProgress = 0.3; // Mock progress
  late AnimationController _heartAnimController;
  late Animation<double> _heartScaleAnim;

  @override
  void initState() {
    super.initState();
    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _heartScaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 1.4), weight: 40),
      TweenSequenceItem(tween: Tween<double>(begin: 1.4, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_heartAnimController);
  }

  @override
  void dispose() {
    _heartAnimController.dispose();
    super.dispose();
  }

  void _onSingleTap() {
    setState(() {
      _isPlaying = !_isPlaying;
      _showPlayPause = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _showPlayPause = false);
      }
    });
  }

  void _onDoubleTap() {
    final content = context.read<ContentProvider>();
    if (!content.isLiked(widget.drama.id)) {
      content.toggleLike(widget.drama.id);
    }
    setState(() => _showHeart = true);
    _heartAnimController.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _openEpisodeSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EpisodeSelectorSheet(drama: widget.drama),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.watch<ContentProvider>();
    final auth = context.watch<AuthProvider>();
    final isLiked = content.isLiked(widget.drama.id);
    final isSaved = content.isSaved(widget.drama.id);
    final currentEp = content.currentEpisodeNumber;

    return GestureDetector(
      onTap: _onSingleTap,
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video background (mock with poster)
          Image.network(
            widget.drama.bannerUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.surface,
              child: const Center(
                child: Icon(Icons.videocam_off, color: AppColors.textMuted, size: 64),
              ),
            ),
          ),

          // Dark gradient overlays
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),

          // Play/Pause center icon
          if (_showPlayPause)
            Center(
              child: AnimatedOpacity(
                opacity: _showPlayPause ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

          // Double-tap heart animation
          if (_showHeart)
            Center(
              child: AnimatedBuilder(
                animation: _heartScaleAnim,
                builder: (context, _) {
                  return Transform.scale(
                    scale: _heartScaleAnim.value,
                    child: Icon(
                      Icons.favorite_rounded,
                      color: AppColors.primary.withValues(alpha: 0.9),
                      size: 100,
                    ),
                  );
                },
              ),
            ),

          // Right action rail
          Positioned(
            right: 12,
            bottom: 160,
            child: Column(
              children: [
                // Like button
                _ActionButton(
                  icon: isLiked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: _formatCount(widget.drama.likeCount),
                  iconColor: isLiked ? AppColors.primary : Colors.white,
                  onTap: () => content.toggleLike(widget.drama.id),
                ),
                const SizedBox(height: 20),
                // Save button
                _ActionButton(
                  icon: isSaved
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: 'Save',
                  iconColor: isSaved ? AppColors.accent : Colors.white,
                  onTap: () => content.toggleSave(widget.drama),
                ),
                const SizedBox(height: 20),
                // Share button
                _ActionButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () {
                    // share_plus integration
                  },
                ),
              ],
            ),
          ),

          // Bottom overlay: metadata & progress
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 80, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.drama.title,
                        style: AppTextStyles.headlineLarge.copyWith(
                          shadows: [
                            const Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Episode tag
                      Text(
                        'Ep. $currentEp / ${widget.drama.totalEpisodes}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Genre tags
                      Wrap(
                        spacing: 8,
                        children: widget.drama.genres.map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              genre,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      // Description / Subtitle area
                      Text(
                        widget.drama.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white70,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Progress bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: _videoProgress,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 3,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Episode drawer bar
                GestureDetector(
                  onTap: _openEpisodeSelector,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      border: Border(
                        top: BorderSide(
                          color: AppColors.divider.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Episode $currentEp',
                          style: AppTextStyles.labelLarge,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '• View All Episodes',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // Bottom safe area padding
                SizedBox(height: MediaQuery.of(context).padding.bottom + 60),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
