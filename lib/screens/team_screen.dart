import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class TeamScreen extends StatefulWidget {
  final AppState state;
  const TeamScreen({super.key, required this.state});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    final tasks = state.teamTasks.where((task) {
      final text = '${task.title} ${task.description}'.toLowerCase();
      return _search.text.isEmpty || text.contains(_search.text.toLowerCase());
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(state: state),
          const SizedBox(height: 16),

          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Поиск',
            ),
          ),

          const SizedBox(height: 16),

          /// 📊 СТАТИСТИКА
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth > 900;

            return GridView.count(
              crossAxisCount: wide ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StatCard(
                    title: 'Участники',
                    value: '${state.teamMembers.length}',
                    icon: Icons.groups),
                _StatCard(
                    title: 'Задачи',
                    value: '${state.teamTasks.length}',
                    icon: Icons.task),
                _StatCard(
                    title: 'Готово',
                    value: '${state.doneTeamTasksCount()}',
                    icon: Icons.check),
                _StatCard(
                    title: 'Прогресс',
                    value: '${(state.teamProgress() * 100).round()}%',
                    icon: Icons.pie_chart),
              ],
            );
          }),

          const SizedBox(height: 16),

          /// 🔥 ОСНОВНОЙ FIX
          LayoutBuilder(builder: (context, constraints) {
            final wide = constraints.maxWidth > 920;

            return wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _MembersBlock(state: state)),
                      const SizedBox(width: 16),
                      Expanded(child: _AnalyticsBlock(state: state)),
                    ],
                  )
                : Column(
                    children: [
                      _MembersBlock(state: state),
                      const SizedBox(height: 16),
                      _AnalyticsBlock(state: state),
                    ],
                  );
          }),

          const SizedBox(height: 16),

          Text(
            'Задачи',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (tasks.isEmpty)
            const SectionCard(child: Text('Нет задач')),

          ...tasks.map((task) => _TaskCard(task: task)),
        ],
      ),
    );
  }
}

/// 🔥 HEADER (FIX)
class _Header extends StatelessWidget {
  final AppState state;

  const _Header({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Life Team',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text('Пользователь: ${state.currentUserName}'),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard(
      {required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(title),
        ],
      ),
    );
  }
}

class _MembersBlock extends StatelessWidget {
  final AppState state;
  const _MembersBlock({required this.state});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Участники'),
          const SizedBox(height: 10),
          ...state.teamMembers.map(
            (m) => ListTile(
              leading: CircleAvatar(child: Text(m.avatar)),
              title: Text(m.name),
              subtitle: Text(m.email),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsBlock extends StatelessWidget {
  final AppState state;
  const _AnalyticsBlock({required this.state});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          const Text('Аналитика'),
          const SizedBox(height: 10),
          Text('${(state.teamProgress() * 100).round()}%'),
        ],
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TeamTask task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text(task.description),
      ),
    );
  }
}