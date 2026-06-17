import 'package:flutter/material.dart';

import '../../services/storage_service.dart';
import '../../theme/app_theme.dart';

/// Local-storage inspector.
///
/// Displays the raw key/value pairs currently persisted in
/// [SharedPreferences]. This screen is the evidence that app data (the user
/// account, habits and settings) is actually saved in local storage and
/// survives restarts.
class StorageDebugScreen extends StatelessWidget {
  const StorageDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = StorageService.instance.debugSnapshot();
    final entries = snapshot.entries.toList();

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Local Storage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.storage, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Data persisted on this device via SharedPreferences. '
                    'This data survives app restarts.',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (entries.isEmpty)
            const Text('Local storage is empty.')
          else
            ...entries.map(
              (e) => Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${e.value}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
