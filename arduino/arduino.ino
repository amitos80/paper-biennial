#include <SharpIR.h>

//void sendInfo(const __FlashStringHelper* head, char* data){
//  Serial.print(head);
//  Serial.println(data);
//}


unsigned long coinsCount = 0;
SharpIR sharp(GP2Y0A02YK0F, A0);
int d = 0;
int previousDistance = 0;

void setup() {
  Serial.begin(9600);
  attachInterrupt(0, acceptorCount, RISING); //Digital interrupt pin 2
}

void checkCoins() {
  if (coinsCount > 0) {  
    coinsCount = 0;
    Serial.println("C");
    delay(20);
  }
}

void loop() {
  d = sharp.getDistance();
  if (d >= 20 && d <= 200) {
    if (abs(d - previousDistance) > 10) {
      Serial.println("D" + d);  
    }
    
    previousDistance = d;
  }
  
  
  checkCoins();
  //delay(50);
}

void acceptorCount() {
  coinsCount = 1;
}
