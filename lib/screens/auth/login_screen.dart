import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../api/result_api.dart';
import '../../components/dialog_loading.dart';
import '../../controllers/userController.dart';
import '../../core/theme.dart';
import '../home/home_screen.dart'; // Importation du thème global

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  double _logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Délai pour animer l'apparition du logo
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _logoOpacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // Status bar en blanc
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gamThemeData.primaryColor.withAlpha(220), // Bleu principal dominant
                gamThemeData.primaryColor.withAlpha(180), // Bleu plus clair
                gamThemeData.colorScheme.secondary.withAlpha(100), // Jaune réduit en intensité
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo circulaire animé avec ombre blanche
                    AnimatedOpacity(
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      opacity: _logoOpacity,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8), // Ombre blanche
                              blurRadius: 15,
                              spreadRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo.jpg',
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),

                    // Champ Numéro de téléphone
                    TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.phone,
                      textAlignVertical: TextAlignVertical.center, // Centre verticalement le texte
                      decoration: InputDecoration(
                        hintText: "Numéro de téléphone",
                        prefixIcon: Icon(Icons.phone, color: gamThemeData.primaryColor),
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre numéro de téléphone";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Champ Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: "Mot de passe",
                        prefixIcon: Icon(Icons.lock, color: gamThemeData.primaryColor),
                        suffixIcon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: IconButton(
                            key: ValueKey<bool>(_isObscure),
                            icon: Icon(
                              _isObscure ? Icons.visibility_off : Icons.visibility,
                              color: gamThemeData.primaryColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                        ),
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 15,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre mot de passe";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 50),

                    // Bouton Connexion
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await _login();
                        },
                        child: Text(
                          "Se Connecter",
                          style: gamThemeData.textTheme.bodyLarge?.copyWith(
                            color: gamThemeData.colorScheme.onPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Vous pouvez réactiver l'inscription ou le mot de passe oublié si nécessaire
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _login() async {
    final number = _numberController.text.trim();
    final password = _passwordController.text.trim();

    if (number.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: gamThemeData.colorScheme.error, // 🔴 Couleur d'erreur
          content: Text(
            "Remplissez tous les champs",
            style: gamThemeData.textTheme.bodyMedium?.copyWith( // Utilisation du texte défini dans le thème
              color: gamThemeData.colorScheme.onError, // Texte contrasté sur erreur
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
      return;
    }

    DialogLoading(context);

    ResultApi result = await UserController.login(number, password);

    Navigator.pop(context);

    if (result.code == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.data,
            style: gamThemeData.textTheme.bodyLarge?.copyWith( // Texte principal du thème
              color: gamThemeData.colorScheme.onPrimary, // Texte contrasté sur fond principal
              fontFamily: 'Poppins',
            ),
          ),
          backgroundColor: gamThemeData.colorScheme.primary, // 🔵 Couleur principale
          duration: const Duration(seconds: 1),
        ),
      );
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: gamThemeData.colorScheme.error, // 🔴 Couleur d'erreur
          content: Text(
            result.data,
            style: gamThemeData.textTheme.bodyMedium?.copyWith(
              color: gamThemeData.colorScheme.onError, // Texte contrasté
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }
  }
}
