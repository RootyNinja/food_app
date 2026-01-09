import "package:flutter/material.dart";
import "package:flutterfinalproject/Pages/Auth/login_screen.dart";
import "package:flutterfinalproject/Service/auth_service.dart";
import "package:flutterfinalproject/Widgets/my_button.dart";
import "package:flutterfinalproject/Widgets/snack_bar.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool isPasswordHidden =false;

  final AuthService _authService= AuthService();
  bool isLoadin=false;

  void _signUp()async{
    String email=emailController.text.trim();
    String password=passwordController.text.trim();

    //validate email format
    if(!email.contains("@gmail.com")){
      showSnackBar(context, "Invalid email");
    }
    setState(() {
      isLoadin=true;
    });
    final result = await _authService.signup(email, password);
    if(result==null){
      showSnackBar(context, "Signup Successfuly");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()),);
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
          Image.asset("assets/6343825.jpg",width: double.maxFinite, height: 400, fit: BoxFit.cover,),
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
            child: MyButton(onTap: _signUp,  buttontext: "Signup"),),
          SizedBox(height: 20,),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [ Text("Already have an account?",style: TextStyle(fontSize: 18),)],),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()),);
          },

          child: Text("Login",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,
          color: Colors.blue,
          letterSpacing: -1),)
        )],
      ),),
    );
  }
}
