import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone_firebase/Screens/login_screen.dart';
import 'package:insta_clone_firebase/resources/auth_methods.dart';
import 'package:insta_clone_firebase/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading= true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading= false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context)=> const ResponsiveLayout(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout()),),);
    }
  }

  void navigateToLogin(){
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const  LoginScreen(),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          // color: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),

            const Image(
              image: AssetImage('assets/images/img.png'),
              color: primaryColor,
              height: 64,
            ),


            // //svg image logo
            // SvgPicture.asset(
            //   'assets/images/ic_instagram.svg',
            //   colorFilter: const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            //   height: 64,
            // ),
            const SizedBox(
              height: 64,
            ),

            //circular widget to take user profile pic and show our selected file from gallery
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage:
                            NetworkImage('https://i.stack.imgur.com/l60Hf.png'),
                        // backgroundColor: Colors.red,
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(Icons.add_a_photo)))
              ],
            ),

            const SizedBox(
              height: 24,
            ),
            //Text field for username
            TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter Your Username',
                textInputType: TextInputType.text),
            //text field input for password
            const SizedBox(
              height: 24,
            ),
            //text field input for email
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter Your Email',
                textInputType: TextInputType.emailAddress),
            //text field input for password
            const SizedBox(
              height: 24,
            ),

            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter Your Password',
              textInputType: TextInputType.number,
              isPass: true,
            ),

            const SizedBox(
              height: 24,
            ),

            //Textfield for profile bio
            TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter Your Bio',
                textInputType: TextInputType.text),
            //text field input for password
            const SizedBox(
              height: 24,
            ),

            //button for login

            InkWell(
              onTap: signUpUser,
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: const ShapeDecoration(
                    color: blueColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    )),
                child: _isLoading?
                    const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor ,
                      ),
                    )
                    :const Text(
                  'Sign up',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Flexible(
              flex: 2,
              child: Container(),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Text("Have an account?"),
                ),
                GestureDetector(
                  onTap:navigateToLogin,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            // transitioning to signing up
          ]),
        ),
      ),
    );
  }
}
