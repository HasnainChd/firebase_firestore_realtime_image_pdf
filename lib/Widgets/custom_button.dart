import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final bool isLoading;

  const CustomButton({
    this.color,
    this.isLoading = false,
    required this.text,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  )),
      ),
    );
  }
}
