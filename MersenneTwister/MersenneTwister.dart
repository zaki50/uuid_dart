/*
  This program is written by Makoto Yamazaki<makto1975@gmail.com>
  
  This code is an simple translate to Dart.
  Original Code is http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/MT2002/CODES/mt19937ar.c
  and http://homepage2.nifty.com/mathpara/programing/MersenneTwister.htm
  
  ↓ is the original copyright notice.
  
   A C-program for MT19937, with initialization improved 2002/1/26.
   Coded by Takuji Nishimura and Makoto Matsumoto.

   Before using, initialize the state by using init_genrand(seed)  
   or init_by_array(init_key, key_length).

   Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
   All rights reserved.                          

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions
   are met:

     1. Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.

     2. Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in the
        documentation and/or other materials provided with the distribution.

     3. The names of its contributors may not be used to endorse or promote 
        products derived from this software without specific prior written 
        permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
   A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


   Any feedback is very welcome.
   http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html
   email: m-mat @ math.sci.hiroshima-u.ac.jp (remove space)
*/

#library('MersenneTwister');

interface Random default RandomIntGenerator {
  Random(int seed);
  
  int nextBits(var bits);
}

class RandomIntGenerator {
   static final int _N = 624;
   static final int _M = 397;
   
   List<int> _mt;
   int _mtIndex = _N + 1;
   
   RandomIntGenerator(int seed) : _mt = new List(_N) {
     init(seed);
   }
  
   factory Random(int seed){
     return new RandomIntGenerator(seed);
   }
  
   int nextBits(int bits) {
     if (bits < 0) {
       return 0;
     }

     int n = ((bits + 31) / 32).toInt();
     int result = 0;
     
     for (int i=0; i < n; i++) {
       result <<= 32;
       result += nextInt();
       if (i ==0) {
         final r = bits % 32;
         if (r != 0) {
           result &= ((1<<r) - 1);
         }
       }
     }
     return result;
   }
   
   
  int nextInt() {
      int v = generateInt();
      
      // 精度を上げる為の調律
      v = temper(v);
      
      return v;
  }

  void init(int seed) {
      
      List<int> longMt = createLongMt(seed);
      
      setMt(longMt);
  }

  int generateInt() {
      twist();
      
      int ret = _mt[_mtIndex];
      _mtIndex++;
      
      return ret;
  }
  
  void twist() {
      final List<int> BIT_MATRIX = [0x0, 0x9908b0df];
      final int UPPER_MASK = 0x80000000;
      final int LOWER_MASK = 0x7fffffff;
      
      if (_mtIndex < _N) {
          return;
      }
      
      if(_mtIndex > _N) {
          init(5489);
      }
      
      for (int i = 0; i < _N; i++) {
          int x = (_mt[i] & UPPER_MASK) | (_mt[(i + 1) % _N] & LOWER_MASK);
          _mt[i] = _mt[(i + _M) % _N] ^ (x >> 1) ^ BIT_MATRIX[x & 0x1];
      }
      
      _mtIndex = 0;
  }

 static int temper(int num) {
      
      num ^= (num >> 11);
      num ^= (num << 7) & 0x9d2c5680;
      num ^= (num << 15) & 0xefc60000;
      num ^= (num >> 18);
      
      return num;
  }
 
  static int toInt(int /*long*/ num) {
      return num & 0xffffffff;
  }
  
  static List<int>/*long[]*/ createLongMt(int seed) {
      List<int> longMt = new List(_N);
      
      longMt[0] = seed & 0xffffffff;
      
      for (int i = 1; i < _N; i++) {
          longMt[i] = longMt[i - 1];
          
          longMt[i] >>= 30;
          longMt[i] ^= longMt[i - 1];
          longMt[i] *= 0x6C078965;
          longMt[i] += i;
          longMt[i] &= 0xffffffff;
      }
      
      return longMt;
  }
  
  void setMt(List<int>/*long[]*/ longMt) {
      for (int i = 0; i < _N; i++) {
          _mt[i] = toInt(longMt[i]);
      }
   
      _mtIndex = _N;
  }

}
