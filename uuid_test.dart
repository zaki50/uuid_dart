#import('./teaolive/teaolive.dart');
#import('./teaolive/teaolive_html_reporter.dart');
#import('./uuid/uuid.dart');

void main(){
  RegExp uuidPattern = new RegExp('^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\$');
  
  describe("test pattern sanity", () {
    it("matches UUID syntax", () {
      expect(uuidPattern.hasMatch('f81d4fae-7dec-11d0-a765-00a0c91e6bf6')).toBe(true);
    });
  });
  
  describe("UUID test", () {

    it("suits UUID syntax", () {
      UUID uuid = new UUID_v0();
      expect(uuidPattern.hasMatch(uuid.generate())).toBe(true);
    });

    it("v1 suits UUID syntax", () {
      UUID uuid = new UUID_v1();
      expect(uuidPattern.hasMatch(uuid.generate())).toBe(true);
    });

    it("v4 suits UUID syntax", () {
      UUID uuid = new UUID_v4();
      expect(uuidPattern.hasMatch(uuid.generate())).toBe(true);
    });

    it("suits UUID syntax", () {
      UUID uuid = new UUID();
      expect(uuidPattern.hasMatch(uuid.generate())).toBe(true);
    });
  });
  
  describe("sample fail.", (){
    it("success", (){
      expect(1).toBe(1);
    });
    
    it("failure...", (){
      expect(1).toBe(2);
    });
  });

  setTeaoliveReporter(new TeaoliveHtmlReporter());
  teaoliveRun();
}
