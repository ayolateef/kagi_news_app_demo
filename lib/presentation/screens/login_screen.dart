import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      // try {
      //   await FirebaseAuth.instance.signInWithEmailAndPassword(
      //     email: _emailController.text.trim(),
      //     password: _passwordController.text.trim(),
      //   );
      // } on FirebaseAuthException catch (e) {
      //   setState(() {
      //     _errorMessage = e.message;
      //   });
      // } finally {
      //   setState(() => _isLoading = false);
      // }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'News Aggregator',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your email' : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  obscureText: true,
                  validator: (value) =>
                  value!.isEmpty ? 'Please enter your password' : null,
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: colorScheme.error),
                  ),
                ],
                SizedBox(height: 24.h),
                _isLoading
                    ? CircularProgressIndicator(color: colorScheme.secondary)
                    : ElevatedButton(
                  onPressed: _signIn,
                  child: const Text('Sign In'),
                ),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    // Placeholder for sign-up flow
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign-up not implemented yet')),
                    );
                  },
                  child: Text(
                    'Don’t have an account? Sign Up',
                    style: TextStyle(color: colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}