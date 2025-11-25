
class Obstacle {
  
  PVector pos;
  float w;
  float h;
  boolean knifeable;
  
  PVector pTopLeft;
  PVector pBottomRight;
  PVector pKnifeable;
  PVector pDelete;
  boolean draggingTopLeft = false;
  boolean draggingBottomRight = false;
  boolean clickingDelete = false;
  boolean clickingKnifeable = false;
  
  Obstacle(float x, float y, float w, float h, boolean knifeable) {
   this.pos = new PVector(x, y);
   this.w = w;
   this.h = h;
   this.knifeable = knifeable;
  }
  
  void render(Camera cam) {
    PVector screenPos = cam.worldToScreen(pos);
    if(!knifeable){
      fill(#EDB959);
    } else {
      fill(#FFFFFF);
    }
    rect(screenPos.x, screenPos.y, w, h);
  }
  
  void drawDebugPoints(Camera cam) {
    pTopLeft = cam.worldToScreen(pos.copy());
    pBottomRight = cam.worldToScreen(pos.copy().add(w,h));

    pKnifeable = cam.worldToScreen(pos.copy().add(w/2,h/2).add(Config.debugPointSize,0));
    pDelete = cam.worldToScreen(pos.copy().add(w/2,h/2).add(-Config.debugPointSize,0));
    
    fill(#FF00FF);
    circle(pTopLeft.x, pTopLeft.y, Config.debugPointSize);
    circle(pBottomRight.x, pBottomRight.y, Config.debugPointSize);
    fill(#FF0000);
    circle(pDelete.x, pDelete.y, Config.debugPointSize);
    fill(#FF8800);
    circle(pKnifeable.x, pKnifeable.y, Config.debugPointSize);
  }
  
  void checkDebugpointCollision(PVector mousePos, Camera cam, ArrayList<Obstacle> obss) {
    if(draggingTopLeft) {
      pos = cam.screenToWorld(mousePos);
    }
    if(draggingBottomRight) {
      w = cam.screenToWorld(mousePos).x - pos.x;
      h = cam.screenToWorld(mousePos).y - pos.y;
    }
    
    if(Util.withinRadiusOf(mousePos, pTopLeft, Config.debugPointSize)) {
      draggingTopLeft = true;
    }
    if(Util.withinRadiusOf(mousePos, pBottomRight, Config.debugPointSize)) {
      draggingBottomRight = true;
    }
    if(Util.withinRadiusOf(mousePos, pDelete, Config.debugPointSize) && !clickingDelete && !draggingTopLeft && !draggingBottomRight) {
      clickingDelete = true;
      obss.remove(this);
    }
    if(Util.withinRadiusOf(mousePos, pKnifeable, Config.debugPointSize) && !clickingKnifeable && !draggingTopLeft && !draggingBottomRight) {
      clickingKnifeable = true;
      knifeable = !knifeable;
    }
  }
  
  void releaseAllPoints() {
    draggingTopLeft = false;
    draggingBottomRight = false;
    clickingDelete = false;
    clickingKnifeable = false;
  }
  
  boolean collidesWith(PVector entPos, float entW, float entH) {
    return Util.collide(pos.x, pos.y, w, h, entPos.x, entPos.y, entW, entH).mag() > 0;
  }
}
