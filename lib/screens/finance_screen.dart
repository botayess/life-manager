import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../models/app_models.dart';
import '../widgets/section_card.dart';

class FinanceScreen extends StatefulWidget {
  final AppState state;
  const FinanceScreen({super.key, required this.state});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController(text: 'Общее');

  FinanceRange selectedRange = FinanceRange.month;
  bool isIncome = false;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.state.financesForRange(selectedRange);
    final income = widget.state.totalIncome(selectedRange);
    final expense = widget.state.totalExpense(selectedRange);
    final balance = income - expense;

    final pieSections = [
      PieChartSectionData(value: income == 0 ? 0.1 : income, title: 'Доход'),
      PieChartSectionData(value: expense == 0 ? 0.1 : expense, title: 'Расход'),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Финансы и бюджет',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _RangeChip(label: widget.state.t('day'), selected: selectedRange == FinanceRange.day, onTap: () => setState(() => selectedRange = FinanceRange.day)),
              _RangeChip(label: widget.state.t('week'), selected: selectedRange == FinanceRange.week, onTap: () => setState(() => selectedRange = FinanceRange.week)),
              _RangeChip(label: widget.state.t('month'), selected: selectedRange == FinanceRange.month, onTap: () => setState(() => selectedRange = FinanceRange.month)),
              _RangeChip(label: widget.state.t('3months'), selected: selectedRange == FinanceRange.threeMonths, onTap: () => setState(() => selectedRange = FinanceRange.threeMonths)),
              _RangeChip(label: widget.state.t('6months'), selected: selectedRange == FinanceRange.sixMonths, onTap: () => setState(() => selectedRange = FinanceRange.sixMonths)),
              _RangeChip(label: widget.state.t('year'), selected: selectedRange == FinanceRange.year, onTap: () => setState(() => selectedRange = FinanceRange.year)),
            ],
          ),

          const SizedBox(height: 18),

          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 980;

              return GridView.count(
                crossAxisCount: wide ? 2 : 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: wide ? 1.45 : 0.82,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  SectionCard(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Добавить доход или расход',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 10,
                            children: [
                              ChoiceChip(
                                label: const Text('Расход'),
                                selected: !isIncome,
                                onSelected: (_) => setState(() => isIncome = false),
                              ),
                              ChoiceChip(
                                label: const Text('Доход'),
                                selected: isIncome,
                                onSelected: (_) => setState(() => isIncome = true),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Название операции',
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Сумма',
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextField(
                            controller: _categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Категория',
                            ),
                          ),

                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () async {
                                final amount = double.tryParse(
                                  _amountController.text.replaceAll(',', '.'),
                                );

                                if (_titleController.text.trim().isEmpty || amount == null) {
                                  return;
                                }

                                await widget.state.addFinance(
                                  title: _titleController.text.trim(),
                                  amount: amount,
                                  isIncome: isIncome,
                                  category: _categoryController.text.trim().isEmpty
                                      ? 'Общее'
                                      : _categoryController.text.trim(),
                                );

                                _titleController.clear();
                                _amountController.clear();
                                _categoryController.text = 'Общее';
                              },
                              icon: const Icon(Icons.add_card),
                              label: const Text('Добавить в бюджет'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Итоги за выбранный период',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          height: 170,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 42,
                              sections: pieSections,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SummaryText(label: 'Доход', value: '${income.toStringAsFixed(0)} ₸'),
                            _SummaryText(label: 'Расход', value: '${expense.toStringAsFixed(0)} ₸'),
                            _SummaryText(label: 'Баланс', value: '${balance.toStringAsFixed(0)} ₸'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 18),

          Text(
            'История операций',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),

          const SizedBox(height: 12),

          ...filtered.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FinanceTile(entry: entry),
            ),
          ),

          if (filtered.isEmpty)
            SectionCard(
              child: const Text('За выбранный период пока нет операций.'),
            ),
        ],
      ),
    );
  }
}

class _FinanceTile extends StatelessWidget {
  final FinanceEntry entry;
  const _FinanceTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          CircleAvatar(
            child: Icon(entry.isIncome ? Icons.arrow_downward : Icons.arrow_upward),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text('${entry.category} • ${entry.date.day}.${entry.date.month}.${entry.date.year}'),
              ],
            ),
          ),
          Text(
            '${entry.isIncome ? '+' : '-'}${entry.amount.toStringAsFixed(0)} ₸',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _SummaryText extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryText({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}