// lib/repositories/auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  // Login
  Future<void> login(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign Up
  Future<void> signUp(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Send Password Reset
  Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Auth state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
