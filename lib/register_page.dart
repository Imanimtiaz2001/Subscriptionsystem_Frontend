import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final textColor = const Color(0xFF333333);
  final primaryColor = const Color(0xFFC4C7FA);
  final borderColor = const Color(0xFFF3F3F3);

  // Dialog box to show success or failure messages
  Future<void> showDialogBox(BuildContext context, String message, bool isSuccess) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                emailController.clear();
                passwordController.clear();
                confirmPasswordController.clear();
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Build method to create the widget tree for Register Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo and text section
              _buildLogo(),

              const SizedBox(height: 35),

              // Registration Form container
              _buildRegistrationForm(context),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build the logo and text at the top of the page
  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/logo.PNG',
          width: 40,
          height: 40,
        ),
        const SizedBox(width: 10),
        Text(
          "LOGO",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: textColor,
            fontSize: 28,
          ),
        ),
      ],
    );
  }

  // Method to build the registration form UI
  Widget _buildRegistrationForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome Text
          _buildWelcomeText(),

          const SizedBox(height: 30),

          // Email Address input field
          _buildTextField("Email Address", emailController),

          const SizedBox(height: 16),

          // Password input field
          _buildPasswordField("Password", passwordController, _isPasswordVisible, (value) {
            setState(() {
              _isPasswordVisible = value;
            });
          }),

          const SizedBox(height: 16),

          // Confirm Password input field
          _buildPasswordField("Confirm Password", confirmPasswordController, _isConfirmPasswordVisible, (value) {
            setState(() {
              _isConfirmPasswordVisible = value;
            });
          }),

          const SizedBox(height: 24),

          // Create Account Button
          _buildCreateAccountButton(context),

          const SizedBox(height: 5), // Space between button and text

          // Already have an account? Text with link to Login page
          _buildAlreadyAccountText(context),
        ],
      ),
    );
  }

  // Welcome message text widget
  Widget _buildWelcomeText() {
    return Center(
      child: Column(
        children: [
          Text(
            "Welcome",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 25,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Create an account to get started.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Method to create input fields with respective text
  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 15),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  // Method to build password fields with visibility toggles
  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, Function toggleVisibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w400, fontSize: 15),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                toggleVisibility(!isVisible);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Create Account Button widget
  Widget _buildCreateAccountButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          String message = await Provider.of<AuthProvider>(context, listen: false)
              .register(emailController.text, passwordController.text, confirmPasswordController.text);
          bool isSuccess = message == 'User registered successfully';
          showDialogBox(context, message, isSuccess);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        ),
        child: Text(
          "Create Account",
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Already have an account? Text with link to Login page
  Widget _buildAlreadyAccountText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account?",
          style: TextStyle(
            color: textColor,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: Text(
            " Sign in",
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}