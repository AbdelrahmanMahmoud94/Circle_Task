import 'dart:convert';

import 'package:candlesticks/candlesticks.dart';
import 'package:circle_task/core/bloc/bloc/home_bloc.dart';
import 'package:circle_task/core/data/dependencies/dependency_init.dart';
import 'package:circle_task/core/data/enum/dashboard_filter.dart';
import 'package:circle_task/core/data/model/chart_item.dart';
import 'package:circle_task/ui/shared/widget/loading_animation_widget.dart';
import 'package:csv/csv.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interactive_chart/interactive_chart.dart';
import 'package:local_auth/local_auth.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../../../core/helper/date_time_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeBloc _homeBloc = getIt<HomeBloc>();
  List<DropdownMenuItem<String>>? dashBoardFilterItems;
  late String selectedValue;
  late DashboardFilter selectedFilter;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      dashBoardFilterItems = DashboardFilter.values
          .map(
            (DashboardFilter item) => DropdownMenuItem<String>(
              value: item.value!,
              child: Text(
                item.value!,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList();
    });
    selectedValue = DashboardFilter.customRange.value!;
    selectedFilter = DashboardFilter.customRange;
    selectedStartDate = DateTime(2022, 10, 4);
    selectedEndDate = DateTime(2022, 12, 4);
    _authenticateWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: !authenticated
              ? Center(
                  child: ElevatedButton(
                    onPressed: _authenticateWithBiometrics,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Scan Your Finger Print"),
                        const Icon(Icons.fingerprint),
                      ],
                    ),
                  ),
                )
              : BlocProvider<HomeBloc>(
                  create: (_) => _homeBloc,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (BuildContext context, HomeState currentState) {
                      if (currentState is HomeInitialState) {
                        return _initialState(context, currentState);
                      }
                      if (currentState is HomeReadyState) {
                        return _readyState(context, currentState);
                      }
                      if (currentState is HomeLoadingState) {
                        return _loadingState(context, currentState);
                      }
                      if (currentState is HomeErrorState) {
                        return _errorState(context, currentState);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
        ));
  }

  Widget _initialState(
    BuildContext context,
    HomeState currentState,
  ) {
    return Container();
  }

  Widget _loadingState(
    BuildContext context,
    HomeState currentState,
  ) {
    return LoadingAnimationWidget();
  }

  Widget _readyState(
    BuildContext context,
    HomeReadyState currentState,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFilter(),
          SizedBox(
            height: 10.h,
          ),
          currentState.chartList!.length < 3 ? _buildTable(currentState.chartList!) : _buildChart(currentState),
          Image.asset("assets/images/circlez_logo.png")
        ],
      ),
    );
  }

  SizedBox _buildChart(HomeReadyState currentState) {
    return SizedBox(
      height: 500.h,
      child: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 25.w,
          vertical: 15.h,
        ),
        child: InteractiveChart(
            candles: currentState.chartList!
                .map((ChartItem e) => CandleData(
                      timestamp: e.date!.millisecondsSinceEpoch,
                      high: e.high!,
                      low: e.low!,
                      open: e.open!,
                      close: e.close!,
                      volume: e.volume!.toDouble(),
                    ))
                .toList(),
            style: ChartStyle(
              priceGainColor: Colors.teal[200]!, priceLossColor: Colors.blueGrey, volumeColor: Colors.teal.withOpacity(0.8),
              priceGridLineColor: Colors.blue[200]!,
              priceLabelStyle: TextStyle(color: Colors.blue[200]),
              timeLabelStyle: TextStyle(color: Colors.blue[200]),
              selectionHighlightColor: Colors.blueAccent.withOpacity(0.2),
              overlayBackgroundColor: Colors.blueAccent.withOpacity(0.6),
              overlayTextStyle: TextStyle(color: Colors.white),
              timeLabelHeight: 32,
              priceLabelWidth: 20,
              volumeHeightFactor: 0.3, // volume area is 20% of total height
            ),
            timeLabel: (timestamp, visibleDataCount) =>
                DateTimeHelper.formatDateTime(DateTime.fromMillisecondsSinceEpoch(timestamp), format: "y-M-d")),
      )),
    );
  }

  Widget _errorState(
    BuildContext context,
    HomeState currentState,
  ) {
    return LoadingAnimationWidget();
  }

  Future<void> showDatePicker() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      type: OmniDateTimePickerType.date,
      primaryColor: Colors.blueAccent,
      backgroundColor: Colors.white,
      calendarTextColor: Colors.blueAccent,
      tabTextColor: Colors.blueAccent,
      unselectedTabBackgroundColor: Colors.grey,
      buttonTextColor: Colors.blueAccent,
      timeSpinnerTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 18),
      timeSpinnerHighlightedTextStyle: const TextStyle(color: Colors.blueAccent, fontSize: 24),
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      borderRadius: const Radius.circular(16),
    );
    setState(() {
      selectedStartDate = dateTimeList!.first;
      selectedEndDate = dateTimeList.last;
    });
    _load();
    _changeDateFilterValue();
  }

  Widget _buildFilter() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              buttonDecoration: BoxDecoration(
                border: Border.all(color: Color(0xFFD8DDE6)),
                color: Colors.white,
              ),
              icon: FaIcon(
                FontAwesomeIcons.angleDown,
                size: 15.w,
                color: Colors.blueAccent,
              ),

              style: TextStyle(color: Colors.black),
              alignment: AlignmentDirectional.center,
              //itemPadding: EdgeInsets.symmetric(horizontal: 20),
              buttonPadding: EdgeInsets.symmetric(horizontal: 12.w),
              items: dashBoardFilterItems,
              value: selectedValue,

              onChanged: (String? value) {
                setState(() {
                  selectedValue = value!;
                  if (selectedValue.contains("Custom")) {
                    showDatePicker();
                  } else {
                    selectedStartDate = null;
                    selectedEndDate = null;
                    selectedFilter = DashboardFilter.values.where((element) => element.value == selectedValue).first;

                    _load();
                    _changeDateFilterValue();
                  }
                });
              },

              buttonHeight: 30.w,
              buttonWidth: MediaQuery.of(context).size.width * 0.35,
              itemHeight: 30.w,
              selectedItemHighlightColor: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  _buildTable(List<ChartItem> list) {
    return SizedBox(
      height: 400.h,
      child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 600,
          columns: [
            DataColumn2(
              label: Text('Date'),
              size: ColumnSize.L,
            ),
            DataColumn(
              label: Text('Open'),
            ),
            DataColumn(
              label: Text('High'),
            ),
            DataColumn(
              label: Text('Low'),
            ),
            DataColumn(
              label: Text('Close'),
            ),
            DataColumn(
              label: Text('Adj  Close'),
            ),
            DataColumn(
              label: Text('Volume'),
            ),
          ],
          rows: list
              .map((e) => DataRow(cells: [
                    DataCell(Text(DateTimeHelper.formatDateTime(e.date!, format: "y / M/ d"))),
                    DataCell(Text(e.open.toString())),
                    DataCell(Text(e.high.toString())),
                    DataCell(Text(e.low.toString())),
                    DataCell(Text(e.close.toString())),
                    DataCell(Text(e.adjClose.toString())),
                    DataCell(Text(e.volume.toString())),
                  ]))
              .toList()),
    );
  }

  void _changeDateFilterValue() {
    setState(() {
      dashBoardFilterItems!.clear();
      dashBoardFilterItems = DashboardFilter.values
          .map(
            (DashboardFilter item) => DropdownMenuItem<String>(
              value: item.value!,
              child: Text(
                item.value!,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList();
    });
  }

  void _load() {
    _homeBloc.add(HomeLoadEvent(
      filter: selectedFilter,
      startDate: selectedStartDate,
      endDate: selectedEndDate,
    ));
  }

  Future<void> _authenticateWithBiometrics() async {
    authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        _load();
      } else {
        authenticated = false;
      }
      setState(() {});
    } on PlatformException catch (e) {
      print(e);

      return;
    }
    if (!mounted) {
      return;
    }
  }
}
