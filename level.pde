class Level1 {

  ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
  ArrayList<Knife> knifes = new ArrayList<Knife>();

  Level1() {
    obstacles.add(new Obstacle(400, 400, 150, 400, true));
    obstacles.add(new Obstacle(500, 300, 75, 500, true));
    obstacles.add(new Obstacle(-100, 600, 75, 200, false));
  }

  void drawLevel(PVector camPos, long framesElapsed, boolean editorMode) {
    for (int i = 0; i< obstacles.size(); i++) {
      obstacles.get(i).render(camPos);
      if(editorMode){
        obstacles.get(i).drawDebugPoints(camPos);
        if (mousePressed) obstacles.get(i).checkDebugpointCollision(new PVector(mouseX, mouseY), camPos, obstacles);
      }
    }
    for (int i = 0; i< knifes.size(); i++) {
      knifes.get(i).render(camPos, framesElapsed);
    }
    stroke(#000000);
  }

  boolean checkAndSolveCollisions(PVector playerPos, float playerW, float playerH, PVector playerVel) {
    onGround = pos.y >= (groundHeight -playerHeight);

    for (int i = 0; i< knifes.size(); i++) {
      Knife knife = knifes.get(i);

      if (!knife.collidable) continue;
      onGround |= Util.checkAndSolveCollision(knife, playerPos, playerW, playerH, playerVel);
    }
    for (int i = 0; i < obstacles.size(); i++) {
      onGround |= Util.checkAndSolveCollision(obstacles.get(i), playerPos, playerW, playerH, playerVel);
    }
    for (int i = 0; i< knifes.size(); i++) {
      for (int j = 0; j < obstacles.size(); j++) {
        knifes.get(i).checkCollision(obstacles.get(j), framesElapsed);
      }
    }
    return onGround;
  }

  void throwKnife(PVector playerPos, float shootSpeed) {
    if (knifes.size() > 1 ) {
      knifes.remove(0);
    }
    PVector knifePos = playerPos.copy();
    knifePos.y += playerHeight/2;
    knifePos.x += playerHeight/2;
    knifes.add(new Knife(knifePos, shootSpeed));
    shootPressed = true;
  }
}
