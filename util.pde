static class Util {
  static PVector collide(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
    float dx=(r1x+r1w/2)-(r2x+r2w/2);
    float dy=(r1y+r1h/2)-(r2y+r2h/2);
    float w=(r1w+r2w)/2;
    float h=(r1h+r2h)/2;
    float crossWidth=w*dy;
    float crossHeight=h*dx;
    PVector collision= new PVector(0, 0);
    //
    if (Math.abs(dx)<=w && Math.abs(dy)<=h) {
      if (crossWidth>crossHeight) {
        collision=(crossWidth>(-crossHeight))? new PVector(0, 1):new PVector(-1, 0);
      } else {
        collision=(crossWidth>-(crossHeight))?new PVector(1, 0):new PVector(0, -1);
      }
    }
    return(collision);
  }

  static PVector worldToScreen(PVector wordCoord, PVector camPos) {
    return wordCoord.copy().sub(camPos);
  }
  
  static PVector screenToWorld(PVector screenCoord, PVector camPos) {
    return screenCoord.copy().add(camPos);
  }

  static boolean checkAndSolveCollision(Obstacle obs, PVector playerPos, float playerW, float playerH, PVector playerVel) {
    return checkAndSolveCollision(obs.pos, obs.w, obs.h, playerPos, playerW, playerH, playerVel);
  }

  static boolean checkAndSolveCollision(Knife knife, PVector playerPos, float playerW, float playerH, PVector playerVel) {
    return checkAndSolveCollision(knife.pos, knife.knifeWidth, knife.knifeHeight, playerPos, playerW, playerH, playerVel);
  }

  static boolean checkAndSolveCollision(PVector obsPos, float obsW, float obsH, PVector playerPos, float playerW, float playerH, PVector playerVel) {
    boolean onGround = false;
    PVector collisionDirection = Util.collide(
        playerPos.x, playerPos.y, playerW, playerH, 
        obsPos.x, obsPos.y, obsW, obsH);
    if (collisionDirection.y < 0) {
      onGround = true;
      playerVel.y = 0;
    } else if (collisionDirection.mag() > 0) {
      while (collisionDirection.mag() > 0) {
        playerPos.add(collisionDirection);
        collisionDirection = Util.collide(
            playerPos.x, playerPos.y, playerW, playerH, 
            obsPos.x, obsPos.y, obsW, obsH);
      }
    }
    return onGround;
  }
  
  static boolean withinRadiusOf(PVector pos1, PVector pos2, float radius) {
    return pos1.copy().sub(pos2).mag() <= radius;
  }
}
