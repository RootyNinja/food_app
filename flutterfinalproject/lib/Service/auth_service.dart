import "package:flutterfinalproject/Pages/Auth/login_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:flutter/material.dart";

class AuthService {
  final supabase = Supabase.instance.client;

  //Signup function
  Future<String?> signup(String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        password: password,
        email: email,
      );
      if (response.user != null) {
        return null;
      }
      return "An unknown error occured";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error:$e";
    }
  }

  //login Function
  Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user != null) {
        return null;
      }
      return "Invalid Email or Password";
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "Error:$e";
    }
  }

  //function Logoutt
  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    } catch (e) {
      print("object");
    }
  }
}
