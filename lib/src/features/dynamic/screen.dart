import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../ui/ui.dart';

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

        final screenData = snapshot.data?.screenData;
        final labs = screenData?.laboratories ?? [];

        return SingleChildScrollView(
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.dynamicScreenTitle),
              Text(AppLocalizations.of(context)!.dynamicScreenSubTitle),
              _Labs(data: labs),
            ],
          ),
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

class _Labs extends StatelessWidget {
  static const _dividerSide = BorderSide(color: YourHealthAppColors.lightGray);
  static const _padding = EdgeInsets.symmetric(horizontal: 3.0);

  final List<Laboratory> data;

  const _Labs({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: _padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalizations.of(context)!.dynamicScreenSubLabsDate),
              Text(AppLocalizations.of(context)!.dynamicScreenSubLabsMl),
            ],
          ),
        ),
        Container(
          height: 8.0,
          decoration: BoxDecoration(
            border: Border(bottom: _dividerSide),
          ),
        ),
        ...data.map(
          (lab) => _Lab(
            date: lab.date,
            title: lab.title,
            milliliters: lab.value,
          ),
        ),
      ],
    );
  }
}

class _Lab extends StatelessWidget {
  static const _dateFormat = DateFormat.MMMd;
  static const _criticalMlValue = 2.8;
  static const _padding = EdgeInsets.symmetric(horizontal: 3.0, vertical: 16.0);
  static const _emptySpaceL = SizedBox(width: 16.0);
  static const _borderSide = BorderSide(color: YourHealthAppColors.lightGray);

  final DateTime date;
  final String title;
  final double milliliters;

  const _Lab({required this.date, required this.title, required this.milliliters});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: _borderSide,
        ),
      ),
      child: Row(
        children: [
          Text(
            _dateFormat().format(date),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: YourHealthAppColors.black,
            ),
          ),
          _emptySpaceL,
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: YourHealthAppColors.lightGray,
              ),
            ),
          ),
          Text(
            milliliters.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: milliliters < _criticalMlValue
                  ? YourHealthAppColors.orangeAccent
                  : YourHealthAppColors.greenAccent,
            ),
          )
        ],
      ),
    );
  }
}
