import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../widgets/section_card.dart';

class PlansScreen extends StatefulWidget {
  final AppState state;
  const PlansScreen({super.key, required this.state});

  @override
  State<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  final _planController = TextEditingController();
  bool forTomorrow = false;

  @override
  void dispose() {
    _planController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = widget.state.plans.where((e) => !e.forTomorrow).toList();
    final tomorrow = widget.state.plans.where((e) => e.forTomorrow).toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Планы на сегодня и завтра', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              children: [
                TextField(controller: _planController, decoration: const InputDecoration(labelText: 'Добавить новый план')),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('План на следующий день'),
                  value: forTomorrow,
                  onChanged: (v) => setState(() => forTomorrow = v),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: () async {
                      if (_planController.text.trim().isEmpty) return;
                      await widget.state.addPlan(_planController.text.trim(), forTomorrow);
                      _planController.clear();
                    },
                    icon: const Icon(Icons.playlist_add_check_circle_outlined),
                    label: const Text('Сохранить план'),
                  ),
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
                childAspectRatio: wide ? 1.1 : 0.95,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _PlanColumn(title: 'Сегодня', items: today, state: widget.state),
                  _PlanColumn(title: 'Завтра', items: tomorrow, state: widget.state),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlanColumn extends StatelessWidget {
  final String title;
  final List items;
  final AppState state;
  const _PlanColumn({required this.title, required this.items, required this.state});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          if (items.isEmpty) const Text('Пока ничего не добавлено.'),
          ...items.map<Widget>((plan) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: plan.done,
                onChanged: (v) => state.togglePlan(plan.id, v ?? false),
                title: Text(plan.title),
              )),
        ],
      ),
    );
  }
}
