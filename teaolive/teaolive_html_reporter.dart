#library('teaolive_html_reporter');

#import('./teaolive.dart');

class TeaoliceHtmlReporter implements TeaoliveReporter {
  
  TeaoliveReporter(){}
  
  void onRunnerStart(){
    print("test is started...");
  }
  
  void onSuiteResult(TeaoliveSuite suite){}

  void onSpecResult(TeaoliveSpec spec){}

  void onRunnerResult(TeaoliveRunner runner){
    for(TeaoliveSuite suite in runner.suites){
      if(suite.result){
        print("describe ${suite.description} is success!");
      } else {
        print("describe ${suite.description} is failure...");
        
        for(TeaoliveSpec spec in suite.specs){
          if(spec.result){
            print("  it ${spec.description} is success!");
          } else {
            print("  it ${spec.description} is failure...");
            if(spec.errorMessage != null){
              print("    ${spec.errorMessage}");
            } else {
              print("    unknown error ${spec.error}");
            }
          }
        }
      }
    }
  }
}
