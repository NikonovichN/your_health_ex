import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../api/api.dart';
import '../../ui/ui.dart';

import 'repository.dart';
import 'controller.dart';

class DynamicScreen extends StatelessWidget {
  static const _pagePadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 32.0);

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
        final alerts = screenData?.alerts;
        final labs = screenData?.laboratories ?? [];

        return RefreshIndicator(
          onRefresh: dynamicController.loadData,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: _pagePadding,
            child: Column(
              children: [
                const _Title(),
                if (alerts != null && alerts.isNotEmpty)
                  ...alerts.map((alert) => _ResubmitMarkersLabel(
                        alert: alert,
                      )),
                _Labs(data: labs),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Error extends StatelessWidget {
  final String errorMessage;

  const _Error({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Text('${AppLocalizations.of(context)!.somethingWentWrong}$errorMessage');
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.dynamicScreenTitle,
              style: TextStyle(
                color: YourHealthAppColors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.dynamicScreenSubTitle,
              style: TextStyle(
                color: YourHealthAppColors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ResubmitMarkersLabel extends StatelessWidget {
  static const _margin = EdgeInsets.symmetric(vertical: 24.0);
  static const _padding = EdgeInsets.all(16.0);
  static const _emptySpace = SizedBox(height: 16.0);

  final Alert alert;

  const _ResubmitMarkersLabel({required this.alert});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _padding,
      margin: _margin,
      decoration: BoxDecoration(color: YourHealthAppColors.lightBlue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            alert.message,
            style: TextStyle(
              color: YourHealthAppColors.grey,
              fontSize: 18,
            ),
          ),
          if (alert.resubmitLink) ...[
            _emptySpace,
            TextButton(
              onPressed: () {},
              child: Text(
                AppLocalizations.of(context)!.dynamicScreenResubmitMarkersLink,
                style: TextStyle(
                  color: YourHealthAppColors.link,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Labs extends StatelessWidget {
  static const _dividerSide = BorderSide(color: YourHealthAppColors.lightGray);

  final List<Laboratory> data;

  const _Labs({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.dynamicScreenSubLabsDate),
            Text(AppLocalizations.of(context)!.dynamicScreenSubLabsMl),
          ],
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
