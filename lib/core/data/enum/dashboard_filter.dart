enum DashboardFilter {
  day,
  week,
  month,
  customRange,
}

extension DashboardFilterHelper on DashboardFilter? {
  String? get value {
    switch (this) {
      case DashboardFilter.day:
        return "1d";
      case DashboardFilter.week:
        return "1wk";
      case DashboardFilter.month:
        return "1mo";
      case DashboardFilter.customRange:
        return "Custom Range";
      default:
        return null;
    }
  }
  String? get localKey {
    switch (this) {
      case DashboardFilter.day:
        return "Past Day";
      case DashboardFilter.week:
        return "Past Week";
      case DashboardFilter.month:
        return "Past Month";
      case DashboardFilter.customRange:
        return "Custom Range";
      default:
        return null;
    }
  }
}
