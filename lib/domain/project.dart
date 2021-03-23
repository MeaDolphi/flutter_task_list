import '../data/models/project.dart';
import '../data/data.dart';

class ProjectDomain {
  static int getCountProjectsThisDay(DateTime thisDay) {
    int counterProjectsThisDay = 0;

    for (int i = 0; i < HiveProvider.getProjectLength(); i++) {
      if (HiveProvider.getProject(i).date == thisDay) {
        counterProjectsThisDay++;
      }
    }

    return counterProjectsThisDay;
  }

  static List<ProjectModel> getProjectsThisDay(DateTime thisDay) {
    List<ProjectModel> listProjectsThisDay = [];

    for (int i = 0; i < HiveProvider.getProjectLength(); i++) {
      ProjectModel project = HiveProvider.getProject(i);

      if (project.date == thisDay) {
        listProjectsThisDay.add(project);
      }
    }

    return listProjectsThisDay;
  }

  static void clearProjectsThisDay(DateTime thisDay) {
    for (int i = 0; i < HiveProvider.getProjectLength(); i++) {
      ProjectModel project = HiveProvider.getProject(i);

      if (project.date == thisDay) {
        HiveProvider.deleteProject(project.index);
      }
    }
  }
}