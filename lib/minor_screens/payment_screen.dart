import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/stripe_id.dart';

import '../widgets/appbar_widgets.dart';

import 'package:multi_store_app/widgets/yellowbuttion.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/cart_provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;

  const PaymentScreen(
      {super.key,
      required this.name,
      required this.phone,
      required this.address});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');

  void showProgess() {
    //something progress bar
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.grey.shade200,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(title: 'Payment'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total order',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shipping cost',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                    Text(
                                      '10.00' + ('USD'),
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(children: [
                            RadioListTile(
                              value: 1,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text('Cash on Delivery'),
                              subtitle: const Text('Pay cash at home'),
                            ),
                            RadioListTile(
                              value: 2,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text('Pay via visa / Master Card'),
                              subtitle: Row(children: const [
                                Icon(
                                  Icons.payment,
                                  color: Colors.blue,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Icon(FontAwesomeIcons.ccMastercard,
                                      color: Colors.blue),
                                ),
                                Icon(FontAwesomeIcons.ccVisa,
                                    color: Colors.blue)
                              ]),
                            ),
                            RadioListTile(
                              value: 3,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                              },
                              title: const Text('Pay via Paypal'),
                              subtitle: Row(
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.ccPaypal,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Icon(
                                    FontAwesomeIcons.paypal,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ]),
                        ),
                      ),
                    ]),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                        label: 'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                        width: 1,
                        onPressed: () {
                          if (selectedValue == 1) {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 100),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                                'Pay at Home ${totalPaid.toStringAsFixed(2)} \$',
                                                style: const TextStyle(
                                                    fontSize: 24)),
                                            YellowButton(
                                                label:
                                                    'Confirm ${totalPaid.toStringAsFixed(2)}\$S',
                                                onPressed: () async {
                                                  showProgess();
                                                  for (var item in context
                                                      .read<Cart>()
                                                      .getItems) {
                                                    CollectionReference
                                                        orderRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'orders');
                                                    orderId = const Uuid().v4();
                                                    await orderRef
                                                        .doc(orderId)
                                                        .set({
                                                      'cid': data['cid'],
                                                      'customername':
                                                          widget.name,
                                                      'email': data['email'],
                                                      'address': widget.address,
                                                      'phone': widget.phone,
                                                      'profileimage':
                                                          data['profileimage'],
                                                      'sid': item.suppId,
                                                      'proid': item.documentId,
                                                      'orderid': orderId,
                                                      'ordername': item.name,
                                                      'orderimage':
                                                          item.imagesUrl.first,
                                                      'orderqty': item.qty,
                                                      'orderprice':
                                                          item.qty * item.price,
                                                      'deliverystatus':
                                                          'preparing',
                                                      'deliverydate': '',
                                                      'orderdate':
                                                          DateTime.now(),
                                                      'paymentstatus':
                                                          'cash on delivery',
                                                      'orderreview': false,
                                                    }).whenComplete(
                                                            () async => {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .runTransaction(
                                                                          (transaction) async {
                                                                    DocumentReference documentReference = FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'products')
                                                                        .doc(item
                                                                            .documentId);
                                                                    DocumentSnapshot
                                                                        snapshot2 =
                                                                        await transaction
                                                                            .get(documentReference);
                                                                    transaction
                                                                        .update(
                                                                            documentReference,
                                                                            {
                                                                          'instock':
                                                                              snapshot2['instock'] - item.qty
                                                                        });
                                                                  })
                                                                });
                                                  }
                                                  context
                                                      .read<Cart>()
                                                      .clearCart();
                                                  Navigator.popUntil(
                                                      context,
                                                      ModalRoute.withName(
                                                          '/customer_home'));
                                                },
                                                width: 0.9)
                                          ],
                                        ),
                                      ),
                                    ));
                          } else if (selectedValue == 2) {
                            int payment = totalPaid.round();
                            int pay = payment * 100;

                            makePayment(data, pay.toString());
                          } else if (selectedValue == 3) {
                            print('Paypal');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Map<String, dynamic>? paymentIntentData;

  void makePayment(dynamic data, String total) async {
    // createPaymentIntnet
    //initPaymentSheet
    //displayPaymentSheet

    paymentIntentData = await createPaymentIntnet(total, 'USD');
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData!['client_secret'],
            merchantDisplayName: 'TO SALEASE'));

    await displayPaymentSheet(data);
  }

  displayPaymentSheet(var data) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              // parameters: PresentPaymentSheetParameters(
              //     clientSecret: paymentIntentData!['client_secret'],
              //     confirmPayment: true)
                  )
          .then((value) async {
        paymentIntentData = null;
        print('paid');

        showProgess();
        for (var item in context.read<Cart>().getItems) {
          CollectionReference orderRef =
              FirebaseFirestore.instance.collection('orders');
          orderId = const Uuid().v4();
          await orderRef.doc(orderId).set({
            'cid': data['cid'],
            'customername': data['name'],
            'email': data['email'],
            'address': data['address'],
            'phone': data['phone'],
            'profileimage': data['iprofileimage'],
            'sid': item.suppId,
            'proid': item.documentId,
            'orderid': orderId,
            'ordername': item.name,
            'orderimage': item.imagesUrl.first,
            'orderqty': item.qty,
            'orderprice': item.qty * item.price,
            'deliverystatus': 'preparing',
            'deliverydate': '',
            'orderdate': DateTime.now(),
            'paymentstatus': 'paid online',
            'orderreview': false,
          }).whenComplete(() async => {
                await FirebaseFirestore.instance
                    .runTransaction((transaction) async {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection('products')
                      .doc(item.documentId);
                  DocumentSnapshot snapshot2 =
                      await transaction.get(documentReference);
                  transaction.update(documentReference,
                      {'instock': snapshot2['instock'] - item.qty});
                })
              });
          context.read<Cart>().clearCart();
          Navigator.popUntil(context, ModalRoute.withName('/customer_home'));
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  createPaymentIntnet(String total, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': total,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      print(body);
      final responce = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $stripesecretKey',
            'content_type': "application/x-www-form-urlencoded"
          });
      return jsonDecode(responce.body);
    } catch (e) {
      print(e.toString());
    }
  }
}
