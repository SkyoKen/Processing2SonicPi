/*
class Leap {
  LeapMotion leap;
  boolean change=false;
  public Leap(LeapMotion leap) {
   this.leap=leap;
  }

  void draw() {
    for (Hand hand : this.leap.getHands ()) {
      for (Finger finger : hand.getFingers()) {
        strokeWeight(10);
        fill(0);
        finger.drawBones();
        finger.drawJoints();
      }
    }
  } 
  boolean isRight() {
    for (Hand hand : this.leap.getHands ()) {
      return hand.isRight();
    }
    return false;
  }
  PVector getPos() {
    for (Hand hand : this.leap.getHands ()) {
      return hand.isRight()?hand.getIndexFinger().getPosition():null;
    }
    return null;
  }
  boolean getClick() {
    for (Hand hand : this.leap.getHands ()) {
      if (hand.isRight()) {
        String finger="";
        for (Finger f : hand.getFingers())finger+=f.isExtended()?1:0;
        return finger.equals("00000");
      }
    }
    return false;
  }
  boolean CheckChange() {
    return !change&&getClick();
  }
  void setChange(boolean change) {
    this.change=change;
  }
}
*/
