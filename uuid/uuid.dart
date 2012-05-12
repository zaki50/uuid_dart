#library('uuid');
#import('../MersenneTwister/MersenneTwister.dart');

interface UUID  default UUID_v4 {
  UUID();
  String generate();
}

String hex(int num, int length) {
  String str = num.toRadixString(16);
  String z = "0";
  for (int i = length - str.length; i>0 ;) {
    if ((i & 1)==1) {
      str = z + str;
    }
    i >>= 1;
    z += z;
  }
  return str;
}
int hexRandom(var x) {
  if (x <= 30) return (0 | (Math.random() * (1 << x)).toInt());
  if (x <= 53) return (0 | (Math.random() * (1 << 30)).toInt())
                    + (0 | (Math.random() * (1 << x - 30)).toInt()) * (1 << 30);
  return 0;
}

class State {
  int timestamp = 0;
  var sequence;
  var node;
  var tick;
  State() {
    sequence = hexRandom(14);
    // set multicast bit '1'
    node = (hexRandom(8) | 1) * 0x10000000000 + hexRandom(40);
    tick = hexRandom(4);
  }
}
class UUID_v1 implements UUID {
  var _tsRatio = 1 / 4;
  var _state;
  var _timeZone;
  var _baseDate;
  UUID_v1() {
    _state = new State();
    _timeZone = new TimeZone.utc();
    _baseDate = new Date.withTimeZone(1970, Date.JAN, 1, 0, 0, 0, 0, _timeZone);
  }
  String generate() {
    int now = new Date.now().value;
    var st = _state;
    if (now != st.timestamp) {
      if (now < st.timestamp) {
        st.sequence++;
      }
      st.timestamp = now;
      st.tick = hexRandom(4);
    } else if (Math.random() < _tsRatio && st.tick < 9984) {
      // advance the timestamp fraction at a probability
      // to compensate for the low timestamp resolution
      st.tick += 1 + hexRandom(4);
    } else {
      st.sequence++;
    }
    // format time fields
    getTimeFieldValues(st.timestamp);
    var tl = low + st.tick;
    var thav = (hi & 0xFFF) | 0x1000; // set version '0001'

    // format clock sequence
    st.sequence &= 0x3FFF;
    var cshar = (st.sequence >> 8) | 0x80; // set variant '10'
    var csl = st.sequence & 0xFF;

    return hex(tl, 8) // time_low
      + "-"
      + hex(mid, 4) // time_mid
      + "-"
      + hex(thav, 4) // time_hi_and_version
      + "-"
      + hex(cshar, 2)
      + hex(csl, 2) // clock_seq_hi_and_reserved + clock_seq_low
      + "-"
      + hex(_state.node, 12); // node    
  }
  int ts1582_10_15 = 12219292800; //141427;
  void getTimeFieldValues(int time) {
    int ts = time - _baseDate.value + ts1582_10_15;
    var hm = ((ts / 0x100000000) * 10000).toInt() & 0xFFFFFFF;
    low = ((ts & 0xFFFFFFF) * 10000) % 0x100000000;
    mid = hm & 0xFFFF;
    hi = hm >> 16;
    _state.timestamp = ts;
  }
  var low;
  var mid;
  var hi;
}


class UUID_v4 implements UUID {
  factory UUID(){
    return new UUID_v4();
  }

  UUID_v4() {}
  String generate() {
    return hex(hexRandom(32), 8) // time_low
    + "-"
    + hex(hexRandom(16), 4) // time_mid
    + "-"
    + hex(0x4000 | hexRandom(12), 4) // time_hi_and_version
    + "-"
    + hex(0x8000 | hexRandom(14), 4) // clock_seq_hi_and_reserved + clock_seq_low
    + "-"
    + hex(hexRandom(48), 12); // node
  }  
}
class UUID_v0 implements UUID {
  UUID_v0() {}
  String generate() {
    return time_low()
        + "-"
        + time_mid()
        + "-"
        + time_high_and_version()
        + "-"
        + clock_seq_and_reserved()
        + clock_seq_low()
        + "-"
        + node();
  }
  String hexOctets(int length) {
    StringBuffer sb = new StringBuffer();
    for (int i=0; i<length ; i++) {
      sb.add(hexOctet());
    }
    return sb.toString();
  }
  String hexOctet() {
    return hexDigit() + hexDigit();
  }
  String hexDigit() {
    var value = (Math.random() * 16).floor();
    return value.toRadixString(16);
  }
  String time_low() {
    return hexOctets(4);
  }
  String time_mid() {
    return hexOctets(2);
  }
  String time_high_and_version() {
    return hexOctets(2);
  }
  String clock_seq_and_reserved() {
    return hexOctet();
  }
  String clock_seq_low() {
    return hexOctet();
  }
  String node() {
    return hexOctets(6);
  }
}
/*
void main() {
  for (int i=0 ; i<10; i++) {
    print(Math.random());
  }
  UUID uuid = new UUID_v0();
  print(uuid.generate());
  UUID_v4 uuid4 = new UUID_v4();
  print(uuid4.generate());
  UUID uuid1 = new UUID_v1();
  print(uuid1.generate());
  UUID uuid0 = new UUID();
  print(uuid0.generate());
}
*/