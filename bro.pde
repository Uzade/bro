boolean onGround = false;

PVector pos = new PVector(40, 40);
PVector vel = new PVector(0, 0);

boolean shootingLeft = true;

long framesElapsed = 0;

boolean editorMode = false;

KeyboardMgr kbdMgr = new KeyboardMgr();
Camera cam = new Camera(kbdMgr);
Level level = new Level(cam, kbdMgr);

void setup () {
  size(1500, 900);
  kbdMgr.doOnKeyDownStroke('t', () -> editorMode = !editorMode);
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

void render() {
  background(#761C1C);
  PVector posScreen = cam.worldToScreen(pos);
  fill(#FFFFFF);
  rect(posScreen.x, posScreen.y, Config.playerHeight, Config.playerHeight);
  level.drawLevel(framesElapsed, editorMode);
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
