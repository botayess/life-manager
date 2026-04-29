import 'dart:convert';

class FinanceEntry {
  final String id;
  final String title;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String category;

  FinanceEntry({required this.id, required this.title, required this.amount, required this.isIncome, required this.date, required this.category});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'amount': amount, 'isIncome': isIncome, 'date': date.toIso8601String(), 'category': category};
  factory FinanceEntry.fromMap(Map<String, dynamic> map) => FinanceEntry(id: map['id'], title: map['title'], amount: (map['amount'] as num).toDouble(), isIncome: map['isIncome'], date: DateTime.parse(map['date']), category: map['category'] ?? 'Other');
}

class HabitItem {
  final String id;
  final String title;
  final String plan;
  bool isDone;
  HabitItem({required this.id, required this.title, required this.plan, this.isDone = false});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'plan': plan, 'isDone': isDone};
  factory HabitItem.fromMap(Map<String, dynamic> map) => HabitItem(id: map['id'], title: map['title'], plan: map['plan'], isDone: map['isDone'] ?? false);
}

class NoteItem {
  final String id;
  final String title;
  final String content;
  final bool saved;
  final DateTime createdAt;
  NoteItem({required this.id, required this.title, required this.content, required this.saved, required this.createdAt});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'content': content, 'saved': saved, 'createdAt': createdAt.toIso8601String()};
  factory NoteItem.fromMap(Map<String, dynamic> map) => NoteItem(id: map['id'], title: map['title'], content: map['content'], saved: map['saved'] ?? true, createdAt: DateTime.parse(map['createdAt']));
}

class PlanItem {
  final String id;
  final String title;
  final bool forTomorrow;
  bool done;
  PlanItem({required this.id, required this.title, required this.forTomorrow, this.done = false});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'forTomorrow': forTomorrow, 'done': done};
  factory PlanItem.fromMap(Map<String, dynamic> map) => PlanItem(id: map['id'], title: map['title'], forTomorrow: map['forTomorrow'] ?? false, done: map['done'] ?? false);
}

enum TeamRole { admin, member }
enum TeamTaskStatus { todo, inProgress, done, overdue }

class AppAccount {
  final String id;
  final String name;
  final String email;
  final String password;
  final TeamRole role;
  final String avatar;
  const AppAccount({required this.id, required this.name, required this.email, required this.password, required this.role, required this.avatar});
}

class TeamGroup {
  final String id;
  String name;
  String description;
  TeamGroup({required this.id, required this.name, required this.description});
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'description': description};
  factory TeamGroup.fromMap(Map<String, dynamic> map) => TeamGroup(id: map['id'], name: map['name'], description: map['description'] ?? '');
}

class TeamMember {
  final String id;
  String name;
  String email;
  TeamRole role;
  String avatar;
  TeamMember({required this.id, required this.name, required this.email, required this.role, required this.avatar});
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'email': email, 'role': role.name, 'avatar': avatar};
  factory TeamMember.fromMap(Map<String, dynamic> map) => TeamMember(id: map['id'], name: map['name'], email: map['email'], role: TeamRole.values.firstWhere((e) => e.name == (map['role'] ?? 'member'), orElse: () => TeamRole.member), avatar: map['avatar'] ?? '🙂');
}

class TeamTask {
  final String id;
  String title;
  String description;
  String assignedToId;
  DateTime deadline;
  String priority;
  TeamTaskStatus status;
  TeamTask({required this.id, required this.title, required this.description, required this.assignedToId, required this.deadline, required this.priority, this.status = TeamTaskStatus.todo});
  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'description': description, 'assignedToId': assignedToId, 'deadline': deadline.toIso8601String(), 'priority': priority, 'status': status.name};
  factory TeamTask.fromMap(Map<String, dynamic> map) => TeamTask(id: map['id'], title: map['title'], description: map['description'] ?? '', assignedToId: map['assignedToId'], deadline: DateTime.parse(map['deadline']), priority: map['priority'] ?? 'Medium', status: TeamTaskStatus.values.firstWhere((e) => e.name == (map['status'] ?? 'todo'), orElse: () => TeamTaskStatus.todo));
}

String encodeList(List<Map<String, dynamic>> items) => jsonEncode(items);
List<dynamic> decodeList(String raw) => jsonDecode(raw) as List<dynamic>;
