import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.loading = false});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.loading || widget.onPressed == null;
    return MouseRegion(
      onEnter: (_) => setState(() => _scale = 0.98),
      onExit: (_) => setState(() => _scale = 1.0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _scale = 0.96),
        onTapUp: (_) => setState(() => _scale = 0.98),
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 120),
          child: ElevatedButton(
            onPressed: disabled ? null : widget.onPressed,
            child: SizedBox(
              height: 22,
              child: Center(
                child: widget.loading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(widget.label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
