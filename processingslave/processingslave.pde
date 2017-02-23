import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress resol;
OscBundle myBundle;
OscMessage myMessage;

void setup() {
 
  oscP5 = new OscP5(this, 8880);
  resol = new NetAddress("127.0.0.1", 7000);
  myBundle = new OscBundle();
  myMessage = new OscMessage("/");  
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

void draw() {
  
}

void oscEvent(OscMessage theOscMessage) {
  /* print the address pattern and the typetag of the received OscMessage */
  print("*** received an osc message.");
  print("*** addrpattern: "+theOscMessage.addrPattern());
  println("*** typetag: "+theOscMessage.typetag());
  myBundle.add(theOscMessage);
  oscP5.send(myBundle, resol);
}