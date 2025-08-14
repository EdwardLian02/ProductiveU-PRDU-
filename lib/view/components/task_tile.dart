import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final String taskName;
  final DateTime endDate;
  final String priority; // 'High', 'Medium', 'Low'
  final String status; // 'Todo', 'In-Progress', 'Done'
  final ValueChanged<String?>? onStatusChanged;

  const TaskTile({
    super.key,
    required this.taskName,
    required this.endDate,
    required this.priority,
    required this.status,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildPriorityIndicator(),
        title: Text(
          taskName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Due: ${DateFormat('MMM dd, y').format(endDate)}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: _buildStatusDropdown(),
      ),
    );
  }

  Widget _buildPriorityIndicator() {
    Color priorityColor;
    switch (priority) {
      case 'Urgent':
        priorityColor = Colors.red;
        break;
      case 'High':
        priorityColor = Colors.pink;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      case 'Low':
        priorityColor = Colors.green;
        break;
      default:
        priorityColor = Colors.grey;
    }

    return Container(
      width: 8,
      height: 40,
      decoration: BoxDecoration(
        color: priorityColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    const statusOptions = ['Todo', 'In-Progress', 'Done'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _getStatusColor(status).withOpacity(0.2),
        border: Border.all(
          color: _getStatusColor(status),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: status,
          icon: Icon(Icons.arrow_drop_down, color: _getStatusColor(status)),
          iconSize: 20,
          elevation: 0,
          style: TextStyle(
            color: _getStatusColor(status),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: statusOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onStatusChanged,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Todo':
        return Colors.orange;
      case 'In-Progress':
        return Colors.blue;
      case 'Done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
