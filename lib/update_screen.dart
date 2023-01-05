import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({super.key, required this.user});
  Map<String, dynamic> user;
  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text('ID=${widget.user['id'].toString()}'),
          Text('Name=${widget.user['name'].toString()}'),
          Text('Age=${widget.user['age'].toString()}'),
        ],
      ),
    );
  }
}
