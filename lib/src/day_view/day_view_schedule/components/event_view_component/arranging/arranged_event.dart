import 'package:meta/meta.dart';

import 'package:calendar_views/day_view.dart';

/// Item returned by [EventViewArranger].
///
/// It contains an [event] its position ([top], [left]) and size ([width], [height]).
@immutable
class ArrangedEvent {
  ArrangedEvent({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
    required this.event,
  });

  final double top;

  final double left;

  final double width;

  final double height;

  final StartDurationItem event;
}
