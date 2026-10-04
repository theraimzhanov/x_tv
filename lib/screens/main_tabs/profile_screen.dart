import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../config/constants.dart';
import '../../providers/providers.dart';
import '../../widgets/common_widgets.dart';
import '../overlays/vip_paywall_sheet.dart';

/// Tab 3: Profile & Settings screen.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, ContentProvider>(
      builder: (context, auth, content, _) {
        final user = auth.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('Profile', style: AppTextStyles.displayMedium),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.settings_outlined,
                              color: AppColors.textSecondary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // User Header Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: auth.isVip
                            ? AppColors.accent.withValues(alpha: 0.3)
                            : AppColors.divider,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              user?.displayName.isNotEmpty == true
                                  ? user!.displayName[0].toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? 'User',
                                style: AppTextStyles.headlineMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user?.email ?? '',
                                style: AppTextStyles.bodySmall,
                              ),
                              const SizedBox(height: 8),
                              VipBadge(isVip: auth.isVip),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // VIP Subscription Banner
                  if (!auth.isVip)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const VipPaywallSheet(),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.accent.withValues(alpha: 0.15),
                              AppColors.primary.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                gradient: AppColors.vipGradient,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.workspace_premium,
                                color: Colors.black87,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Upgrade to VIP',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColors.accent,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Unlock all episodes, zero ads, HD streaming',
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.accent,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (auth.isVip)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.accent.withValues(alpha: 0.15),
                            AppColors.accent.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_rounded,
                              color: AppColors.accent, size: 32),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'VIP Active',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.accent,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Renews on ${_formatDate(user?.vipExpiresAt)}',
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 28),

                  // Saved Dramas
                  _buildSection(
                    context,
                    title: 'Saved Dramas',
                    icon: Icons.bookmark_rounded,
                    child: content.savedDramas.isEmpty
                        ? _EmptyState(
                            icon: Icons.bookmark_border,
                            message: 'No saved dramas yet',
                          )
                        : SizedBox(
                            height: 150,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: content.savedDramas.length,
                              itemBuilder: (context, index) {
                                final drama = content.savedDramas[index];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: DramaPosterCard(
                                          title: drama.title,
                                          imageUrl: drama.posterUrl,
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () => content
                                              .removeSavedDrama(drama.id),
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close,
                                                size: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Watch History
                  _buildSection(
                    context,
                    title: 'Watch History',
                    icon: Icons.history_rounded,
                    child: content.watchHistory.isEmpty
                        ? _EmptyState(
                            icon: Icons.history,
                            message: 'No watch history yet',
                          )
                        : Column(
                            children: content.watchHistory.map((item) {
                              return _WatchHistoryTile(item: item);
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Settings section
                  _buildSection(
                    context,
                    title: 'Settings',
                    icon: Icons.tune_rounded,
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.language_rounded,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.subtitles_outlined,
                          title: 'Subtitle Language',
                          subtitle: 'English',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.cell_tower_rounded,
                          title: 'Cellular Data Warning',
                          trailing: Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: AppColors.primary,
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.play_circle_outline,
                          title: 'Auto-play Next Episode',
                          trailing: Switch(
                            value: true,
                            onChanged: (_) {},
                            activeColor: AppColors.primary,
                          ),
                        ),
                        _SettingsTile(
                          icon: Icons.cleaning_services_outlined,
                          title: 'Clear Cache',
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Cache cleared'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Support & Info
                  _buildSection(
                    context,
                    title: 'Support & Info',
                    icon: Icons.info_outline_rounded,
                    child: Column(
                      children: [
                        _SettingsTile(
                          icon: Icons.support_agent_rounded,
                          title: 'Contact Support',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.feedback_outlined,
                          title: 'Send Feedback',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of Service',
                          onTap: () {},
                        ),
                        _SettingsTile(
                          icon: Icons.info_outline,
                          title: 'App Version',
                          subtitle: AppConstants.appVersion,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account actions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              auth.signOut();
                              Navigator.of(context)
                                  .pushReplacementNamed('/login');
                            },
                            icon: const Icon(Icons.logout_rounded,
                                color: AppColors.error),
                            label: Text(
                              'Log Out',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: AppColors.error,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            _showDeleteAccountDialog(context, auth);
                          },
                          child: Text(
                            'Delete Account',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.error.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.headlineMedium),
            ],
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Account', style: AppTextStyles.headlineMedium),
        content: Text(
          'Are you sure? This action is permanent and cannot be undone. All your data, watch history, and saved dramas will be deleted.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await auth.deleteAccount();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: Text(
              'Delete',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _WatchHistoryTile extends StatelessWidget {
  final dynamic item;

  const _WatchHistoryTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          // Poster thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.posterUrl,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 60,
                height: 80,
                color: AppColors.card,
                child: const Icon(Icons.movie, color: AppColors.textMuted),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.dramaTitle,
                  style: AppTextStyles.titleMedium.copyWith(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Watched Ep. ${item.lastEpisodeWatched} of ${item.totalEpisodes}',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 8),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progressPercent,
                    backgroundColor: AppColors.divider,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.play_circle_filled_rounded,
            color: AppColors.primary,
            size: 36,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.textSecondary, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium.copyWith(fontSize: 14)),
                  if (subtitle != null)
                    Text(subtitle!, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            trailing ??
                (onTap != null
                    ? const Icon(Icons.arrow_forward_ios,
                        color: AppColors.textMuted, size: 16)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: AppColors.textMuted, size: 40),
            const SizedBox(height: 8),
            Text(message, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
