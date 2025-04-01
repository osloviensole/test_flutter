import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme.dart'; // Importation du thème global

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isConfirmObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gamThemeData.colorScheme.secondary.withAlpha(100), // Jaune en haut
                gamThemeData.primaryColor.withAlpha(180), // Bleu clair au milieu
                gamThemeData.primaryColor.withAlpha(220), // Bleu foncé en bas
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
                    // Logo circulaire avec ombre blanche
                    Container(
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
                          height: 140,
                          width: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Champ Nom
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Nom complet",
                        labelStyle: gamThemeData.textTheme.bodyLarge,
                        prefixIcon: Icon(Icons.person, color: gamThemeData.primaryColor),
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre nom";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Champ Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: gamThemeData.textTheme.bodyLarge,
                        prefixIcon: Icon(Icons.email, color: gamThemeData.primaryColor),
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Champ Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        labelStyle: gamThemeData.textTheme.bodyLarge,
                        prefixIcon: Icon(Icons.lock, color: gamThemeData.primaryColor),
                        suffixIcon: IconButton(
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
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "Le mot de passe doit contenir au moins 6 caractères";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Champ Confirmation Mot de passe
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _isConfirmObscure,
                      decoration: InputDecoration(
                        labelText: "Confirmer le mot de passe",
                        labelStyle: gamThemeData.textTheme.bodyLarge,
                        prefixIcon: Icon(Icons.lock_outline, color: gamThemeData.primaryColor),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmObscure ? Icons.visibility_off : Icons.visibility,
                            color: gamThemeData.primaryColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmObscure = !_isConfirmObscure;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: gamThemeData.colorScheme.surface.withAlpha(240),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return "Les mots de passe ne correspondent pas";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Bouton S'inscrire
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            // Ajouter la logique d'inscription ici
                          }
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: gamThemeData.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "S'inscrire",
                              style: gamThemeData.textTheme.bodyLarge?.copyWith(
                                color: gamThemeData.colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Lien vers connexion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vous avez déjà un compte ?", style: gamThemeData.textTheme.bodyMedium),
                        TextButton(
                          onPressed: () {
                            // Naviguer vers l'écran de connexion
                          },
                          child: Text(
                            "Se connecter",
                            style: gamThemeData.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: gamThemeData.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
