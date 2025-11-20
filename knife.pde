class Knife {
  PVector pos;
  float speed;
  boolean collidable = false;
  
  float knifeWidth = 50;
  float knifeHeight = 10;
  
  Knife(PVector pos, float speed) {
    this.pos = pos;
    this.speed = speed;
  }
  
  void update(PVector camPos) {
    pos.x += speed;
    PVector screenPos = Util.worldToScreen(pos, camPos);
    rect(screenPos.x, screenPos.y, knifeWidth, knifeHeight);
  }
  
  void checkCollision(float x, float y, float w, float h) {
    
    if(Util.collide(x, y, w, h, pos.x, pos.y, knifeWidth, knifeHeight).mag() > 0){
      speed = 0;
      collidable = true;
    }
    
    
  }
}
