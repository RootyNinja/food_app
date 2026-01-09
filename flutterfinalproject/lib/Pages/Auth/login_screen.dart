import "package:flutter/material.dart";
import "package:flutterfinalproject/Pages/Auth/signup_screen.dart";
import "package:flutterfinalproject/Pages/Screen/onboarding_screen.dart";
import "package:flutterfinalproject/Widgets/my_button.dart";

import "../../Service/auth_service.dart";
import "../../Widgets/snack_bar.dart";
import "../Screen/profile_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool isPasswordHidden=false;

  final AuthService _authService= AuthService();
  bool isLoadin=false;

  void _login()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();
    if(!mounted){
      return;
    };
    setState(() {
      isLoadin=true;
    });
    final result = await _authService.login(email, password);
    if(result==null){

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ProfileScreen()),);
      setState(() {
        isLoadin=false;
      });
    }
    else{
      setState(() {
        isLoadin=false;
      });
      showSnackBar(context, "Signup Failed:$result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: const EdgeInsets.all(15),child: Column(
        children: [
          Image.asset("assets/logo.png",width: double.maxFinite, height: 400, fit: BoxFit.contain,),
          TextField(
            controller:emailController,
            decoration: InputDecoration(labelText: "Email",border: OutlineInputBorder()),),
          SizedBox(height: 20,),
          TextField(
            controller:passwordController,
            decoration: InputDecoration(labelText: "Password",border: OutlineInputBorder(),
                suffixIcon: IconButton(onPressed: () {setState(() {
                  isPasswordHidden=!isPasswordHidden;
                });;}, icon: Icon(isPasswordHidden ? Icons.visibility_off:  Icons.visibility))),obscureText: isPasswordHidden,),
          SizedBox(height: 20,),
          isLoadin ? Center(child: CircularProgressIndicator(),):
          SizedBox(width: double.maxFinite,
            child: MyButton(onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>OnboardingScreen()));
            },  buttontext: "Login"),),
          SizedBox(height: 20,),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [ Text("Don't have an account?",style: TextStyle(fontSize: 18),)],),
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>SignupScreen()),);
            },
            child: Text("Signup",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: -1),),
          )
        ],
      ),),
    );
  }
}
