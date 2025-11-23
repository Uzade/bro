float acc = 1;
float gravity = 0.5;
float groundDrag = 0.85;
float jumpForce = 14;

boolean onGround = false;

float shootSpeed = 10;

float groundHeight = 800;

PVector pos = new PVector(40, 40);
PVector vel = new PVector(0, 0);

boolean aPressed = false;
boolean dPressed = false;
boolean wPressed = false;
boolean sPressed = false;
boolean qPressed = false;
boolean ePressed = false;
boolean tPressed = false;
boolean shootPressed = false;
boolean spacePressed = false;

float playerHeight = 80;

boolean shootingLeft = true;

long framesElapsed = 0;

boolean editorMode = false;
float camSpeed = 15;
float camZoom = 1;

KeyboardMgr kbdMgr = new KeyboardMgr();
Camera cam = new Camera(kbdMgr);
Level level = new Level(cam);

void setup () {
  size(1500, 900);
  kbdMgr.doOnKeyDownStroke('h', () -> println("You pressed 'H'"));
}



void physicsStuff() {
  onGround = level.checkAndSolveCollisions(pos, playerHeight, playerHeight, vel);

  if (!onGround) {
    vel.y += gravity;
  } else {
    vel.y = 0;
  }

  vel.x *= groundDrag;
  if (vel.x > 0) {
    shootingLeft =true;
  } else if ( vel.x <0) {
    shootingLeft = false;
  }

  if (!editorMode) { // move player
    if (aPressed) {
      vel.x -= acc;
    }

    if (dPressed) {
      vel.x += acc;
    }
    if (spacePressed && onGround) {
      vel.y -= jumpForce;
    }
  }

  pos.add(vel);
}

void render() {
  background(#761C1C);
  PVector posScreen = cam.worldToScreen(pos);
  fill(#FFFFFF);
  rect(posScreen.x, posScreen.y, playerHeight, playerHeight);
  level.drawLevel(framesElapsed, editorMode);
  fill(#FFFFFF);
  PVector groundPos = cam.worldToScreen(new PVector(0, groundHeight));
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
  if (key == 'a' && !aPressed) {
    aPressed = true;
    
  } else if (key == 'd' && !dPressed) {
    dPressed = true;
    camTransitionStart = framesElapsed;
  } else if (key == ' ') {
    spacePressed = true;
  } else if (!editorMode && key == 'w' && !shootPressed) {
    level.throwKnife(pos, shootingLeft? shootSpeed:-1*shootSpeed);
  } else if (key == 'w') {
    wPressed = true;
  } else if (key == 's') {
    sPressed = true;
  } else if (key == 'q') {
    qPressed = true;
  } else if (key == 'e') {
    ePressed = true;
  } else if (key == 't' && !tPressed) {
    tPressed = true;
    editorMode = !editorMode;
  }
}

void keyReleased() {
  kbdMgr.onKeyReleased();
  if (key == 'a') {
    aPressed = false;
  } else if (key == 'd') {
    dPressed = false;
  } else if (key == ' ') {
    spacePressed = false;
  } else if (!editorMode && key == 'w') {
    shootPressed = false;
  } else if (key == 'w') {
    wPressed = false;
  } else if (key == 's') {
    sPressed = false;
  } else if (key == 'q') {
    qPressed = false;
  } else if (key == 'e') {
    ePressed = false;
  } else if (key == 't') {
    tPressed = false;
  }
}

void mouseReleased() {
  level.onMouseRelease();
  //kbdMgr.debugPressedKeys();
}
