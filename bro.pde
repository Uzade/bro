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
boolean shootPressed = false;
boolean spacePressed = false;

float playerHeight = 80;

boolean shootingLeft = true;

ArrayList<Knife> knifes = new ArrayList<Knife>();

ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();

long framesElapsed = 0;

void setup () {
  size(1500, 900);
  obstacles.add(new Obstacle(400, 400, 150, 400, true));
  obstacles.add(new Obstacle(500, 300, 75, 500, true));
  obstacles.add(new Obstacle(-100, 600, 75, 200, false));
  
}

void checkAndSolveCollision(Obstacle obs) {
  checkAndSolveCollision(obs.pos, obs.w, obs.h);
}

void checkAndSolveCollision(Knife knife) {
  checkAndSolveCollision(knife.pos, knife.knifeWidth, knife.knifeHeight);
}

void checkAndSolveCollision(PVector obsPos, float w, float h) {
  PVector obsScreenPos = Util.worldToScreen(obsPos, camPos);
  PVector screenPos = Util.worldToScreen(pos, camPos);
  PVector collisionDirection = Util.collide(screenPos.x, screenPos.y, playerHeight, playerHeight, obsScreenPos.x, obsScreenPos.y, w, h);
  if (collisionDirection.y < 0) {
    onGround = true;
  } else if (collisionDirection.mag() > 0) {
    while (collisionDirection.mag() > 0) {
      pos.add(collisionDirection);
      screenPos = Util.worldToScreen(pos, camPos);
      collisionDirection = Util.collide(screenPos.x, screenPos.y, playerHeight, playerHeight, obsScreenPos.x, obsScreenPos.y, w, h);
    }
  }
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
  camPos.add(targetCamPos.copy().sub(camPos).mult(smooth));
}

void physicsStuff() {
  onGround = pos.y >= (groundHeight -playerHeight);

  for (int i = 0; i< knifes.size(); i++) {
    Knife knife = knifes.get(i);

    if (!knife.collidable) continue;
    checkAndSolveCollision(knife);
  }
  for(int i = 0; i < obstacles.size(); i++) {
    checkAndSolveCollision(obstacles.get(i));
  }

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
    vel.x -= acc;
  }
  if (dPressed) {
    vel.x += acc;
  }
  if (spacePressed && onGround) {
    vel.y -= jumpForce;
  }

  pos.add(vel);
}

void render() {
  background(#761C1C);
  PVector posScreen = Util.worldToScreen(pos, camPos);
  fill(#FFFFFF);
  rect(posScreen.x, posScreen.y, playerHeight, playerHeight);

  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).draw(camPos);
  }
  fill(#FFFFFF);
  PVector groundPos = Util.worldToScreen(new PVector(0, groundHeight), camPos);
  line(0, groundPos.y, width, groundPos.y);

  text("onGround: "+onGround, 10, 20);
  text("pos: "+pos.x+", "+pos.y, 10, 35);
  text("vel: "+vel.x+", "+vel.y, 10, 50);
  text("frameRate: "+frameRate, 10, 65);

  for (int i = 0; i< knifes.size(); i++) {
    knifes.get(i).update(camPos, framesElapsed);
    for (int j = 0; j < obstacles.size(); j++) {
      knifes.get(i).checkCollision(obstacles.get(j), framesElapsed);
    }
  }
  stroke(#000000);
  
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
  } else if (key == 'w' && !shootPressed) {
    if (knifes.size() > 1 ) {
      knifes.remove(0);
    }
    PVector knifePos = pos.copy();
    knifePos.y += playerHeight/2;
    knifePos.x += playerHeight/2;
    knifes.add(new Knife(knifePos, shootingLeft? shootSpeed:-1*shootSpeed));
    shootPressed = true;
  }
}

void keyReleased() {
  if (key == 'a') {
    aPressed = false;
  } else if (key == 'd') {
    dPressed = false;
  } else if (key == ' ') {
    spacePressed = false;
  } else if (key == 'w') {
    shootPressed = false;
  }
}
