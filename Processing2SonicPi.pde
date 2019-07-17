//-----------------------------------------------------------------------------    
//作成日：    2019/07/13
//修正日：    2019/07/14
//-----------------------------------------------------------------------------
//OSC
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress location;

//ControlP5
import controlP5.*;
ControlP5 cp5;

Toggle PLAY;
Textarea messageBox;
Println console;
String[] cp5MSG={"MUSICNUM", "VOLUME", "OCTAVE", "TIME"};
String version="Ver1.1";
String webAddress="https://github.com/SkyoKen/Processing2SonicPi";

//showInfo
float ry=0;
float alpha = 255;
PImage logo;

void setup() {
  size(960, 540, P3D);
  frameRate(60);

  //osc
  oscP5 = new OscP5(this, 8000);
  location = new NetAddress("", 4559);

  //font
  PFont font = createFont("consolas", 32);
  PFont fontMsg=createFont("consolas", 24);
  textFont(fontMsg);

  //logo
  logo=loadImage("./data/icon.png");

  //cp5
  cp5 = new ControlP5(this);
  cp5.setColorBackground(color(0, 102, 0, 160));
  cp5.setColorForeground(color(107, 142, 35));
  cp5.setColorActive(color(100, 255, 35, 180));
  int btnSize=100;

  //MUSICNUM,VOLUME,OCTAVE,TIME Buton
  for (int y=0; y<cp5MSG.length; y++) {
    PVector pos=new PVector(100+btnSize*3*(y%2), 100+btnSize*(y/2));
    cp5.addTextlabel(cp5MSG[y])
      .setText(cp5MSG[y])
      .setPosition(pos.x+btnSize*1.5/2, pos.y-25)
      .setColorValue(255)
      .setFont(fontMsg)
      ;
    for (int x=0; x<2; x++) {
      pos=new PVector(100+btnSize*3*(y%2), 100+btnSize*(y/2));
      cp5.addBang(cp5MSG[y]+(x==0?"-":"+"))
        .setLabel(x==0?"←":"→")
        .setPosition(pos.x+btnSize*x*1.25, pos.y)
        .setSize(btnSize, btnSize/2)
        .setFont(font)
        .align(CENTER, CENTER, CENTER, CENTER);
    }
  }
  //PlayButon
  PLAY=cp5.addToggle("PLAY")
    .setPosition(width-250+25, 100)
    .setLabel("PLAY")
    .setSize(100, 100)
    .setFont(font)
    .align(CENTER, CENTER, CENTER, CENTER);
  //resetButon
  cp5.addBang("RESET")
    .setPosition(width-250+25, 225)
    .setSize(100, 25)
    .setFont(fontMsg)
    .align(CENTER, CENTER, CENTER, CENTER);  
  //MessageBox
  messageBox=cp5.addTextarea("Message")
    .setPosition(50, height/2+50)
    .setSize(width-50-250, height/2-100)
    .setFont(fontMsg)
    .setLineHeight(20)
    .setColor(color(222))
    .setColorBackground(color(0, 102, 0, 160))
    .setColorForeground(color(255, 100))
    ;

  console=cp5.addConsole(messageBox);
  //ClearButon
  cp5.addBang("CLEAR")
    .setPosition(width-250, height/2+50)
    .setSize(200, height/2-100)
    .setFont(font)
    .align(CENTER, CENTER, CENTER, CENTER);
}

void draw() {
  background(0, 50, 0);
  showInfo();
}
void showInfo() {
  pushMatrix();
  translate(logo.width*1.5, height-60, 40);
  rotateY(ry);
  rotateY(PI*2);
  scale(0.4);
  image(logo, -logo.width/2, 0);
  popMatrix();
  ry += 0.02;
  alpha+=random(0.02, 0.09);
  fill(255, 255, 255, map(sin(alpha), -1, 1, 40, 255));
  textAlign(CENTER,BOTTOM);
  text(version+"   "+webAddress, width/2, height-16);
}
void CLEAR() {
  console.clear();
}
void writemsg(String s) {
  //year/month/day hour:minute:second
  String time=String.format("%d/%02d/%02d %02d:%02d:%02d\t", year(), month(), day(), hour(), minute(), second());
  println(time+s);
}
void sendMessage(String... s) {
  OscMessage msg = new OscMessage(s[0]);
  for (String str : s) {
    if (!str.equals(s[0])) {
      msg.add(str);
    }
  }
  oscP5.send(msg, location);
  writemsg("/osc/"+s[0]+" "+s[1]);
}
void sendMessage(String s, float i) {
  OscMessage msg = new OscMessage(s);
  msg.add(i);
  oscP5.send(msg, location);
  writemsg("/osc/"+s+" "+i);
}
void PLAY(boolean state) {
  sendMessage("FLAG", state?"START":"STOP");
}
void RESET() {
  PLAY.setValue(false);
  sendMessage("FLAG", "RESET");
}
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isAssignableFrom(Bang.class)) {
    for (int i=0; i<cp5MSG.length; i++) {
      String m=theEvent.getName();
      float n=0;
      if (cp5MSG[i].equals(m.substring(0, m.length()-1))) {
        n=("-".equals(m.substring(m.length()-1)))?-1:1;
        n=("TIME".equals(cp5MSG[i]))?n/4:n;
        sendMessage(cp5MSG[i].toString(), n);
      }
    }
  }
}
