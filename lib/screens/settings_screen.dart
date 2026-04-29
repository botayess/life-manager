import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/app_strings.dart';
import '../widgets/section_card.dart';

class SettingsScreen extends StatelessWidget {
  final AppState state;
  const SettingsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Настройки и поддержка',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w900)),
          Text('App settings and preferences'),
          const SizedBox(height: 10),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Язык интерфейса'),
                  subtitle: Text(
                      state.language == AppLanguage.ru ? 'Русский' : 'English'),
                  trailing: FilledButton(
                    onPressed: state.toggleLanguage,
                    child: const Text('RU / EN'),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Тёмная тема'),
                  value: state.themeMode == ThemeMode.dark,
                  onChanged: state.toggleTheme,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Уведомления'),
                  subtitle:
                      const Text('Базовая настройка уведомлений работает'),
                  value: state.notificationsEnabled,
                  onChanged: state.toggleNotifications,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Компактный режим'),
                  value: state.compactMode,
                  onChanged: state.toggleCompactMode,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Поддержка в приложении'),
                  subtitle:
                      const Text('Показывает, что служба поддержки активна'),
                  value: state.supportChatEnabled,
                  onChanged: state.toggleSupportChat,
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 920;
              return GridView.count(
                crossAxisCount: wide ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: wide ? 1.5 : 1.0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Профиль',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(
                              child: Icon(Icons.person_outline)),
                          title: Text(state.currentUserName),
                          subtitle: const Text(
                              'Студент / пользователь Life Tracker Pro'),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: state.logout,
                          icon: const Icon(Icons.logout),
                          label: Text(state.t('logout')),
                        ),
                      ],
                    ),
                  ),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.t('support'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        const Text('Email: support@lifetracker.local'),
                        const SizedBox(height: 8),
                        const Text('Telegram: @life_tracker_support'),
                        const SizedBox(height: 8),
                        Text(state.supportChatEnabled
                            ? 'Статус: поддержка активна'
                            : 'Статус: поддержка выключена'),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Запрос в поддержку успешно отправлен.')),
                            );
                          },
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Связаться с поддержкой'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
