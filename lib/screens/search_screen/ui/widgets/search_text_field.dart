import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({super.key, required TextEditingController controller})
      : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(
        fillColor: Colors.black12,
        prefixIcon: Icon(Icons.search, color: Colors.blue),
        hintText: 'Search',
        contentPadding: EdgeInsets.all(5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }
}
