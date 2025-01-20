import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../api/api.dart';

import 'repository.dart';
import 'controller.dart';

class DynamicScreen extends StatelessWidget {
  const DynamicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicController = DynamicScreenControllerImpl(
      repository: DynamicRepositoryImpl(
        api: YourHealthAppApi(),
        client: YourHealthRemoteClient(),
      ),
    )..loadData();

    return StreamBuilder<DynamicScreenState>(
      stream: dynamicController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || (snapshot.data?.isLoading != null && snapshot.data!.isLoading)) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data?.error != null) {
          return _Error(errorMessage: '${snapshot.data!.error?.message}');
        }

        return Column(
          children: [
            Text(AppLocalizations.of(context)!.dynamicScreenTitle),
            Text(AppLocalizations.of(context)!.dynamicScreenSubTitle),
          ],
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  static const _errorPredefinedText = 'Something went wrong: ';

  final String errorMessage;

  const _Error({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text('$_errorPredefinedText$errorMessage');
  }
}
