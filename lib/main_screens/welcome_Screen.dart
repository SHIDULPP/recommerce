import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/main_screens/supplier_home.dart';
import '../widgets/yellowbuttion.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const textColors = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  //Colors.green,
  Colors.purple,
  //Colors.teal
];
const textstyle = const TextStyle(
    fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;

  late AnimationController _controller;
  bool processing = false;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 59, 101),
      body: Container(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage('images/inapp/bgimage.jpg'),
        //         fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40,),
                AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText('WELCOME',
                        textStyle: textstyle, colors: textColors),
                    ColorizeAnimatedText('RECOMMERCE',
                        textStyle: textstyle, colors: textColors)
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                ),

                // const Text(
                //   'WELCOME',
                //   style: TextStyle(color: Colors.white, fontSize: 30),
                // ),
                const SizedBox(
                  height: 160,
                  width: 220,
                  child: Image(image: AssetImage('assets/images/logo.png')),//images/inapp/logo.jpg
                ),
                SizedBox(
                  height: 80,
                  child: DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 45,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Acme'),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ScaleAnimatedText('Elevate Your'),
                        ScaleAnimatedText('Shoping'),
                        ScaleAnimatedText('Experience'),
                      ],
                      repeatForever: true,
                    ),
                  ),
                ),
                //  const Text(
                //               'Suppliers login',
                //               style: TextStyle(
                //                   color: Colors.yellowAccent,
                //                   fontSize: 16,
                //                   fontWeight: FontWeight.w600),
                //             ),
                YellowButton(
                                  width: 0.65,
                                  label: 'Log In as supplier',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/supplier_login');
                                  },
                                ),
                YellowButton(
                          width: 0.65,
                          label: 'Customer Log In',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, '/customer_login');
                          },
                        ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Container(
                //           decoration: const BoxDecoration(
                //               //color: Colors.white38,
                //               borderRadius: BorderRadius.only(
                //                   topLeft: Radius.circular(50),
                //                   bottomLeft: Radius.circular(50))),
                //           child: const Padding(
                //             padding: EdgeInsets.all(12.0),
                //             child: Text(
                //               'Suppliers login',
                //               style: TextStyle(
                //                   color: Colors.yellowAccent,
                //                   fontSize: 26,
                //                   fontWeight: FontWeight.w600),
                //             ),
                //           ),
                //         ),
                //         const SizedBox(
                //           height: 6,
                //         ),
                //         Row(
                //           mainAxisAlignment: MainAxisAlignment.start,
                //           children: [
                //             Row(
                //               mainAxisAlignment:
                //                   MainAxisAlignment.center,
                //               children: [
                //                 //AnimatedLogo(controller: _controller),
                //                 YellowButton(
                //                   width: 0.25,
                //                   label: 'Log In',
                //                   onPressed: () {
                //                     Navigator.pushReplacementNamed(
                //                         context, '/supplier_login');
                //                   },
                //                 ),
                //                 const SizedBox(width: 20,),
                //                 Padding(
                //                   padding: const EdgeInsets.only(right: 8),
                //                   child: YellowButton(
                //                     width: 0.25,
                //                     label: 'Sign up',
                //                     onPressed: () {
                //                       Navigator.pushReplacementNamed(
                //                           context, '/supplier_signup');
                //                     },
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // Container(
                //   height: 60,
                //   width: MediaQuery.of(context).size.width * 0.9,
                //   decoration: const BoxDecoration(
                //       //color: Colors.white38,
                //       borderRadius: BorderRadius.only(
                //           topRight: Radius.circular(50),
                //           bottomRight: Radius.circular(50))),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.only(left: 8),
                //         child: YellowButton(
                //           width: 0.25,
                //           label: 'Log In',
                //           onPressed: () {
                //             Navigator.pushReplacementNamed(
                //                 context, '/customer_login');
                //           },
                //         ),
                //       ),
                //       const SizedBox(width: 20,),
                //       YellowButton(
                //         width: 0.25,
                //         label: 'Sign up',
                //         onPressed: () {
                //           Navigator.pushReplacementNamed(
                //               context, '/customer_signup');
                //         },
                //       ),
                //       //AnimatedLogo(controller: _controller),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 40,)
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 25),
                //   child: Container(
                //     decoration:
                //         BoxDecoration(color: Colors.white38.withOpacity(0.3)),
                //     child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                //         children: [
                //           GoogleFacebookLogIn(
                //             label: 'Google',
                //             onPressed: () {},
                //             child: const Image(
                //                 image: AssetImage('images/inapp/google.jpg')),
                //           ),
                //           GoogleFacebookLogIn(
                //             label: 'Facebook',
                //             onPressed: () {},
                //             child: const Image(
                //                 image: AssetImage('images/inapp/facebook.jpg')),
                //           ),
                //           processing == true
                //               ? const CircularProgressIndicator()
                //               : GoogleFacebookLogIn(
                //                   label: 'Guest',
                //                   onPressed: () async {
                //                     setState(() {
                //                       processing = true;
                //                     });

                //                     await FirebaseAuth.instance
                //                         .signInAnonymously()
                //                         .whenComplete(() async {
                //                       _uid = FirebaseAuth
                //                           .instance.currentUser!.uid;
                //                       await anonymous.doc(_uid).set({
                //                         'name': '',
                //                         'email': '',
                //                         'profileimage': '',
                //                         'phone': '',
                //                         'address': '',
                //                         'cid': _uid,
                //                       });
                //                     });

                //                     Navigator.pushReplacementNamed(
                //                         context, '/customer_home');
                //                   },
                //                   child: const Icon(
                //                     Icons.person,
                //                     size: 55,
                //                     color: Colors.lightBlueAccent,
                //                   ))
                //         ]),
                //   ),
                // )
              ]),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    super.key,
    required AnimationController controller,
  }) : _controller = controller;

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(
        image: AssetImage('images/inapp/logo.jpg'),
      ),
    );
  }
}

class GoogleFacebookLogIn extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Widget child;
  const GoogleFacebookLogIn(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
