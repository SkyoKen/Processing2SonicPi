
class ShowInfo {
  String version="Ver1.2";
  String webAddress="https://github.com/SkyoKen/Processing2SonicPi";
  PImage logo;  //logo
  PFont font;
  float ry=0;
  float alpha = 255;
  ShowInfo(int size) {
    this.logo=loadImage("./data/icon.png");
    this.font=createFont("consolas", size);
  }
  void update() {
    pushMatrix();
    translate(this.logo.width*1.5, height-60, 40);
    rotateY(this.ry);
    rotateY(PI*2);
    scale(0.4);
    image(this.logo, -this.logo.width/2, 0);
    popMatrix();
    this.ry += 0.02;
    this.alpha+=random(0.02, 0.09);
    fill(255, 255, 255, map(sin(this.alpha), -1, 1, 40, 255));
    textFont(this.font);
    textAlign(CENTER, BOTTOM);
    text(this.version+"   "+this.webAddress, width/2, height-16);
  }
}
