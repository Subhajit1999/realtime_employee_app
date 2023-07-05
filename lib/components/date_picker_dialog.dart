import 'package:flutter/material.dart';
import 'package:realtime_employee_app/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePickerDialog extends StatefulWidget {
  DateTime? selectedDate;
  final bool isStartDate;
  final Function onSelected;
  CustomDatePickerDialog(
      {this.isStartDate = true,
      this.selectedDate,
      required this.onSelected,
      super.key});

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  bool _isToday = false,
      _isMonday = false,
      _isTuesday = false,
      _isNextWeek = false;
  DateRangePickerController _controller = DateRangePickerController();

  @override
  void initState() {
    super.initState();
    if(widget.selectedDate != null) {
      _isToday =
        widget.selectedDate!.difference(DateTime.now()).abs().inHours < 24 &&
            widget.selectedDate!.day == DateTime.now().day;
    }
    if (widget.isStartDate) {
      _isMonday = widget.selectedDate!.isAfter(DateTime.now()) &&
          widget.selectedDate!.weekday == DateTime.monday;
      _isTuesday = widget.selectedDate!.isAfter(DateTime.now()) &&
          widget.selectedDate!.weekday == DateTime.tuesday;
      _isNextWeek = widget.selectedDate!.isAfter(DateTime.now()) &&
          widget.selectedDate!.difference(DateTime.now()).abs().inDays >= 6;
    }
  }

  void _onClickButtons(String btnId) {
    switch (btnId) {
      case 'today':
        _isToday = true;
        _isMonday = false;
        _isTuesday = false;
        _isNextWeek = false;
        widget.selectedDate = DateTime.now();
        widget.onSelected(widget.selectedDate);
        break;
      case 'monday':
        _isToday = false;
        _isMonday = true;
        _isTuesday = false;
        _isNextWeek = false;
        widget.selectedDate = DateTime.now().add(Duration(
            days: ((DateTime.daysPerWeek - DateTime.now().weekday) + 1)));
        widget.onSelected(widget.selectedDate);
        break;
      case 'tuesday':
        _isToday = false;
        _isMonday = false;
        _isTuesday = true;
        _isNextWeek = false;
        widget.selectedDate = DateTime.now().add(Duration(
            days: ((DateTime.daysPerWeek - DateTime.now().weekday) + 2)));
        widget.onSelected(widget.selectedDate);
        break;
      case 'next':
        _isToday = false;
        _isMonday = false;
        _isTuesday = false;
        _isNextWeek = true;
        widget.selectedDate = DateTime.now().add(const Duration(days: 7));
        widget.onSelected(widget.selectedDate);
        break;
      case 'no_day':
        _isToday = false;
        _isMonday = false;
        _isTuesday = false;
        _isNextWeek = false;
        widget.onSelected(null);
        break;
    }
    _controller.selectedDate = widget.selectedDate;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(_isNextWeek);

    return AlertDialog(
      contentPadding: EdgeInsets.all(5),
      content: Container(
        // height: screenSize(context).height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isStartDate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('today'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_isToday
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    color: !_isToday
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('monday'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_isMonday
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Next Monday',
                                style: TextStyle(
                                    color: !_isMonday
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                  ],
                ),
              ),
            if (widget.isStartDate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('tuesday'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_isTuesday
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Next TuesDay',
                                style: TextStyle(
                                    color: !_isTuesday
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('next'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_isNextWeek
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Next Week',
                                style: TextStyle(
                                    color: !_isNextWeek
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                  ],
                ),
              ),
            if (!widget.isStartDate)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('no_day'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: widget.selectedDate != null
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'No Day',
                                style: TextStyle(
                                    color: widget.selectedDate != null
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _onClickButtons('today'),
                          child: Container(
                              alignment: Alignment.center,
                              // width: screenSize(context).width / 2,
                              height: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: !_isToday
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context).colorScheme.primary,
                              ),
                              child: Text(
                                'Today',
                                style: TextStyle(
                                    color: !_isToday
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ))),
                    ),
                  ],
                ),
              ),
            SfDateRangePicker(
              controller: _controller,
              onSelectionChanged: (args) => widget.onSelected(args.value),
              // enablePastDates: true,
              rangeSelectionColor: Theme.of(context).colorScheme.primary,
              selectionMode: DateRangePickerSelectionMode.single,
              selectionTextStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
                  showNavigationArrow: true,
              selectionColor: Theme.of(context).colorScheme.primary,
              initialSelectedDate: widget.selectedDate,
            ),
          ],
        ),
      ),
    );
  }
}
