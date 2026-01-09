import "package:flutter/material.dart";
import "package:flutterfinalproject/Pages/Auth/login_screen.dart";
import "package:flutterfinalproject/Pages/Auth/signup_screen.dart";
import "package:flutterfinalproject/Pages/Screen/app_main_screen.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "Pages/Screen/profile_screen.dart";

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://iujralkwwpmmumkeofqv.supabase.co",
      anonKey: "sb_publishable_mPKRmJq68D2JgpjPjx5yUQ_L9nt6BK5");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
      );
  }

}

class AuthCheck extends StatelessWidget {
  final supabase= Supabase.instance.client;
  AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: supabase.auth.onAuthStateChange,
        builder: (context , snapshot){
      final session=supabase.auth.currentSession;
      if(session!=null){
        return AppMainScreen();
      }else{
        return LoginScreen();
      }
        return LoginScreen();
        });
  }
}


