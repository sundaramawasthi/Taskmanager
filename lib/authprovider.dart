// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authRepository.dart';

// FirebaseAuth instance
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// AuthRepository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(firebaseAuth);
});

// Auth state stream provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

// Auth controller provider
final authControllerProvider = Provider<AuthController>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository);
});

// AuthController for UI interaction
class AuthController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  Future<void> login(String email, String password) {
    return _authRepository.login(email, password);
  }

  Future<void> signUp(String email, String password) {
    return _authRepository.signUp(email, password);
  }

  Future<void> sendPasswordReset(String email) {
    return _authRepository.sendPasswordReset(email);
  }

  Future<void> logout() {
    return _authRepository.logout();
  }

  User? get currentUser => _authRepository.getCurrentUser();
}
