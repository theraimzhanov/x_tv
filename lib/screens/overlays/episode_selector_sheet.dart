import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../models/models.dart';
import '../../providers/providers.dart';
import 'vip_paywall_sheet.dart';

/// Draggable modal bottom sheet for episode selection.
class EpisodeSelectorSheet extends StatelessWidget {
  final Drama drama;

  const EpisodeSelectorSheet({super.key, required this.drama});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final content = context.watch<ContentProvider>();
    final episodes = content.getEpisodes(drama.id);
    final isVip = auth.isVip;
    final currentEp = content.currentEpisodeNumber;

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drama.title,
                            style: AppTextStyles.headlineMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: drama.isCompleted
                                      ? AppColors.success.withValues(
                                          alpha: 0.15)
                                      : AppColors.warning.withValues(
                                          alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  drama.isCompleted
                                      ? 'Completed'
                                      : 'Ongoing',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: drama.isCompleted
                                        ? AppColors.success
                                        : AppColors.warning,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${drama.totalEpisodes} Episodes',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppColors.textMuted),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(color: AppColors.divider, height: 1),

              // Episode grid
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: drama.totalEpisodes,
                  itemBuilder: (context, index) {
                    final epNumber = index + 1;
                    final isFree =
                        epNumber <= AppConstants.freeEpisodeLimit;
                    final isLocked = !isFree && !isVip;
                    final isCurrent = epNumber == currentEp;

                    return GestureDetector(
                      onTap: () {
                        if (isLocked) {
                          // Show VIP paywall
                          Navigator.of(context).pop();
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const VipPaywallSheet(),
                          );
                        } else {
                          content.setCurrentEpisode(epNumber);
                          Navigator.of(context).pop();
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          gradient:
                              isCurrent ? AppColors.primaryGradient : null,
                          color: isCurrent
                              ? null
                              : isLocked
                                  ? AppColors.surfaceLight.withValues(
                                      alpha: 0.5)
                                  : AppColors.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isCurrent
                                ? AppColors.primary
                                : AppColors.divider,
                            width: isCurrent ? 2 : 1,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '$epNumber',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: isCurrent
                                    ? Colors.white
                                    : isLocked
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary,
                                fontSize: 15,
                              ),
                            ),
                            // Lock / Free indicator
                            if (isLocked)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Icon(
                                  Icons.lock_rounded,
                                  size: 12,
                                  color:
                                      AppColors.accent.withValues(alpha: 0.7),
                                ),
                              ),
                            if (isFree && !isCurrent)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppColors.success,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
