import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../widgets/section_card.dart';

class NotesScreen extends StatefulWidget {
  final AppState state;
  const NotesScreen({super.key, required this.state});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool saveRecord = true;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Заметки и мысли', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('Можно писать мысли, выбирать сохранить запись или не сохранять. Сохранённые записи остаются в приложении.'),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              children: [
                TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Заголовок заметки')),
                const SizedBox(height: 12),
                TextField(
                  controller: _contentController,
                  maxLines: 5,
                  decoration: const InputDecoration(labelText: 'Текст заметки'),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Сохранить запись'),
                  value: saveRecord,
                  onChanged: (value) => setState(() => saveRecord = value),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _titleController.clear();
                          _contentController.clear();
                          setState(() => saveRecord = false);
                        },
                        child: Text(widget.state.t('cancel')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (_titleController.text.trim().isEmpty || _contentController.text.trim().isEmpty) return;
                          await widget.state.addNote(_titleController.text.trim(), _contentController.text.trim(), saveRecord);
                          if (saveRecord) {
                            _titleController.clear();
                            _contentController.clear();
                          }
                        },
                        child: Text(widget.state.t('save')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ...widget.state.notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(note.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                        ),
                        IconButton(
                          onPressed: () => widget.state.removeNote(note.id),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(note.content),
                    const SizedBox(height: 8),
                    Text('Сохранено: ${note.createdAt.day}.${note.createdAt.month}.${note.createdAt.year}'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
