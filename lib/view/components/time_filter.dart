import 'package:flutter/material.dart';
import 'package:productive_u/view/theme.dart';

class TimeFilter extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final EdgeInsetsGeometry? padding;

  const TimeFilter({
    super.key,
    required this.selectedValue,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: selectedValue,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            dropdownColor: AppTheme.lighbackground,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            onChanged: onChanged,
            items: const [
              DropdownMenuItem(
                value: 'All',
                child: Text('All Time'),
              ),
              DropdownMenuItem(
                value: 'Today',
                child: Text('Today'),
              ),
              DropdownMenuItem(
                value: 'Weekly',
                child: Text('Weekly'),
              ),
              DropdownMenuItem(
                value: 'Monthly',
                child: Text('Monthly'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
