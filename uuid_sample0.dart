#import('./uuid/uuid.dart');

void main() {
  UUID_v4 uuid4 = new UUID_v4();
  for (int i=0 ; i<50; i++) {
    print(uuid4.generate());
  }
}
