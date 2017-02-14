import processing.serial.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress resol;
OscBundle myBundle;
OscMessage myMessage;

int lastCoinTs = 0;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

void setup() {
  size(200, 200);
  String portName = Serial.list()[1];
  String[] list = Serial.list();
  for(int i = 0; i < list.length; i++) {
    println(i + " name = " + list[i]);
  }
  myPort = new Serial(this, portName, 9600);
  
  oscP5 = new OscP5(this, 7001);
  resol = new NetAddress("127.0.0.1", 7000);
  myBundle = new OscBundle();
  myMessage = new OscMessage("/");  
}

void draw() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readString();
    
    int integerValue = -1;
    try {
        integerValue = Integer.valueOf(val);
        if (integerValue == 1) {
           if (millis() - lastCoinTs > 1000) {
            println("ONE");
            //sendOscMessage(...)
            lastCoinTs = millis();
           }
       } else {
         // take snapshot
         println(val);
       }  
      
    }catch(Exception e) {
      
    }
  }
  
  val = "";
}

void sendOscMessage(String pattern, int value) {
  // pattern example "/layer3/clip2/connect"
  myMessage.setAddrPattern(pattern);
  // value 0, 1
  myMessage.add(value);
  myBundle.add(myMessage);
  myMessage.clear();
  oscP5.send(myBundle, resol);
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("*** received an osc message.");
  print("*** addrpattern: "+theOscMessage.addrPattern());
  println("*** typetag: "+theOscMessage.typetag());
}

String readStringFromSerial () {
  String res = new String();
   while (myPort.available() > 0) {
     res.concat(myPort.readString());
  }
  return res;
}