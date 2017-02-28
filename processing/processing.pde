import processing.serial.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress resol;
NetAddress slave;
OscBundle myBundle;
OscMessage myMessage;

int lastCoinTs = 0;

Serial myPort;  // Create object from Serial class
String val;      // Data received from the serial port

final String LOOP_A_VIDEO = "/layer2/clip1/connect";
final String LOOP_A_AUDIO = "/layer1/clip1/connect";

final String LOOP_B_VIDEO = "/layer2/clip2/connect";
final String LOOP_B_AUDIO = "/layer1/clip2/connect";

final String LOOP_C_VIDEO = "/layer3/clip2/connect";
final String LOOP_BLANK = "/layer3/clip1/connect";

int firstVideoStart = 0;

final int STATE_LOOP_A = 1;
final int STATE_LOOP_B = 2;
final int STATE_LOOP_C = 3;
int state = STATE_LOOP_A;
int initTs = 0;

int loopBTS = 0;
int loopCTS = 0;

void setup() {
  size(200, 200);
  frameRate(10);
  String portName = Serial.list()[1];
  String[] list = Serial.list();
  for(int i = 0; i < list.length; i++) {
    println(i + " name = " + list[i]);
  }
  myPort = new Serial(this, portName, 9600);
  
  oscP5 = new OscP5(this, 7001);
  slave = new NetAddress("10.0.0.6", 7000);
  resol = new NetAddress("127.0.0.1", 7000);
  myBundle = new OscBundle();
  myMessage = new OscMessage("/");  
  firstVideoStart = millis();
  initTs = millis();
  
 // checkFirstVideo(true);
}

void draw() {
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n');
    println("READ = " + val);
    int integerValue = -1;
    try {
        if (val.indexOf("C") != -1) {
           if (millis() - lastCoinTs > 2000) {
            lastCoinTs = millis();
            state = STATE_LOOP_B;
            playLoop('B');
           }
       } else if ((val.indexOf("D") != -1)){
         val = val.replace("D", "");
         integerValue = Integer.valueOf(val);
         //println("INT = " + integerValue);
         if (state != STATE_LOOP_A && integerValue > 100) {
           state = STATE_LOOP_A;
           playLoop('A');
         }
       }  
    }catch(Exception e) {
      
    }
  }
  
  val = "";
  checkFirstVideo(false);
  checkPlayLoopC();
}

void checkPlayLoopC() {
  if (state == STATE_LOOP_B) {
    if ((millis() - loopBTS) / 1000 >= 42) {
      state = STATE_LOOP_C;
      loopCTS = millis();
      playLoop('C');
    } 
  } else if (state == STATE_LOOP_C) {
    if ((millis() - loopCTS) / 1000 >= 13) {
      state = STATE_LOOP_A;
      playLoop('D');
    }
  }
}

void playLoop(char loop) {
  if (loop == 'A') {
    sendOscMessage(LOOP_A_VIDEO, 1);
    sendOscMessage(LOOP_A_AUDIO, 1);
  } else if(loop == 'B') {
    sendOscMessage(LOOP_B_VIDEO, 1);
    sendOscMessage(LOOP_B_AUDIO, 1);
    loopBTS = millis();
  } else if(loop == 'C') {
    sendOscMessage(LOOP_C_VIDEO, 1);
  } else if(loop == 'D') {
    sendOscMessage(LOOP_BLANK, 1);
  }
}

void checkFirstVideo(boolean forceStart) {
  if ((millis() - initTs) / 1000 < 600 && state == STATE_LOOP_A || forceStart) {
    if ((millis() - firstVideoStart) / 1000 >= 130 || forceStart) {
      firstVideoStart = millis();
      playLoop('A');
    }
  } 
}

void sendOscMessage(String pattern, int value) {
   try {
    println("sendOscMessage " + pattern + ' ' + value);
    myMessage.setAddrPattern(pattern);
    myMessage.add(value);
    myBundle.add(myMessage);
    myMessage.clear();
    oscP5.send(myBundle, resol);
    oscP5.send(myBundle, slave);
    myBundle.clear();
  } catch(Exception e){
    print("#@#@#@#@#@# EXCEPTION " + e.getMessage());
  }
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("*** received an osc message.");
  print("*** addrpattern: "+theOscMessage.addrPattern());
  println("*** typetag: "+theOscMessage.typetag());
}