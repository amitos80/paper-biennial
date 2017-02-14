import processing.serial.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress resol;
int lastCoinTs = 0;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  String portName = Serial.list()[1];
  String[] list = Serial.list();
  for(int i = 0; i < list.length; i++) {
    println(i + " name = " + list[i]);
  }
  myPort = new Serial(this, portName, 9600);
  
  oscP5 = new OscP5(this, 12000);
  resol = new NetAddress("127.0.0.1", 7000);
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
            background(random(255), random(255), random(255));
            //oscP5.send(new OscMessage("LOOP_B"), resol);
            //oscP5.send(new OscMessage("/composition/video/scale/values").add(random(0, 1)), resol);
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

String readStringFromSerial () {
  String res = new String();
   while (myPort.available() > 0) {
     res.concat(myPort.readString());
  }
  return res;
}