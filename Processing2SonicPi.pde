//-----------------------------------------------------------------------------    
//作成日：    2019/07/13
//修正日：    
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
Bang RESET, CLEAR;
Bang[] bang=new Bang[4*2];
String message="";
String[] cp5MSG={"MUSICNUM", "VOLUME", "OCTAVE", "TIME"};

//showInfo
float ry=0;
float alpha = 255;
PImage logo;

//LeapMotoin
/*
import de.voidplus.leapmotion.*;
 LeapMotion leapmotion;
 Leap leap;
 //*/

void setup() {
  size(960, 540, P3D);
  frameRate(60);

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
      bang[y*2+x]=cp5.addBang(cp5MSG[y]+(x==0?"-":"+"))
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
  RESET=cp5.addBang("RESET")
    .setPosition(width-250+25, 225)
    .setSize(100, 25)
    .setFont(fontMsg)
    .align(CENTER, CENTER, CENTER, CENTER);  
  //MessageBox
  cp5.addTextarea("Message")
    .setPosition(50, height/2+50)
    .setSize(width-50-250, height/2-100)
    .setFont(fontMsg)
    .setLineHeight(16)
    .setColor(color(222))
    .setColorBackground(color(0, 102, 0, 160))
    .setColorForeground(color(255, 100))
    .setText(message);
  ;
  //ClearButon
  CLEAR=cp5.addBang("CLEAR")
    .setPosition(width-250, height/2+50)
    .setSize(200, height/2-100)
    .setFont(font)
    .align(CENTER, CENTER, CENTER, CENTER);


  //osc
  oscP5 = new OscP5(this, 8000);
  location = new NetAddress("", 4559);

  //Leap
  /*
  leapmotion = new LeapMotion(this);
  leap=new Leap(leapmotion);
  //*/
}

void draw() {
  background(0, 50, 0);
  showInfo();


  /*
  leap.draw();
   if (leap.CheckChange()) {
   PVector fingerPos=leap.getPos();
   PVector pos=new PVector(0, 0);
   PVector size=new PVector(0, 0);
   // boolean click=leap.getClick();
   for (int y=0; y<cp5MSG.length; y++) {
   for (int x=0; x<2; x++) {
   Bang b=bang[y*2+x];
   pos=new PVector(b.getPosition()[0], b.getPosition()[1]);
   size=new PVector(100, 50);
   float n=0;
   if (fingerPos.x>pos.x&&fingerPos.x<pos.x+size.x&&fingerPos.y>pos.y&&fingerPos.y<pos.y+size.y) {
   
   leap.setChange(true);
   n=(x==0?-1:1);
   n=(y==3?n/4:n);
   sendMessage(cp5MSG[y].toString(), n);
   }
   }
   }
   
   //PLAY
   pos=new  PVector(PLAY.getPosition()[0], PLAY.getPosition()[1]);
   size=new PVector(100, 100);
   if (fingerPos.x>pos.x&&fingerPos.x<pos.x+size.x&&fingerPos.y>pos.y&&fingerPos.y<pos.y+size.y) {
   leap.setChange(true);
   PLAY.setValue(PLAY.getValue()==0?true:false);
   }
   //RESET
   pos=new  PVector(RESET.getPosition()[0], RESET.getPosition()[1]);
   size=new PVector(100, 25);
   if (fingerPos.x>pos.x&&fingerPos.x<pos.x+size.x&&fingerPos.y>pos.y&&fingerPos.y<pos.y+size.y) {
   leap.setChange(true);
   RESET();
   }
   //CLEAR
   pos=new  PVector(CLEAR.getPosition()[0], CLEAR.getPosition()[1]);
   size=new PVector(width-50-250, height/2-100);
   if (fingerPos.x>pos.x&&fingerPos.x<pos.x+size.x&&fingerPos.y>pos.y&&fingerPos.y<pos.y+size.y) {
   leap.setChange(true);
   CLEAR();
   }
   } else if (!leap.getClick()) {
   leap.setChange(false);
   }
   //*/
}
void showInfo() {
  pushMatrix();
  translate(logo.width*2, height-60, 40);
  rotateY(ry);
  rotateY(PI*2);
  scale(0.4);
  image(logo, -logo.width/2, 0);
  popMatrix();
  ry += 0.02;
  alpha+=random(0.02, 0.09);
  fill(255, 255, 255, map(sin(alpha), -1, 1, 40, 255));
  text("Ver1.0", logo.width*2, height-16);
  textAlign(LEFT);
  text("http:/www.github.com/SKyoKen/Leap_SonicPi", width/3, height-16);
}
void CLEAR() {
  message="";
  cp5.get(Textarea.class, "Message").setText(message);
}
void writemsg(String s) {
  //year/month/day hour:minute:second
  String time=String.format("%d/%02d/%02d %02d:%02d:%02d\t", year(), month(), day(), hour(), minute(), second());
  message+=time+s+"\n";
  cp5.get(Textarea.class, "Message").setText(message);
  println(s);
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
    String m=theEvent.getName();
    float n=0;
    for (int i=0; i<cp5MSG.length; i++) {
      if (cp5MSG[i].equals(m.substring(0, m.length()-1))) {
        n=("-".equals(m.substring(m.length()-1)))?-1:1;
        n=("TIME".equals(cp5MSG[i]))?n/4:n;
        sendMessage(cp5MSG[i].toString(), n);
      }
    }
  }
}
/*
   void leapOnInit() {
 writemsg("Leap Motion Init");
 }
 void leapOnConnect() {
 writemsg("Leap Motion Connect");
 }
 void leapOnDisconnect() {
 writemsg("Leap Motion Disconnect");
 }
 void leapOnExit() {
 writemsg("Leap Motion Exit");
 }///*/
