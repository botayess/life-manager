import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../screens/dashboard_screen.dart';
import '../screens/finance_screen.dart';
import '../screens/habits_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/plans_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/team_screen.dart';

class AppShell extends StatelessWidget {
  final AppState state;
  const AppShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(state: state),
      HabitsScreen(state: state),
      FinanceScreen(state: state),
      TeamScreen(state: state),
      NotesScreen(state: state),
      PlansScreen(state: state),
      SettingsScreen(state: state),
    ];

    final destinations = [
      NavigationDestination(
        icon: const Icon(Icons.dashboard_customize_outlined),
        label: state.t('home'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.check_circle_outline),
        label: state.t('habits'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.account_balance_wallet_outlined),
        label: state.t('finance'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.groups_2_outlined),
        label: state.t('team'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.sticky_note_2_outlined),
        label: state.t('notes'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.event_note_outlined),
        label: state.t('plans'),
      ),
      NavigationDestination(
        icon: const Icon(Icons.settings_outlined),
        label: state.t('settings'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;

        return Scaffold(
          appBar: isWide
              ? null
              : AppBar(
                  title: const Text('Life Tracker'),
                  centerTitle: false,
                ),
          body: SafeArea(
            child: Row(
              children: [
                if (isWide)
                  Container(
                    width: 255,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Life Tracker',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Creative student dashboard',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),

                        Expanded(
                          child: ListView.builder(
                            itemCount: destinations.length,
                            itemBuilder: (context, index) {
                              final selected = index == state.selectedIndex;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  selected: selected,
                                  selectedTileColor: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.12),
                                  leading: IconTheme(
                                    data: IconThemeData(
                                      color: selected
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : null,
                                    ),
                                    child: destinations[index].icon,
                                  ),
                                  title: Text(destinations[index].label),
                                  onTap: () => state.changeTab(index),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: state.logout,
                            icon: const Icon(Icons.logout),
                            label: Text(state.t('logout')),
                          ),
                        ),
                      ],
                    ),
                  ),

                Expanded(
                  child: pages[state.selectedIndex],
                ),
              ],
            ),
          ),

          bottomNavigationBar: isWide
              ? null
              : NavigationBar(
                  selectedIndex: state.selectedIndex,
                  onDestinationSelected: state.changeTab,
                  destinations: destinations,
                ),
        );
      },
    );
  }
}