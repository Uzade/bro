
float acc = 1;
float gravity = 0.5;
float groundDrag = 0.85;
float jumpForce = 14;

boolean onGround = false;

float shootSpeed = 10;

float groundHeight;

PVector pos = new PVector(40, 40);
PVector vel = new PVector(0, 0);

PVector camPos = new PVector(0,0);
PVector targetCamPos = new PVector(0,0);
PVector obsPos = new PVector(400, 400);

boolean aPressed = false;
boolean dPressed = false;
boolean shootPressed = false;
boolean spacePressed = false;

float playerHeight = 80;

boolean shootingLeft = true;

ArrayList<Knife> knifes = new ArrayList<Knife>();

void render() {
  background(#761C1C);
  PVector posScreen = Util.worldToScreen(pos, camPos);
  rect(posScreen.x, posScreen.y, playerHeight, playerHeight);
  
  PVector obsScreen = Util.worldToScreen(obsPos, camPos);
  rect(obsScreen.x, obsScreen.y, 150, 400);
  
  PVector groundPos = Util.worldToScreen(new PVector(0, groundHeight), camPos);
  line(0, groundPos.y, width, groundPos.y);
  
  text("onGround: "+onGround, 10, 20);
  text("pos: "+pos.x+", "+pos.y, 10, 35);
  
  for(int i = 0; i< knifes.size(); i++){
    knifes.get(i).update(camPos);
    knifes.get(i).checkCollision(400, 400, 150, 400);
  }
}

boolean rectRect(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
  return (r1x + r1w >= r2x &&    // r1 right edge past r2 left
      r1x <= r2x + r2w &&    // r1 left edge past r2 right
      r1y + r1h >= r2y &&    // r1 top edge past r2 bottom
      r1y <= r2y + r2h);
}


void setup () {
  size(1500, 900);
  groundHeight = height-100;
}

void draw() {

  onGround = pos.y >= (groundHeight -playerHeight);
  
  for(int i = 0; i< knifes.size(); i++){
    Knife knife = knifes.get(i);
    
    if(!knife.collidable) continue;
    PVector collisionKnife = Util.collide( pos.x, pos.y, playerHeight, playerHeight, knife.pos.x, knife.pos.y, knife.knifeWidth, knife.knifeHeight);
    if(collisionKnife.y < 0) {
      onGround = true;
    } else if(collisionKnife.mag() > 0) {
      while(collisionKnife.mag() > 0){
        pos.add(collisionKnife);
      collisionKnife = Util.collide( pos.x, pos.y, playerHeight, playerHeight, knife.pos.x, knife.pos.y, knife.knifeWidth, knife.knifeHeight);
    }
    }
  }
  PVector collisionDirection = Util.collide( pos.x, pos.y, playerHeight, playerHeight, 400, 400, 150, 400);
  if(collisionDirection.y < 0) {
    onGround = true;
  } else if(collisionDirection.mag() > 0) {
    while(collisionDirection.mag() > 0){
      pos.add(collisionDirection);
      collisionDirection = Util.collide( pos.x, pos.y, playerHeight, playerHeight, 400, 400, 150, 400);
    }
  }
  
  if (!onGround) {
    vel.y += gravity;
  } else {
    vel.y = 0;
    
  }

  vel.x *= groundDrag;
  if(vel.x > 0) {
   shootingLeft =true; 
  } else if( vel.x <0) {
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

  targetCamPos = pos.copy().sub(width/2, height/3*2);
  camPos.add(vel);
  if(shootingLeft) {
   targetCamPos.x += width/6; 
  } else {
   targetCamPos.x -= width/6; 
  }
  print(camPos);
  print(targetCamPos);
  println(targetCamPos.copy().sub(camPos));
  camPos.add(targetCamPos.copy().sub(camPos).mult(0.03));
  render();
}

void keyPressed() {
  if (key == 'a') {
    aPressed = true;
  } else if (key == 'd') {
    dPressed = true;
  } else if (key == ' ') {
    spacePressed = true;
  } else if(key == 'w' && !shootPressed) {
    if(knifes.size() > 1 ){
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
  } else if(key == 'w') {
    shootPressed = false;
  }
}
