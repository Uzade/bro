class Level {
  
  PVector spawnPoint = new PVector(40, 40); // this doesn't really do anything in the game, It's just for showing it in the editor
  Camera cam;
  //PVector playerPos = new PVector(40, 40);
  
  float shootSpeed = 10;
  
  float editorWidth = 300;
  float editorHeight = 200;
  float defaultWidth = 100;
  float defaultHeight = 200;

  ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
  ArrayList<Knife> knifes = new ArrayList<Knife>();
  
  // Editor
  PVector pCreateObs;
  int draggingNewObsIdx = -1;
  PVector pGenerateCode;
  boolean pressingGenerate = false;

  Level(Camera cam, KeyboardMgr kbdMgr) {
    this.cam = cam;
    transitionToLevel1();
    kbdMgr.doOnKeyDownStroke('w', () -> { if(!editorMode) level.throwKnife(pos, shootingLeft? shootSpeed:-1*shootSpeed); });
    
  }
  
  void transitionToLevel1() {
    obstacles.clear();
    
    obstacles.add(new Obstacle(400, 400, 150, 400, true));
    obstacles.add(new Obstacle(500, 300, 75, 500, true));
    obstacles.add(new Obstacle(-100, 600, 75, 200, false));
  }

  void drawLevel(long framesElapsed, boolean editorMode) {
    for (int i = 0; i< obstacles.size(); i++) {
      obstacles.get(i).render(cam);
    }
    for (int i = 0; i< knifes.size(); i++) {
      knifes.get(i).render(cam, framesElapsed);
    }
    stroke(#000000);
    
    if(editorMode) {
      drawEditor();
    }
  }
  
  void drawEditor() {
    for (int i = 0; i< obstacles.size(); i++) {
      obstacles.get(i).drawDebugPoints(cam);
      if (mousePressed) obstacles.get(i).checkDebugpointCollision(new PVector(mouseX, mouseY), cam, obstacles);
    }
    fill(#DDDDDD);
    noStroke();
    rect(width-editorWidth, 0, editorWidth, editorHeight);
    stroke(#000000);
    fill(#000000);
    textSize(20);
    text("Editor-Mode:", width-editorWidth+30, 30);
    textSize(14);
    
    pCreateObs = new PVector(width-editorWidth+40, 60);
    pGenerateCode = new PVector(width-editorWidth+40, editorHeight-20);
    text("new Obstacle", pCreateObs.x+20, pCreateObs.y+4);
    text("generate Code", pGenerateCode.x+20, pGenerateCode.y+4);
    fill(#00FF00);
    circle(pCreateObs.x, pCreateObs.y, Util.debugPointSize);
    circle(pGenerateCode.x, pGenerateCode.y, Util.debugPointSize);
    
    if(draggingNewObsIdx != -1 ) {
      PVector mouseCoordWorld = cam.screenToWorld(new PVector(mouseX, mouseY));
      obstacles.get(draggingNewObsIdx).pos = mouseCoordWorld;
    }
    
    if(mousePressed && draggingNewObsIdx == -1 && Util.withinRadiusOf(new PVector(mouseX, mouseY), pCreateObs, Util.debugPointSize)) {
      draggingNewObsIdx = obstacles.size();
      obstacles.add(new Obstacle(mouseX, mouseY, defaultWidth, defaultHeight, true));
    }
    
    if(mousePressed && !pressingGenerate && Util.withinRadiusOf(new PVector(mouseX, mouseY), pGenerateCode, Util.debugPointSize)) {
      generateLevelCode();
      pressingGenerate = true;
    }
  }
  
  void generateLevelCode() {
    println("\n ====== Level Dump ======");
    for (int i = 0; i< obstacles.size(); i++) {
      Obstacle obs = obstacles.get(i);
      println("    obstacles.add(new Obstacle("+obs.pos.x+", "+obs.pos.y+", "+obs.w+", "+obs.h+", "+obs.knifeable+"));");
    }
    println("");
  }

  boolean checkAndSolveCollisions(PVector playerPos, float playerW, float playerH, PVector playerVel) {
    onGround = pos.y >= (Config.groundHeight -Config.playerHeight);

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
    knifePos.y += Config.playerHeight/2;
    knifePos.x += Config.playerHeight/2;
    knifes.add(new Knife(knifePos, shootSpeed));
  }
  
  void onMouseRelease() {
    obstacles.forEach(obs -> obs.releaseAllPoints());
    draggingNewObsIdx = -1;
    pressingGenerate = false;
  }
}
