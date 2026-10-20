// 실행: dart run lib/grammar/mixin/when_to_use_mixin.dart

/*
  상황: 오리는 "새"다. 그런데 물고기처럼 "헤엄"도 친다.
       헤엄치는 코드는 물고기에 이미 있다. 이걸 오리도 쓰고 싶다.

  시도 1) class Duck extends Bird, Fish
         → ❌ Dart는 부모를 1개만 가질 수 있다.

  시도 2) swim() 을 Animal(최상위 부모)에 넣는다
         → ❌ 고양이, 독수리까지 헤엄을 치게 된다.

  시도 3) Duck 안에 swim() 을 복사해서 붙여넣는다
         → ❌ 헤엄 코드를 고칠 때 Fish, Duck 두 군데를 다 고쳐야 한다. 펭귄이 추가되면 세 군데.

  시도 4) implements 사용
         → ❌ implements 는 "swim() 이 있어야 한다"는 약속만 가져온다.
              결국 swim() 몸통은 각 클래스에서 다시 써야 한다 = 시도 3과 똑같다.

  해결) swim() 코드를 mixin 으로 떼어내서, 필요한 클래스에 with 로 붙인다.
       → 코드는 한 곳에만, 붙이는 건 몇 개든 자유.
 */

class Animal {
  final String name;
  Animal(this.name);
}

class Bird extends Animal {
  Bird(super.name);
  void layEgg() => print('$name: 알을 낳는다');
}

class Fish extends Animal {
  Fish(super.name);
}

// ── "기능" 을 떼어낸 것 = mixin ──
mixin Swimmer {
  void swim() => print('$runtimeType: 헤엄친다');
}

mixin Flyer {
  void fly() => print('$runtimeType: 난다');
}

// ── 필요한 곳에만 with 로 붙인다 ──
class Duck extends Bird with Swimmer, Flyer {   // 새 + 헤엄 + 날기
  Duck() : super('오리');
}

class Penguin extends Bird with Swimmer {       // 새 + 헤엄 (못 난다)
  Penguin() : super('펭귄');
}

class Eagle extends Bird with Flyer {           // 새 + 날기 (헤엄 못 침)
  Eagle() : super('독수리');
}

class Salmon extends Fish with Swimmer {        // 물고기 + 헤엄
  Salmon() : super('연어');
}

class Airplane with Flyer {}                    // 동물도 아닌데 날기 기능만 빌려 씀

void main() {
  Duck()
    ..layEgg()
    ..swim()
    ..fly();
  Penguin().swim();
  Eagle().fly();
  Salmon().swim();
  Airplane().fly();
  // Eagle().swim();  ❌ 컴파일 에러: 독수리에는 Swimmer 를 안 붙였으니까
}
