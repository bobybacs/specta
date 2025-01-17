#import "TestHelper.h"

@interface TestSuitable : NSObject
- (XCTestRun *)run;
@end

XCTestRun *RunSpecClass(Class testClass) {
  __block XCTestRun *result;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000 || __MAC_OS_X_VERSION_MAX_ALLOWED >= 101100
  XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedTestObservationCenter];
#else
  XCTestObservationCenter *observationCenter = [XCTestObservationCenter sharedObservationCenter];
#endif
  [observationCenter _suspendObservationForBlock:^{
      id suite = [XCTestSuite testSuiteForTestCaseClass:testClass];
      
      if ([suite respondsToSelector:@selector(runTest)]) {
          [suite runTest];
          result = [suite testRun];
      }
      else if ([suite respondsToSelector:@selector(run)]) {
          result = [(TestSuitable *)suite run];
      }
  }];

  return result;
}
