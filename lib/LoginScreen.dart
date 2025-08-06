import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'RegistrationScreen.dart';
import 'TaskProviderprovider.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final showPassword = ValueNotifier<bool>(false);

    void showSnack(String message, {Color? color}) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color ?? Colors.black,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }

    Future<void> login() async {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        showSnack("Please enter email and password", color: Colors.red);
        return;
      }

      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final user = credential.user;

        // ✅ Ensure Firestore User Document Exists
        if (user != null) {
          final userDoc = FirebaseFirestore.instance.collection('User').doc(user.uid);
          final snapshot = await userDoc.get();

          if (!snapshot.exists) {
            await userDoc.set({
              'email': user.email,
              'createdAt': Timestamp.now(),
              // You can add more fields like name or role
            });
          }
        }

        ref.read(userIdProvider.notifier).state = FirebaseAuth.instance.currentUser!.uid;

        showSnack("Login successful!", color: Colors.green);
        Navigator.pushReplacementNamed(context, '/home');


      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Incorrect password.';
        } else {
          message = 'Login failed. ${e.message}';
        }
        showSnack(message, color: Colors.red);
      }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              // Logo + Title
              Column(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome !',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Email Field
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email Address",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Password Field with toggle
              ValueListenableBuilder<bool>(
                valueListenable: showPassword,
                builder: (context, value, child) {
                  return TextField(
                    controller: passwordController,
                    obscureText: !value,
                    decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          value ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => showPassword.value = !value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),

              // Forgot Password Link
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ResetPasswordScreen()),
                  ),
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text("Log in", style: TextStyle(fontSize: 16,color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Divider

              const SizedBox(height: 12),

              // Social Login Buttons (UI only)

              const SizedBox(height: 24),

              // Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    ),
                    child: const Text(
                      "Get started!",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialCircleButton(IconData icon, Color color) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    );
  }
}
