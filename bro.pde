boolean onGround = false;

PVector pos = new PVector(40, 40);
PVector vel = new PVector(0, 0);

boolean shootingLeft = true;

long framesElapsed = 0;

boolean editorMode = false;

KeyboardMgr kbdMgr = new KeyboardMgr();
Camera cam = new Camera(kbdMgr);
Level level = new Level(cam, kbdMgr);

PImage[] walkAnimation = new PImage[4];
PGraphics playerGC;

void setup () {
  size(1500, 900);
  playerGC = createGraphics(int(Config.playerHeight), int(Config.playerHeight));
  
  kbdMgr.doOnKeyDownStroke('t', () -> editorMode = !editorMode);
  walkAnimation[0] = loadImage("animations/walk1.png");
  walkAnimation[1] = loadImage("animations/walk2.png");
  walkAnimation[2] = loadImage("animations/walk3.png");
  walkAnimation[3] = loadImage("animations/walk4.png");
}

void physicsStuff() {
  onGround = level.checkAndSolveCollisions(pos, Config.playerHeight, Config.playerHeight, vel);

  if (!onGround) {
    vel.y += Config.gravity;
  } else {
    vel.y = 0;
  }

  vel.x *= Config.groundDrag;
  if (vel.x > 0) {
    shootingLeft =true;
  } else if ( vel.x <0) {
    shootingLeft = false;
  }

  if (!editorMode) { // move player
    if (kbdMgr.isKeyPressed('a')) {
      vel.x -= Config.acc;
    }

    if (kbdMgr.isKeyPressed('d')) {
      vel.x += Config.acc;
    }
    if (kbdMgr.isKeyPressed(' ') && onGround) {
      vel.y -= Config.jumpForce;
    }
  }

  pos.add(vel);
}

void drawPlayer() {
  PVector posScreen = cam.worldToScreen(pos);
  
  int imageIdx;
  if(abs(vel.x) > 1) {
    imageIdx = (int)(framesElapsed / Config.animationSpeed) % 4;
  } else {
    imageIdx = 0;
  }
  playerGC.beginDraw();
  playerGC.clear();
  if(!shootingLeft) {
    playerGC.translate(Config.playerHeight, 0);
    playerGC.scale(-1, 1);
  }
  playerGC.image(walkAnimation[imageIdx], 0, 0, Config.playerHeight, Config.playerHeight);
  playerGC.endDraw();
  
  image(playerGC, posScreen.x, posScreen.y, Config.playerHeight, Config.playerHeight);
}

void render() {
  background(#D14848);
  level.drawLevel(framesElapsed, editorMode);
  drawPlayer();
  fill(#FFFFFF);
  PVector groundPos = cam.worldToScreen(new PVector(0, Config.groundHeight));
  line(0, groundPos.y, width, groundPos.y);

  textSize(14);
  text("onGround: "+onGround, 10, 20);
  text("pos: "+pos.x+", "+pos.y, 10, 35);
  text("vel: "+vel.x+", "+vel.y, 10, 50);
  text("frameRate: "+frameRate, 10, 65);
  text("editorMode: "+editorMode, 10, 80);

  // draw world origin
  fill(#00FF00);
  PVector worldOrigin = cam.worldToScreen(new PVector(0, 0));
  circle(worldOrigin.x, worldOrigin.y, 5);
}

void draw() {
  physicsStuff();
  cam.update(pos, vel, editorMode, framesElapsed);
  render();
  framesElapsed++;
}

void keyPressed() {
  kbdMgr.onKeyPressed();
}

void keyReleased() {
  kbdMgr.onKeyReleased();
}

void mouseReleased() {
  level.onMouseRelease();
  //kbdMgr.debugPressedKeys();
}
