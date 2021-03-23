import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'presentation/widgets/updater.dart';
import 'presentation/screens/home.dart';

UpdaterProvider provider = UpdaterProvider();

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UpdaterProvider>(
      create: (_) {
        return provider;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      )
    );
  }
}