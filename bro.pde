float acc = 1;
float gravity = 0.5;
float groundDrag = 0.85;
float jumpForce = 14;

boolean onGround = false;

float shootSpeed = 10;

float groundHeight = 800;

PVector pos = new PVector(40, 40);
PVector vel = new PVector(0, 0);

PVector camPos = new PVector(0, 0);
PVector targetCamPos = new PVector(0, 0);
float camTransitionTime = 240; // in frames
long camTransitionStart = 0;

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

Level1 level1 = new Level1();

void setup () {
  size(1500, 900);
  
}

void updateCam() {
  targetCamPos = pos.copy().sub(width/2, height/3*2);
  camPos.add(vel);
  if (shootingLeft) {
    targetCamPos.x += width/6;
  } else {
    targetCamPos.x -= width/6;
  }
  float t = (framesElapsed-camTransitionStart) / camTransitionTime;
  t = constrain(t, 0, 1);
  // smoothstep
  float smooth = t * t * (3 - 2 * t);
  // smootherstep
  // float smooth = t * t * t * (t * (6*t - 15) + 10);
  if(!editorMode) camPos.add(targetCamPos.copy().sub(camPos).mult(smooth));
}

void physicsStuff() {
  onGround = level1.checkAndSolveCollisions(pos, playerHeight, playerHeight, vel);

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

  if (aPressed) {
    if(editorMode) {
      camPos.x -= camSpeed;
    } else {
      vel.x -= acc;
    }
  }
  if (dPressed) {
    if(editorMode) {
      camPos.x += camSpeed;
    } else {
      vel.x += acc;
    }
  }
  if (spacePressed && onGround) {
    if(!editorMode) vel.y -= jumpForce;
  }
  
  if(editorMode) {
    if(wPressed) {
      camPos.y -= camSpeed;
    }
    if(sPressed) {
      camPos.y += camSpeed;
    }
    if(qPressed) {
      camZoom -= 0.1;
    }
    if(ePressed) {
      camZoom += 0.1;
    }
  }
  pos.add(vel);
}

void render() {
  background(#761C1C);
  PVector posScreen = Util.worldToScreen(pos, camPos);
  fill(#FFFFFF);
  rect(posScreen.x, posScreen.y, playerHeight, playerHeight);
  level1.drawLevel(camPos, framesElapsed, editorMode);
  fill(#FFFFFF);
  PVector groundPos = Util.worldToScreen(new PVector(0, groundHeight), camPos);
  line(0, groundPos.y, width, groundPos.y);

  textSize(14);
  text("onGround: "+onGround, 10, 20);
  text("pos: "+pos.x+", "+pos.y, 10, 35);
  text("vel: "+vel.x+", "+vel.y, 10, 50);
  text("frameRate: "+frameRate, 10, 65);
  text("editorMode: "+editorMode, 10, 80);
  
  // draw world origin
  fill(#00FF00);
  PVector worldOrigin = Util.worldToScreen(new PVector(0, 0), camPos);
  circle(worldOrigin.x, worldOrigin.y, 5);
}

void draw() {
  physicsStuff();
  updateCam();
  render();
  framesElapsed++;
}

void keyPressed() {
  if (key == 'a' && !aPressed) {
    aPressed = true;
    camTransitionStart = framesElapsed;
  } else if (key == 'd' && !dPressed) {
    dPressed = true;
    camTransitionStart = framesElapsed;
  } else if (key == ' ') {
    spacePressed = true;
  } else if (!editorMode && key == 'w' && !shootPressed) {
    level1.throwKnife(pos, shootingLeft? shootSpeed:-1*shootSpeed);
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
  level1.obstacles.forEach(obs -> obs.releaseAllPoints());
  level1.draggingNewObsIdx = -1;
  level1.pressingGenerate = false;
}
