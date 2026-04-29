import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../widgets/section_card.dart';

class HabitsScreen extends StatefulWidget {
  final AppState state;
  const HabitsScreen({super.key, required this.state});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  final _titleController = TextEditingController();
  final _planController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _planController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Мои привычки и ежедневный план', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('Добавляй привычки, записывай маленький план на день и отмечай галочкой выполнение.'),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Новая привычка')),
                const SizedBox(height: 12),
                TextField(controller: _planController, decoration: const InputDecoration(labelText: 'План / описание на каждый день')),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () async {
                      if (_titleController.text.trim().isEmpty) return;
                      await widget.state.addHabit(_titleController.text.trim(), _planController.text.trim());
                      _titleController.clear();
                      _planController.clear();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить привычку'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...widget.state.habits.map(
            (habit) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: SectionCard(
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: habit.isDone,
                  onChanged: (value) => widget.state.toggleHabit(habit.id, value ?? false),
                  title: Text(habit.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(habit.plan.isEmpty ? 'Без описания' : habit.plan),
                  secondary: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                    ),
                    child: Icon(habit.isDone ? Icons.verified : Icons.radio_button_unchecked),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
