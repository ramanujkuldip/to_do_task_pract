import '../model/common_model.dart';
import 'enums.dart';

class StringRes {
  static const userPrefs = "User Prefs";
}

List<CommonModel> filerList = [
  CommonModel(
    title: "All",
    value: false,
    isShowByDate: true,
  ),
  CommonModel(
    title: "Show high priority",
    value: TaskPriority.high.name,
    isShowByDate: false,
  ),
  CommonModel(
    title: "Show medium priority",
    value: TaskPriority.medium.name,
    isShowByDate: false,
  ),
  CommonModel(
    title: "Show low priority",
    value: TaskPriority.low.name,
    isShowByDate: false,
  ),
  CommonModel(
    title: "Sort by Due date",
    value: true,
    isShowByDate: true,
  ),
];
