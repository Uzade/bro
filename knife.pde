class Knife {
  
  float dyingAnnimationDuration = 50;
  
  PVector pos;
  PVector speed;
  boolean collidable = false;
  boolean dying = false;
  float dyingAnnimationStart = 0;
  
  float knifeWidth = 50;
  float knifeHeight = 10;
  
  Knife(PVector pos, float speed) {
    this.pos = pos;
    this.speed = new PVector(speed, 0);
  }
  
  void render(PVector camPos, long framesElapsed) {
    pos.add(speed); //TODO move out
    PVector screenPos = Util.worldToScreen(pos, camPos);
    if(dying){
      float t = (framesElapsed-dyingAnnimationStart) / dyingAnnimationDuration;
      t = constrain(t, 0, 1);
      t = 1 - t;
      fill(255, 255, 255, t*255);
      stroke(0, 0, 0, t*255);
      speed.y += 0.2;
    } else {
      stroke(#000000);
      fill(#FFFFFF);
    }
    rect(screenPos.x, screenPos.y, knifeWidth, knifeHeight);
  }
  
  void checkCollision(Obstacle obs, long framesElapsed) {
    if(Util.collide(obs.pos.x, obs.pos.y, obs.w, obs.h, pos.x, pos.y, knifeWidth, knifeHeight).mag() > 0){
      if(obs.knifeable && !dying){
        collidable = true;
        speed.limit(0);
      } else if(!dying) {
        dying = true;
        dyingAnnimationStart = framesElapsed;
        speed.mult(-0.2);
      }
    }
  }
}
