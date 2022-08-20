import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/authentication_bloc.dart';
import '../globals.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;
  bool availableToPop = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    availableToPop = Navigator.canPop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext pageContext) {
    return WillPopScope(
      onWillPop: () => onWillPopExit(context, availableToPop),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  "assets/images/eden_farm_logo.jpg",
                  alignment: Alignment.center,
                  height: 300.0,
                ),
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, authenticationState) {
                  if(authenticationState is AuthenticationUnauthenticated) {
                    obscurePassword = authenticationState.isObscurePassword;
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Email",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: emailController,
                            enabled: authenticationState is AuthenticationLoading ? false : true,
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => val!.isEmpty ? "Email is required" : null,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.all(10),
                              hintText: "",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0
                                ),
                              )
                            ),
                            onChanged: (val) {
                              if(authenticationState is AuthenticationError) {
                                BlocProvider.of<AuthenticationBloc>(context).add(
                                  ResetErrorStateToInitial(),
                                );
                              }
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5)
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            controller: passwordController,
                            enabled: authenticationState is AuthenticationLoading ? false : true,
                            obscureText: obscurePassword,
                            keyboardType: TextInputType.text,
                            validator: (val) => val!.isEmpty ? "Password is required" : null,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(10),
                              hintText: "",
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 0
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context).add(
                                    SetObscurePassword()
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 15)
                        ),
                        authenticationState is AuthenticationError ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Center(
                            child: Text(
                              authenticationState.errorMessage,
                              style: const TextStyle(
                                color: Colors.red
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ) : Container(),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5)
                        ),
                        authenticationState is AuthenticationLoading ? loadingProgressIndicator : Container(
                          decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(25.0))
                          ),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)
                            ),
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthenticationBloc>(context).add(
                                  LogIn(
                                    emailAddress: emailController.text.toLowerCase(),
                                    password: passwordController.text,
                                    mounted: mounted,
                                    pageContext: context
                                  ),
                                );
                              }
                            },
                            child: const SizedBox(
                              height: 40,
                              width: 300.0,
                              child: Center(
                                child: Text(
                                  "Sign in",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20)
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}