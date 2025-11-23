
class Obstacle {
  
  PVector pos;
  float w;
  float h;
  boolean knifeable;
  
  PVector pLeft;
  PVector pRight;
  PVector pTop;
  PVector pBottom;
  PVector pKnifeable;
  PVector pDelete;
  boolean draggingLeft = false;
  boolean draggingTop = false;
  boolean draggingRight = false;
  boolean draggingBottom = false;
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
    pLeft = cam.worldToScreen(pos.copy().add(0,h/2));
    pRight = cam.worldToScreen(pos.copy().add(w,h/2));
    pTop = cam.worldToScreen(pos.copy().add(w/2,0));
    pBottom = cam.worldToScreen(pos.copy().add(w/2,h));
    pKnifeable = cam.worldToScreen(pos.copy().add(w/2,h/2).add(Util.debugPointSize,0));
    pDelete = cam.worldToScreen(pos.copy().add(w/2,h/2).add(-Util.debugPointSize,0));
    
    fill(#FF00FF);
    circle(pLeft.x, pLeft.y, Util.debugPointSize);
    circle(pRight.x, pRight.y, Util.debugPointSize);
    circle(pTop.x, pTop.y, Util.debugPointSize);
    circle(pBottom.x, pBottom.y, Util.debugPointSize);
    fill(#FF0000);
    circle(pDelete.x, pDelete.y, Util.debugPointSize);
    fill(#FF8800);
    circle(pKnifeable.x, pKnifeable.y, Util.debugPointSize);
  }
  
  void checkDebugpointCollision(PVector mousePos, Camera cam, ArrayList<Obstacle> obss) {
    if(draggingLeft) {
      pos.x = cam.screenToWorld(mousePos).x;
    }
    if(draggingTop) {
      pos.y = cam.screenToWorld(mousePos).y;
    }
    if(draggingRight) {
      w = cam.screenToWorld(mousePos).x - pos.x;
    }
    if(draggingBottom) {
      h = cam.screenToWorld(mousePos).y - pos.y;
    }
    
    if(Util.withinRadiusOf(mousePos, pLeft, Util.debugPointSize)) {
      draggingLeft = true;
    }
    if(Util.withinRadiusOf(mousePos, pTop, Util.debugPointSize)) {
      draggingTop = true;
    }
    if(Util.withinRadiusOf(mousePos, pRight, Util.debugPointSize)) {
      draggingRight = true;
    }
    if(Util.withinRadiusOf(mousePos, pBottom, Util.debugPointSize)) {
      draggingBottom = true;
    }
    if(Util.withinRadiusOf(mousePos, pDelete, Util.debugPointSize) && !clickingDelete) {
      clickingDelete = true;
      obss.remove(this);
    }
    if(Util.withinRadiusOf(mousePos, pKnifeable, Util.debugPointSize) && !clickingKnifeable) {
      clickingKnifeable = true;
      knifeable = !knifeable;
    }
  }
  
  void releaseAllPoints() {
    draggingLeft = false;
    draggingTop = false;
    draggingRight = false;
    draggingBottom = false;
    clickingDelete = false;
    clickingKnifeable = false;
  }
  
  boolean collidesWith(PVector entPos, float entW, float entH) {
    return Util.collide(pos.x, pos.y, w, h, entPos.x, entPos.y, entW, entH).mag() > 0;
  }
}
