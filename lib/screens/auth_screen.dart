import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/app_strings.dart';
import '../core/api_service.dart';
import '../widgets/section_card.dart';

class AuthScreen extends StatefulWidget {
  final AppState state;

  const AuthScreen({
    super.key,
    required this.state,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _loginIdController = TextEditingController(text: 'admin@life.kz');
  final _loginPasswordController = TextEditingController(text: 'admin123');

  final _regNameController = TextEditingController(text: 'New user');
  final _regEmailController = TextEditingController(text: 'friend@life.kz');
  final _regPasswordController = TextEditingController(text: '123456');

  bool isLogin = true;
  bool isLoading = false;
  String? error;

  @override
  void dispose() {
    _loginIdController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      if (isLogin) {
        final email = _loginIdController.text.trim();
        final password = _loginPasswordController.text.trim();

        final result = await ApiService.login(email, password);

        if (result != null) {
          await widget.state.login(email, password);

          if (!mounted) return;

          setState(() => error = null);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Успешный вход ✅')),
          );
        } else {
          if (!mounted) return;
          setState(() {
            error = 'Қате логин немесе пароль. Admin: admin@life.kz / admin123';
          });
        }
      } else {
        final ok = await widget.state.register(
          _regNameController.text.trim(),
          _regEmailController.text.trim(),
          _regPasswordController.text.trim(),
        );

        if (!mounted) return;

        if (ok) {
          setState(() {
            isLogin = true;
            error = null;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Аккаунт сәтті тіркелді ✅')),
          );
        } else {
          setState(() {
            error = 'Регистрация қатесі. Басқа email қолданып көріңіз.';
          });
        }
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error =
            'Backend қосылмады. Алдымен backend іске қосыңыз: cd backend → npm start';
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _leftBlock(BuildContext context, bool isRu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _GlassTag(text: 'Flutter • Backend • Database • Team Mode'),
        const SizedBox(height: 22),
        Text(
          'Life Tracker Pro',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 14),
        Text(
          isRu
              ? 'Жеке және командалық трекер: әдеттер, қаржы, жоспар, жазбалар және топтық тапсырмалар бір жерде.'
              : 'Personal and team tracker: habits, finance, plans, notes and group tasks in one app.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 18),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _MiniTag('Admin/User roles'),
            _MiniTag('Team tasks'),
            _MiniTag('Search'),
            _MiniTag('RU / EN'),
            _MiniTag('SQLite backend'),
          ],
        ),
      ],
    );
  }

  Widget _loginCard(BuildContext context) {
    return SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ChoiceChip(
                label: Text(widget.state.t('login')),
                selected: isLogin,
                onSelected: (_) {
                  setState(() {
                    isLogin = true;
                    error = null;
                  });
                },
              ),
              ChoiceChip(
                label: Text(widget.state.t('register')),
                selected: !isLogin,
                onSelected: (_) {
                  setState(() {
                    isLogin = false;
                    error = null;
                  });
                },
              ),
              IconButton(
                onPressed: widget.state.toggleLanguage,
                icon: const Icon(Icons.language),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isLogin ? 'Вход / Login' : 'Регистрация',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Admin: admin@life.kz / admin123\nUser: user@life.kz / user123',
          ),
          const SizedBox(height: 16),
          if (isLogin) ...[
            TextField(
              controller: _loginIdController,
              decoration: const InputDecoration(
                labelText: 'Email немесе логин',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _loginPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Құпия сөз / Password',
              ),
            ),
          ] else ...[
            TextField(
              controller: _regNameController,
              decoration: const InputDecoration(labelText: 'Аты / Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _regEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _regPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 10),
            Text(
              error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isLoading ? null : _submit,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.arrow_forward),
              label: Text(
                isLoading
                    ? 'Күтіңіз...'
                    : isLogin
                        ? 'Кіру / Войти'
                        : 'Тіркелу / Register',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRu = widget.state.language == AppLanguage.ru;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1080),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth > 820;

                    if (wide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: _leftBlock(context, isRu),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 4,
                            child: _loginCard(context),
                          ),
                        ],
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: _leftBlock(context, isRu),
                        ),
                        const SizedBox(height: 20),
                        _loginCard(context),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String text;

  const _MiniTag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(0.7),
      ),
      child: Text(text),
    );
  }
}

class _GlassTag extends StatelessWidget {
  final String text;

  const _GlassTag({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Colors.white.withOpacity(0.75),
      ),
      child: Text(text),
    );
  }
}
