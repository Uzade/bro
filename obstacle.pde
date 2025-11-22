
class Obstacle {
  static final float debugPointSize = 15;
  
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
  
  void render(PVector camPos) {
    PVector screenPos = Util.worldToScreen(pos, camPos);
    if(!knifeable){
      fill(#EDB959);
    } else {
      fill(#FFFFFF);
    }
    rect(screenPos.x, screenPos.y, w, h);
  }
  
  void drawDebugPoints(PVector camPos) {
    pLeft = Util.worldToScreen(pos.copy().add(0,h/2), camPos);
    pRight = Util.worldToScreen(pos.copy().add(w,h/2), camPos);
    pTop = Util.worldToScreen(pos.copy().add(w/2,0), camPos);
    pBottom = Util.worldToScreen(pos.copy().add(w/2,h), camPos);
    pKnifeable = Util.worldToScreen(pos.copy().add(w/2,h/2).add(debugPointSize,0), camPos);
    pDelete = Util.worldToScreen(pos.copy().add(w/2,h/2).add(-debugPointSize,0), camPos);
    
    fill(#FF00FF);
    circle(pLeft.x, pLeft.y, debugPointSize);
    circle(pRight.x, pRight.y, debugPointSize);
    circle(pTop.x, pTop.y, debugPointSize);
    circle(pBottom.x, pBottom.y, debugPointSize);
    fill(#FF0000);
    circle(pDelete.x, pDelete.y, debugPointSize);
    fill(#FF8800);
    circle(pKnifeable.x, pKnifeable.y, debugPointSize);
  }
  
  void checkDebugpointCollision(PVector mousePos, PVector camPos, ArrayList<Obstacle> obss) {
    if(draggingLeft) {
      pos.x = Util.screenToWorld(mousePos, camPos).x;
    }
    if(draggingTop) {
      pos.y = Util.screenToWorld(mousePos, camPos).y;
    }
    if(draggingRight) {
      w = Util.screenToWorld(mousePos, camPos).x - pos.x;
    }
    if(draggingBottom) {
      h = Util.screenToWorld(mousePos, camPos).y - pos.y;
    }
    
    if(Util.withinRadiusOf(mousePos, pLeft, debugPointSize)) {
      draggingLeft = true;
    }
    if(Util.withinRadiusOf(mousePos, pTop, debugPointSize)) {
      draggingTop = true;
    }
    if(Util.withinRadiusOf(mousePos, pRight, debugPointSize)) {
      draggingRight = true;
    }
    if(Util.withinRadiusOf(mousePos, pBottom, debugPointSize)) {
      draggingBottom = true;
    }
    if(Util.withinRadiusOf(mousePos, pDelete, debugPointSize) && !clickingDelete) {
      clickingDelete = true;
      obss.remove(this);
    }
    if(Util.withinRadiusOf(mousePos, pKnifeable, debugPointSize) && !clickingKnifeable) {
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
