import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/appbar_widgets.dart';
import 'package:multi_store_app/widgets/yellowbuttion.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
                child: Center(child: CircularProgressIndicator()));
          }

          double totalPrice = 0.0;
          for (var item in snapshot.data!.docs) {
            totalPrice += item['orderqty'] * item['orderprice'];
          }

          return Scaffold(
              appBar: AppBar(
                title: const AppBarTitle(title: 'Balance'),
                leading: const AppBarBackButton(),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BalanceModel(
                      label: 'total balance',
                      value: totalPrice,
                      decimal: 2,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(25)),
                        child: MaterialButton(
                            onPressed: () {}, child: Text('Get My Money'))),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ));
        });
  }
}

class BalanceModel extends StatelessWidget {
  final String label;
  final dynamic value;
  final int decimal;
  const BalanceModel(
      {super.key,
      required this.label,
      required this.decimal,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Column(
        children: [
          Container(
            height: 60,
            width: MediaQuery.of(context).size.width * 0.55,
            decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Center(
                child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 24),
            )),
          ),
          Container(
            height: 90,
            width: MediaQuery.of(context).size.width * 0.70,
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: AnimatedCounter(
              count: value,
              decimal: decimal,
            ),
          )
        ],
      )
    ]);
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic count;
  final int decimal;
  const AnimatedCounter(
      {super.key, required this.decimal, required this.count});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _controller;

    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Center(
              child: Text(
            _animation.value.toStringAsFixed(widget.decimal),
            style: const TextStyle(
                color: Colors.pink,
                fontSize: 40,
                letterSpacing: 2,
                fontFamily: 'Acme',
                fontWeight: FontWeight.bold),
          ));
        });
  }
}
