import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ruvu/auth/sign_up.dart';
import 'package:ruvu/screens/home_page.dart';
import 'package:another_flushbar/flushbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String _errorMessage = 'Please enter valid username and password';

  void _showError(String errorMessage) {
    setState(() {
      errorMessage = _errorMessage;
    });
  }

  void _clearError() {
    setState(() {
      _errorMessage = '';
    });
  }

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });
    _clearError();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigate to the home screen
      Navigator.of(context).push(MaterialPageRoute(builder:(context) => const HomePage()));
    } catch (e) {
      _showError(_errorMessage);
      Flushbar(
        title: 'Invalid Username/Password',
        message: 'Please enter correct username/password',
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 5),
      ).show(context);

      setState(() {
        isLoading = false;
      });
    }
  }


  bool _obscuredText = true;

  _toggle(){
    setState(() {
      _obscuredText = !_obscuredText;
    });
  }

  void validateData() async {
    if (_emailController.text.trim().isEmpty) {
      Flushbar(
        title: 'Credentials Missing',
        message: 'Please email',
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else if (_passwordController.text.trim().isEmpty) {
      Flushbar(
        title: 'Credentials Missing',
        message: 'Please enter password',
        flushbarPosition: FlushbarPosition.BOTTOM,
        backgroundColor: Colors.black54,
        duration: const Duration(seconds: 3),
      ).show(context);
    } else {
      _handleLogin();
    }
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/Ruvu_River.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.linearToSrgbGamma()
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const CircleAvatar(
                radius: 50,
                child: Icon(Icons.person,
                size: 50,
                ),
              ),
              const SizedBox(height: 20,),
              const Text('Login To Continue',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    //  if (_errorMessage.isNotEmpty)
                    //     Text(
                    //       _errorMessage,
                    //       style: const TextStyle(color: Colors.red),
                    //     ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            }
                            return 'Please enter your email';
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      StatefulBuilder(builder: (_context, _setState){
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: _passwordController,
                            decoration:InputDecoration(
                                labelText: 'Password',
                                border: const OutlineInputBorder(),
                                enabledBorder:  const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 1.5),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: (){
                                     _toggle();
                                    },
                                    icon: Icon(
                                        _obscuredText ? Icons.visibility : Icons.visibility_off
                                    )),

                            ),
                            obscureText: _obscuredText,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: ElevatedButton(
                          onPressed: validateData,
                          child: isLoading? const CircularProgressIndicator(color: Colors.white,) :  const Text('Login',
                          style: TextStyle(
                            fontSize: 20
                          ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20,),
                      const Text('Do not have Account?',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black
                      ),
                      ),
                      const SizedBox(height: 10,),
                      TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder:(context) => const SignUpScreen()));
                      }, child: const Text('Create Account Here',
                        style: TextStyle(
                            fontSize: 15,
                          fontWeight: FontWeight.w900
                        ),
                      ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }

