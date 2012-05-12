#import('./uuid/uuid.dart');

void main() {
/*
  UUID uuid = new UUID_v0();
  print(uuid.generate());
*/
  UUID_v4 uuid4 = new UUID_v4();
/*
  print(uuid4.generate());
  UUID uuid1 = new UUID_v1();
  print(uuid1.generate());
  UUID uuid0 = new UUID();
  print(uuid0.generate());
  for (int i=0 ; i<50; i++) {
    print(uuid4.generate());
  }
  print("-----------------------------");
*/
  UUID uuid4mt = new UUID_v4mt();
  for (int i=0 ; i<50; i++) {
    print(uuid4mt.generate());
  }
}
