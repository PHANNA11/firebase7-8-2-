import 'package:firebase1/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class UpdateScreen extends StatefulWidget {
  UpdateScreen({super.key, required this.userModel});
  // Map<String, dynamic> user;
  UserModel userModel;
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
          Text('ID=${widget.userModel.id}'),
          Text('Name=${widget.userModel.name}'),
          Text('Age=${widget.userModel.age}'),
        ],
      ),
    );
  }
}
