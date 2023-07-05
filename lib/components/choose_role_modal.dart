import 'package:flutter/material.dart';

class ChooseRoleModal extends StatefulWidget {
  const ChooseRoleModal({super.key});

  @override
  State<ChooseRoleModal> createState() => _ChooseRoleModalState();
}

class _ChooseRoleModalState extends State<ChooseRoleModal> {
  final List<String> _rolesList = ['Product Designer', 'Flutter Developer', 'QA Tester', 'Product Owner'];

  Widget _option(String role) => InkWell(
    onTap: () => Navigator.pop(context, role),
    child: Column(
      children: [
        Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(role, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center,),
            ),
            const Divider(height: 1, thickness: 0.5,)
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _rolesList.map((e) => _option(e)).toList(),
    );
  }
}
