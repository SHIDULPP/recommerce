import 'package:flutter/material.dart';

import '../widgets/appbar_widgets.dart';
// import '../widgets/appbar_widgets.dart';

class EditBusiness extends StatelessWidget {
  const EditBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Edit Business'),
        leading: const AppBarBackButton(),
      ),
    );
  }
}
