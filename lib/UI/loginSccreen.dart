import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usertrackapp/UI/HomeScreen.dart';
import 'package:usertrackapp/UI/SignUpScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();


@override
  void initState() {
    getCurrentPosition();
    // TODO: implement initState
    super.initState();
  }

      Position? _currentPosition;
      Future _handleLocationPermission() async {
    LocationPermission permission;
    bool? serviceEnabled;

    serviceEnabled = await Geolocator
        .isLocationServiceEnabled(); // Will check whether device location is enabled or not

    if (serviceEnabled == false) {}
    permission = await Geolocator.checkPermission();
print(permission);
    if (permission == LocationPermission.denied) {
      permission = await Geolocator
          .requestPermission(); // If user denied permission it will ask again for location permission
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    return true;
  }

  /// This function will return user current LatLong

  Future getCurrentPosition() async {
  
    await _handleLocationPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });
  print(_currentPosition);

      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
     
    });
  }

  /// This will Run  after _handleLocationPermission function and will return Full address from LatLong if permission has given by user

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks.first;
     // var state = place.administrativeArea;
    print(place);
      //stateNamefromLatLong(place.administrativeArea);
    }).catchError(
      (e) {
        print(e);
      },
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
      
        FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: _passwordController.text).then((value) => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Homescreen()),
  ).onError((error, stackTrace){
    print(error);
  }));
        //taskcontroller.loginUser(usernameController.text, PasswordController.text);
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffbb448), Color(0xfff7892b)])),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: Container(
                  child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  //clipper: ClipPainter(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .5,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(color: Color.fromRGBO(255, 128, 128, 1)
                            // gradient: LinearGradient(
                            //   begin: Alignment.topCenter,
                            //   end: Alignment.bottomCenter,

                            //  //colors: [Color(0xfffbb448),Color(0xffe46b10)]
                            // )
                            ),
                  ),
                ),
              ))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  Form(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: height * .2),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Email",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                      // obscureText: isPassword,
                                      controller: _emailController,
                                      onChanged: (value) {},
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true))
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const Text(
                                    "Password",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                      // obscureText: isPassword,
                                      controller: _passwordController,
                                      onChanged: (value) {},
                                      decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          fillColor: Color(0xfff3f3f4),
                                          filled: true))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _submitButton(),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
