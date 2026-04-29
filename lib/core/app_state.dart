import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';
import 'app_strings.dart';

enum FinanceRange { day, week, month, threeMonths, sixMonths, year }

class AppState extends ChangeNotifier {
  AppLanguage language = AppLanguage.ru;
  ThemeMode themeMode = ThemeMode.light;
  bool notificationsEnabled = true;
  bool compactMode = false;
  bool supportChatEnabled = true;
  bool isLoggedIn = false;
  String currentUserName = 'Admin';
  String currentUserEmail = 'admin@life.kz';
  TeamRole currentRole = TeamRole.admin;
  int selectedIndex = 0;

  final List<AppAccount> demoAccounts = const [
    AppAccount(id: 'a1', name: 'Admin', email: 'admin@life.kz', password: 'admin123', role: TeamRole.admin, avatar: '👩🏻‍💻'),
    AppAccount(id: 'u1', name: 'User', email: 'user@life.kz', password: 'user123', role: TeamRole.member, avatar: '🧑🏻‍🎓'),
    AppAccount(id: 't1', name: 'test123', email: 'test123@gmail.com', password: 'test123', role: TeamRole.admin, avatar: '⭐'),
  ];

  bool get isAdmin => currentRole == TeamRole.admin;

  List<FinanceEntry> finances = [
    FinanceEntry(id: 'f1', title: 'Стипендия', amount: 50000, isIncome: true, date: DateTime.now().subtract(const Duration(days: 2)), category: 'Учёба'),
    FinanceEntry(id: 'f2', title: 'Кофе и перекус', amount: 3200, isIncome: false, date: DateTime.now().subtract(const Duration(days: 1)), category: 'Еда'),
    FinanceEntry(id: 'f3', title: 'Подработка', amount: 18000, isIncome: true, date: DateTime.now().subtract(const Duration(days: 9)), category: 'Работа'),
  ];

  List<HabitItem> habits = [
    HabitItem(id: 'h1', title: 'Пить воду', plan: '8 стаканов за день'),
    HabitItem(id: 'h2', title: 'Учёба', plan: '2 часа на проект', isDone: true),
  ];

  List<NoteItem> notes = [
    NoteItem(id: 'n1', title: 'Идея для проекта', content: 'Добавить backend, группу и роли admin/user.', saved: true, createdAt: DateTime.now()),
  ];

  List<PlanItem> plans = [
    PlanItem(id: 'p1', title: 'Сделать 3 коммита', forTomorrow: false),
    PlanItem(id: 'p2', title: 'Запустить на Android emulator', forTomorrow: true),
  ];

  List<TeamGroup> groups = [
    TeamGroup(id: 'g1', name: 'Life Team', description: 'Групповой трекер: админ добавляет людей, назначает задачи, участники видят и обновляют статус.'),
  ];

  List<TeamMember> teamMembers = [
    TeamMember(id: 'a1', name: 'Admin', email: 'admin@life.kz', role: TeamRole.admin, avatar: '👩🏻‍💻'),
    TeamMember(id: 'u1', name: 'User', email: 'user@life.kz', role: TeamRole.member, avatar: '🧑🏻‍🎓'),
    TeamMember(id: 'm2', name: 'Ерке', email: 'erke@team.dev', role: TeamRole.member, avatar: '🧑🏻‍🎨'),
    TeamMember(id: 'm3', name: 'Ерасыл', email: 'erasyl@team.dev', role: TeamRole.member, avatar: '🧑🏻‍🔧'),
    TeamMember(id: 'm4', name: 'Асхат', email: 'askhat@team.dev', role: TeamRole.member, avatar: '🧑🏻‍💼'),
  ];

  List<TeamTask> teamTasks = [
    TeamTask(id: 't1', title: 'Сделать UI главной', description: 'Креативный интерфейс и адаптивная верстка.', assignedToId: 'm2', deadline: DateTime.now().add(const Duration(days: 1)), priority: 'High', status: TeamTaskStatus.inProgress),
    TeamTask(id: 't2', title: 'Проверить финансы', description: 'Фильтры за день/неделю/месяц/год и круговая диаграмма.', assignedToId: 'm3', deadline: DateTime.now().add(const Duration(days: 2)), priority: 'Medium', status: TeamTaskStatus.todo),
    TeamTask(id: 't3', title: 'GitHub и коммиты', description: 'Настроить репозиторий и ветки команды.', assignedToId: 'm4', deadline: DateTime.now().subtract(const Duration(days: 1)), priority: 'Low', status: TeamTaskStatus.overdue),
    TeamTask(id: 't4', title: 'Проверка мобильной версии', description: 'Запуск на Android emulator / real phone.', assignedToId: 'u1', deadline: DateTime.now().add(const Duration(days: 3)), priority: 'High', status: TeamTaskStatus.done),
  ];

  AppState() { load(); }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    language = (prefs.getString('language') ?? 'ru') == 'en' ? AppLanguage.en : AppLanguage.ru;
    themeMode = (prefs.getString('themeMode') ?? 'light') == 'dark' ? ThemeMode.dark : ThemeMode.light;
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    compactMode = prefs.getBool('compactMode') ?? false;
    supportChatEnabled = prefs.getBool('supportChatEnabled') ?? true;
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    currentUserName = prefs.getString('currentUserName') ?? currentUserName;
    currentUserEmail = prefs.getString('currentUserEmail') ?? currentUserEmail;
    currentRole = (prefs.getString('currentRole') ?? 'admin') == 'admin' ? TeamRole.admin : TeamRole.member;
    final financesRaw = prefs.getString('finances'); if (financesRaw != null) finances = decodeList(financesRaw).map((e) => FinanceEntry.fromMap(Map<String, dynamic>.from(e))).toList();
    final habitsRaw = prefs.getString('habits'); if (habitsRaw != null) habits = decodeList(habitsRaw).map((e) => HabitItem.fromMap(Map<String, dynamic>.from(e))).toList();
    final notesRaw = prefs.getString('notes'); if (notesRaw != null) notes = decodeList(notesRaw).map((e) => NoteItem.fromMap(Map<String, dynamic>.from(e))).toList();
    final plansRaw = prefs.getString('plans'); if (plansRaw != null) plans = decodeList(plansRaw).map((e) => PlanItem.fromMap(Map<String, dynamic>.from(e))).toList();
    final groupsRaw = prefs.getString('groups'); if (groupsRaw != null) groups = decodeList(groupsRaw).map((e) => TeamGroup.fromMap(Map<String, dynamic>.from(e))).toList();
    final membersRaw = prefs.getString('teamMembers'); if (membersRaw != null) teamMembers = decodeList(membersRaw).map((e) => TeamMember.fromMap(Map<String, dynamic>.from(e))).toList();
    final tasksRaw = prefs.getString('teamTasks'); if (tasksRaw != null) teamTasks = decodeList(tasksRaw).map((e) => TeamTask.fromMap(Map<String, dynamic>.from(e))).toList();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language == AppLanguage.ru ? 'ru' : 'en');
    await prefs.setString('themeMode', themeMode == ThemeMode.dark ? 'dark' : 'light');
    await prefs.setBool('notificationsEnabled', notificationsEnabled);
    await prefs.setBool('compactMode', compactMode);
    await prefs.setBool('supportChatEnabled', supportChatEnabled);
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('currentUserName', currentUserName);
    await prefs.setString('currentUserEmail', currentUserEmail);
    await prefs.setString('currentRole', currentRole.name);
    await prefs.setString('finances', encodeList(finances.map((e) => e.toMap()).toList()));
    await prefs.setString('habits', encodeList(habits.map((e) => e.toMap()).toList()));
    await prefs.setString('notes', encodeList(notes.map((e) => e.toMap()).toList()));
    await prefs.setString('plans', encodeList(plans.map((e) => e.toMap()).toList()));
    await prefs.setString('groups', encodeList(groups.map((e) => e.toMap()).toList()));
    await prefs.setString('teamMembers', encodeList(teamMembers.map((e) => e.toMap()).toList()));
    await prefs.setString('teamTasks', encodeList(teamTasks.map((e) => e.toMap()).toList()));
  }

  String t(String key) => AppText.of(language, key);

  Future<bool> login(String identifier, String password) async {
    final id = identifier.trim().toLowerCase();
    AppAccount? account;
    for (final a in demoAccounts) {
      if ((a.email.toLowerCase() == id || a.name.toLowerCase() == id) && a.password == password.trim()) account = a;
    }
    if (account == null && (id == 'test123@mail.ru') && password.trim() == 'test123') account = demoAccounts[2];
    if (account == null) return false;
    isLoggedIn = true;
    currentUserName = account.name;
    currentUserEmail = account.email;
    currentRole = account.role;
    await _save();
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    isLoggedIn = true;
    currentUserName = name.trim().isEmpty ? 'New user' : name.trim();
    currentUserEmail = email.trim().isEmpty ? 'new@life.kz' : email.trim();
    currentRole = TeamRole.member;
    if (!teamMembers.any((e) => e.email == currentUserEmail)) {
      teamMembers.add(TeamMember(id: DateTime.now().microsecondsSinceEpoch.toString(), name: currentUserName, email: currentUserEmail, role: TeamRole.member, avatar: '🙂'));
    }
    await _save();
    notifyListeners();
    return true;
  }

  Future<void> logout() async { isLoggedIn = false; selectedIndex = 0; await _save(); notifyListeners(); }
  void changeTab(int index) { selectedIndex = index; notifyListeners(); }
  Future<void> toggleLanguage() async { language = language == AppLanguage.ru ? AppLanguage.en : AppLanguage.ru; await _save(); notifyListeners(); }
  Future<void> toggleTheme(bool dark) async { themeMode = dark ? ThemeMode.dark : ThemeMode.light; await _save(); notifyListeners(); }
  Future<void> toggleNotifications(bool value) async { notificationsEnabled = value; await _save(); notifyListeners(); }
  Future<void> toggleCompactMode(bool value) async { compactMode = value; await _save(); notifyListeners(); }
  Future<void> toggleSupportChat(bool value) async { supportChatEnabled = value; await _save(); notifyListeners(); }

  Future<void> addFinance({required String title, required double amount, required bool isIncome, required String category, DateTime? date}) async {
    finances.insert(0, FinanceEntry(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, amount: amount, isIncome: isIncome, date: date ?? DateTime.now(), category: category));
    await _save(); notifyListeners();
  }
  Future<void> addHabit(String title, String plan) async { habits.insert(0, HabitItem(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, plan: plan)); await _save(); notifyListeners(); }
  Future<void> toggleHabit(String id, bool value) async { habits.firstWhere((e) => e.id == id).isDone = value; await _save(); notifyListeners(); }
  Future<void> addNote(String title, String content, bool saved) async { if (!saved) return; notes.insert(0, NoteItem(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, content: content, saved: true, createdAt: DateTime.now())); await _save(); notifyListeners(); }
  Future<void> removeNote(String id) async { notes.removeWhere((e) => e.id == id); await _save(); notifyListeners(); }
  Future<void> addPlan(String title, bool forTomorrow) async { plans.insert(0, PlanItem(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, forTomorrow: forTomorrow)); await _save(); notifyListeners(); }
  Future<void> togglePlan(String id, bool value) async { plans.firstWhere((e) => e.id == id).done = value; await _save(); notifyListeners(); }

  Future<void> addTeamMember({required String name, required String email, required TeamRole role, required String avatar}) async {
    teamMembers.insert(0, TeamMember(id: DateTime.now().microsecondsSinceEpoch.toString(), name: name, email: email, role: role, avatar: avatar));
    await _save(); notifyListeners();
  }
  Future<void> addTeamTask({required String title, required String description, required String assignedToId, required DateTime deadline, required String priority}) async {
    teamTasks.insert(0, TeamTask(id: DateTime.now().microsecondsSinceEpoch.toString(), title: title, description: description, assignedToId: assignedToId, deadline: deadline, priority: priority));
    await _save(); notifyListeners();
  }
  Future<void> updateTeamTaskStatus(String id, TeamTaskStatus status) async { teamTasks.firstWhere((e) => e.id == id).status = status; await _save(); notifyListeners(); }

  TeamMember? memberById(String id) { for (final member in teamMembers) { if (member.id == id) return member; } return null; }
  int taskCountForMember(String memberId) => teamTasks.where((e) => e.assignedToId == memberId).length;
  int completedTaskCountForMember(String memberId) => teamTasks.where((e) => e.assignedToId == memberId && e.status == TeamTaskStatus.done).length;
  int doneTeamTasksCount() => teamTasks.where((e) => e.status == TeamTaskStatus.done).length;
  int inProgressTeamTasksCount() => teamTasks.where((e) => e.status == TeamTaskStatus.inProgress).length;
  int overdueTeamTasksCount() => teamTasks.where((e) => e.status == TeamTaskStatus.overdue).length;
  double teamProgress() => teamTasks.isEmpty ? 0 : doneTeamTasksCount() / teamTasks.length;

  List<FinanceEntry> financesForRange(FinanceRange range) {
    final now = DateTime.now();
    final duration = switch (range) { FinanceRange.day => const Duration(days: 1), FinanceRange.week => const Duration(days: 7), FinanceRange.month => const Duration(days: 30), FinanceRange.threeMonths => const Duration(days: 90), FinanceRange.sixMonths => const Duration(days: 180), FinanceRange.year => const Duration(days: 365) };
    final start = now.subtract(duration);
    return finances.where((e) => e.date.isAfter(start)).toList();
  }
  double totalIncome(FinanceRange range) => financesForRange(range).where((e) => e.isIncome).fold(0, (sum, e) => sum + e.amount);
  double totalExpense(FinanceRange range) => financesForRange(range).where((e) => !e.isIncome).fold(0, (sum, e) => sum + e.amount);
  int completedHabitsCount() => habits.where((e) => e.isDone).length;
  int completedPlansCount() => plans.where((e) => e.done).length;
  int activeNotesCount() => notes.length;
}
