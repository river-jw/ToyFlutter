// 실행: dart run lib/grammar/class_basics/practice.dart

/*
  ================================================================
   문제: 클래스 기초 다지기 (mixin 없음!)
  ================================================================

  이번 문제의 목표
   1) 생성자로 받은 값을 "필드에 저장" 하고 쓰기       (this)
   2) 자식이 부모 생성자에 값 "넘겨주기"               (super)
   3) 클래스 몸통에 쓸 수 있는 것 / 없는 것 구분         (선언 vs 실행)
   4) 구현을 "부모에 둘지, 자식에 둘지" 정하기            (abstract)
   5) 에러 메시지를 읽고 무슨 뜻인지 말하기

  규칙
   - 문제 1~4 는 TODO 자리에 코드를 작성하세요.
   - 문제 3, 5 는 코드가 아니라 "주석으로 답" 을 적는 문제입니다.
   - 막히면 IDE 빨간 줄 / `dart analyze` 메시지부터 읽어보세요.
 */


// ================================================================
// [문제 1] 필드와 생성자 (this)
// ================================================================
//  Product 클래스를 만드세요.
//   - name(상품명), price(가격) 는 "반드시" 받아야 한다.
//   - stock(재고) 는 안 넘기면 0 이다.   (힌트: 이름 있는 매개변수 { } + 기본값)
//   - describe() 는 아래 형식으로 출력한다.
//       상품: 키보드 / 가격: 50000원 / 재고: 0개
//   - 문자열 안에서 변수는 어떻게 쓰는지 기억나나요?
// ----------------------------------------------------------------
// TODO: class Product
/*  [내가 작성한 것]
class Product {
 String name;
 int price;
 int stock;

  Product({required String name , required int price} , {int stock=0}) {
    this.name = name;
    this.price = price;
    this.stock = stock;
  }

  void describe() {
    print("상품 : $name / 가격 : $price / 재고 : $stock");
  }
}
*/

// [틀린 부분]
//  1) { } 가 두 개 → 이름 있는 매개변수 { } 는 하나만, 맨 뒤에만 올 수 있다.
//     main 이 Product("키보드", 50000) 처럼 순서대로 넘기니까 name, price 는 { } 밖으로.
//  2) 생성자 몸통 { } 안에서 필드 채우기 (Java 방식)
//     → Dart 는 null 이 될 수 없는 필드를 "몸통이 실행되기 전에" 채워야 한다.
//     → 매개변수 자리에 this.name 이라고 쓰면, 받는 순간 바로 필드에 저장된다.
//  3) 출력 형식: "상품 : " → "상품: ",  가격 뒤 "원", 재고 뒤 "개" 빠짐
class Product {
  String name;
  int price;
  int stock;

  Product(this.name, this.price, {this.stock = 0});

  void describe() {
    print("상품: $name / 가격: $price원 / 재고: $stock개");
  }
}


// ================================================================
// [문제 2] 상속과 super
// ================================================================
//  DiscountProduct 는 Product "이다". (할인 상품도 상품)
//   - name, price 는 Product 와 똑같이 받고, 추가로 discountRate(할인율 %) 를 받는다.
//   - name, price 는 DiscountProduct 가 직접 저장하지 말고 "부모에게 넘겨서" 저장하게 한다.
//   - describe() 는 부모의 출력을 그대로 찍고, 그 다음 줄에 할인 정보를 추가로 찍는다.
//       상품: 모니터 / 가격: 200000원 / 재고: 0개
//         할인율: 10% → 할인가: 180000원
//   - 할인가 = price * (100 - discountRate) ~/ 100      (~/ 는 정수 나눗셈)
//   - 부모의 describe() 를 "다시 작성하지 말고" 호출해서 쓰세요.
// ----------------------------------------------------------------
// TODO: class DiscountProduct
/*  [내가 작성한 것]
class DiscountProduct extends Product {
    int discountRate;
    DiscountProduct(String name , int price ,int discountRate ,  {int stock=0})
    : super(name,price,stock)
    {
      discountRate = this.discountRate;
    }

    @override
    void describe() {
      super.describe();
      int discount_price = price * (100 - discountRate) ~/ 100;
      print("할인율 : $discountRate -> 할인가 : $discount_price");
    }
}
*/

// [틀린 부분]
//  1) super(name, price, stock) → stock 을 "세 번째 순서" 로 넘김
//     → super(...) 도 Product 생성자 "호출" 이라 Product 를 부르는 규칙과 같다.
//     → Product 는 stock 을 { } 안에서 받으니 이름을 붙여서 stock: stock
//  2) discountRate 를 몸통 { } 에서 채움 (+ 방향도 반대였음)
//     → 객체가 만들어지는 순서: ① 필드 채우기 → ② 부모 생성자 → ③ 객체 완성 → ④ 몸통
//     → 몸통은 너무 늦다. 문제 1 처럼 매개변수 자리에 this.discountRate
//     → 그러면 몸통 { } 자체가 필요 없어진다.
//  3) 출력 형식: 앞 공백 2칸, "할인율: 10%", "→", 할인가 뒤 "원" / 변수 이름 discountPrice (lowerCamelCase)
class DiscountProduct extends Product {
  int discountRate;

  // 처음 고친 형태 (super 호출이 눈에 보이는 버전)
  // DiscountProduct(String name, int price, this.discountRate, {int stock = 0})
  //     : super(name, price, stock: stock);

  // super.xxx → 받은 값을 그대로 부모 생성자에 넘긴다 (this.xxx 의 짝)
  // stock 기본값(0)은 부모 Product 의 기본값을 그대로 물려받는다.
  DiscountProduct(super.name, super.price, this.discountRate, {super.stock});

  @override
  void describe() {
    super.describe();   // 부모 출력은 다시 작성하지 않고 그대로 호출
    int discountPrice = price * (100 - discountRate) ~/ 100;
    print("  할인율: $discountRate% → 할인가: $discountPrice원");
  }
}


// ================================================================
// [문제 3] 선언 vs 실행  (코드 작성 X, 주석으로 O / X 답하기)
// ================================================================
//  아래 줄들을 "클래스 몸통 { } 바로 안" 에 쓸 수 있으면 O, 없으면 X.
//  X 라면 "그럼 어디에 써야 하는지" 도 적어보세요.
//
//  class Cart {
//    int count = 0;              // (a) 답: O
//    print("장바구니 생성");       // (b) 답: X
//    void add() { count++; }     // (c) 답: O
//    add();                      // (d) 답: X
//    count = 5;                  // (e) 답: X
//    String get label => "$count개";   // (f) 답: O
//  }
//
//  보너스: 지난 mixin 문제에서 HeartRateSensor 몸통에 checkBattery(); 를 썼을 때
//         Dart 는 그걸 무엇으로 이해했을까요?
//         답:


// ================================================================
// [문제 4] 구현을 어디에 둘까 (abstract)
// ================================================================
//  결제 수단: CardPayment(카드), CashPayment(현금)
//  모든 결제는 금액(amount) 없이는 만들 수 없다.
//
//  pay() 를 호출하면 아래 순서로 출력된다.
//    1. "[결제] {금액}원"            ← 모든 결제 수단이 똑같음
//    2. 결제 수단별 처리              ← 수단마다 다름
//         카드: "카드 승인 요청"
//         현금: "현금 수령"
//    3. "결제 완료 (영수증 발행)"     ← 모든 결제 수단이 똑같음
//
//  생각해볼 것
//   - Payment 자체로 객체를 만들 일이 있나?
//   - 1, 3 번 코드는 어디에 한 번만 쓰면 되나?
//   - 2 번은 누가 구현해야 하나? 부모는 2 번에 대해 무엇만 정해두면 되나?
//   - 자식 클래스에서 1, 3 번 print 를 다시 쓰고 있다면 → 다시 생각!
// ----------------------------------------------------------------
// TODO: class Payment
abstract class Payment {
  Payment(this.amount);
  String paymentType = "";
  int amount = 0;

  void whatPayment() {
    print("$paymentType");
  }
  void pay() {
    print("[결제] : $amount");
    whatPayment();
    print("결제 완료 (영수증 발행)");
  }
}
// TODO: class CardPayment
class CardPayment extends Payment {
  CardPayment(super.amount)  {
  }
  @override
  
}
// TODO: class CashPayment
class CashPayment extends Payment {
  CashPayment(super.amount) {
     super.paymentType = "현금: 현금 수령"; 
  }
}


void main() {
  // 문제 1, 2, 4 를 다 만들었으면 아래 주석을 풀고 실행하세요.

  // Product("키보드", 50000).describe();
  // Product("마우스", 30000, stock: 10).describe();
  // DiscountProduct("모니터", 200000, 10).describe();
  //
   CardPayment(50000).pay();
   CashPayment(30000).pay();

  /*
    [기대 출력]
    상품: 키보드 / 가격: 50000원 / 재고: 0개
    상품: 마우스 / 가격: 30000원 / 재고: 10개
    상품: 모니터 / 가격: 200000원 / 재고: 0개
      할인율: 10% → 할인가: 180000원
    [결제] 50000원
    카드 승인 요청
    결제 완료 (영수증 발행)
    [결제] 30000원
    현금 수령
    결제 완료 (영수증 발행)
   */
}


// ================================================================
// [문제 5] 에러 메시지 읽기  (코드 작성 X, 주석으로 답하기)
// ================================================================
//  아래 블록을 "하나씩만" 주석 해제 → 저장 → 빨간 줄 / `dart analyze` 메시지를 읽고,
//  1) 에러 메시지 원문(영어)  2) 내 말로 무슨 뜻인지  3) 어떻게 고치면 되는지  를 적으세요.
//  확인이 끝나면 다시 주석 처리!
//
// ---- (5-a) ----
// class Robot {
//   Robot(String name);
//   void hello() => print("안녕, 나는 $name");
// }
//  1) 원문:
//  2) 뜻:
//  3) 고치는 법:
//
// ---- (5-b) ----
// class Animal {
//   final String name;
//   Animal(this.name);
// }
// class Dog extends Animal {
//   Dog();
// }
//  1) 원문:
//  2) 뜻:
//  3) 고치는 법:
//
// ---- (5-c) ----  (문제 4 를 다 만든 뒤에, main 안에 넣어서 확인)
// Payment(1000).pay();
//  1) 원문:
//  2) 뜻:
//  3) 고치는 법:
