
class Obstacle {
  PVector pos;
  float w;
  float h;
  boolean knifeable;
  
  Obstacle(float x, float y, float w, float h, boolean knifeable) {
   this.pos = new PVector(x, y);
   this.w = w;
   this.h = h;
   this.knifeable = knifeable;
  }
  
  void draw(PVector camPos) {
    PVector screenPos = Util.worldToScreen(pos, camPos);
    if(!knifeable){
      fill(#EDB959);
    } else {
      fill(#FFFFFF);
    }
    rect(screenPos.x, screenPos.y, w, h);
  }
  
  boolean collidesWith(PVector entPos, float entW, float entH) {
    return Util.collide(pos.x, pos.y, w, h, entPos.x, entPos.y, entW, entH).mag() > 0;
  }
}
