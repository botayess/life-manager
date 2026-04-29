import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  final AppState state;
  const DashboardScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final income = state.totalIncome(FinanceRange.month);
    final expense = state.totalExpense(FinanceRange.month);
    final balance = income - expense;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(34),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 780;

                if (wide) {
                  // 🔥 ШИРОКИЙ ЭКРАН (ПК)
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _leftContent(context)),
                      const SizedBox(width: 18),
                      Expanded(flex: 2, child: _rightCard(context)),
                    ],
                  );
                } else {
                  // 🔥 МОБИЛЬНЫЙ (FIX)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _leftContent(context),
                      const SizedBox(height: 18),
                      _rightCard(context),
                    ],
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 900;
              return GridView.count(
                crossAxisCount: wide ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: wide ? 1.25 : 1.05,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StatCard(
                      title: 'Баланс за месяц',
                      value: '${balance.toStringAsFixed(0)} ₸',
                      icon: Icons.savings_outlined),
                  _StatCard(
                      title: 'Доход за месяц',
                      value: '${income.toStringAsFixed(0)} ₸',
                      icon: Icons.trending_up),
                  _StatCard(
                      title: 'Расход за месяц',
                      value: '${expense.toStringAsFixed(0)} ₸',
                      icon: Icons.trending_down),
                  _StatCard(
                      title: 'Заметки',
                      value: '${state.notes.length}',
                      icon: Icons.notes),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 900;
              return GridView.count(
                crossAxisCount: wide ? 3 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: wide ? 1.25 : 1.1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Фокус на сегодня 🎯',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 16),
                        ...state.plans.take(4).map(
                              (plan) => CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                value: plan.done,
                                onChanged: (v) =>
                                    state.togglePlan(plan.id, v ?? false),
                                title: Text(plan.title ?? "Без названия"),
                              ),
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

  // 🔥 ЛЕВАЯ ЧАСТЬ (без Expanded — FIX)
  Widget _leftContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.white.withOpacity(0.75),
          ),
          child: Text('Привет, ${state.currentUserName}'),
        ),
        const SizedBox(height: 18),
        Text(
          'Life Tracker — всё в одном месте',
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        const Text('Привычки, финансы, планы и команда — теперь вместе.'),
      ],
    );
  }

  // 🔥 ПРАВАЯ КАРТОЧКА
  Widget _rightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Прогресс',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          _ProgressTile(
              title: 'Привычки',
              value: state.completedHabitsCount(),
              total: state.habits.length),
        ],
      ),
    );
  }
}

// --- ОСТАЛЬНЫЕ ВИДЖЕТЫ ---

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 12),
          Text(title),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  final String title;
  final int value;
  final int total;

  const _ProgressTile(
      {required this.title, required this.value, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : value / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: $value / $total'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
