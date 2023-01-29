import 'package:circle_task/core/data/dependencies/dependency_init.config.dart';
import 'package:get_it/get_it.dart';
  import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;
@InjectableInit(
  usesNullSafety: true,
  initializerName: r'$initGetIt', // default
  asExtension: false, // default
  preferRelativeImports: false,
)
Future<GetIt> configureDependencies() async =>  $initGetIt(getIt);
 