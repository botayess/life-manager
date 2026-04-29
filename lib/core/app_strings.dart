enum AppLanguage { ru, en }

class AppText {
  static const Map<String, Map<AppLanguage, String>> _data = {
    'appTitle': {AppLanguage.ru: 'Life Tracker Pro', AppLanguage.en: 'Life Tracker Pro'},
    'home': {AppLanguage.ru: 'Главная', AppLanguage.en: 'Home'},
    'habits': {AppLanguage.ru: 'Привычки', AppLanguage.en: 'Habits'},
    'finance': {AppLanguage.ru: 'Финансы', AppLanguage.en: 'Finance'},
    'team': {AppLanguage.ru: 'Команда', AppLanguage.en: 'Team'},
    'notes': {AppLanguage.ru: 'Заметки', AppLanguage.en: 'Notes'},
    'plans': {AppLanguage.ru: 'Планы', AppLanguage.en: 'Plans'},
    'settings': {AppLanguage.ru: 'Настройки', AppLanguage.en: 'Settings'},
    'login': {AppLanguage.ru: 'Войти', AppLanguage.en: 'Login'},
    'register': {AppLanguage.ru: 'Регистрация', AppLanguage.en: 'Register'},
    'logout': {AppLanguage.ru: 'Выйти', AppLanguage.en: 'Logout'},
    'support': {AppLanguage.ru: 'Поддержка', AppLanguage.en: 'Support'},
    'save': {AppLanguage.ru: 'Сохранить', AppLanguage.en: 'Save'},
    'cancel': {AppLanguage.ru: 'Не сохранять', AppLanguage.en: 'Do not save'},
    'income': {AppLanguage.ru: 'Доход', AppLanguage.en: 'Income'},
    'expense': {AppLanguage.ru: 'Расход', AppLanguage.en: 'Expense'},
    'day': {AppLanguage.ru: '1 день', AppLanguage.en: '1 day'},
    'week': {AppLanguage.ru: 'Неделя', AppLanguage.en: 'Week'},
    'month': {AppLanguage.ru: 'Месяц', AppLanguage.en: 'Month'},
    '3months': {AppLanguage.ru: '3 месяца', AppLanguage.en: '3 months'},
    '6months': {AppLanguage.ru: '6 месяцев', AppLanguage.en: '6 months'},
    'year': {AppLanguage.ru: '1 год', AppLanguage.en: '1 year'},
  };

  static String of(AppLanguage language, String key) {
    return _data[key]?[language] ?? key;
  }
}
