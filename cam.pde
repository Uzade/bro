class Camera {
  PVector camPos = new PVector(0, 0);
  PVector targetCamPos = new PVector(0, 0);
  long camTransitionStart = 0;
  float camSpeed = 15;
  KeyboardMgr kbdMgr;

  Camera(KeyboardMgr kbdMgr) {
    this.kbdMgr = kbdMgr;
    Runnable initiateTransition = () -> camTransitionStart = framesElapsed;
    kbdMgr.doOnKeyDownStroke('a', initiateTransition);
    kbdMgr.doOnKeyDownStroke('d', initiateTransition);
  }

  void update(PVector pos, PVector vel, boolean editorMode, long framesElapsed) {
    targetCamPos = pos.copy().sub(width/2, height/3*2);
    camPos.add(vel);
    if (shootingLeft) {
      targetCamPos.x += width/6;
    } else {
      targetCamPos.x -= width/6;
    }
    float t = (framesElapsed-camTransitionStart) / Config.camTransitionTime;
    t = constrain(t, 0, 1);
    // smoothstep
    float smooth = t * t * (3 - 2 * t);
    // smootherstep
    // float smooth = t * t * t * (t * (6*t - 15) + 10);
    if (editorMode) {
      if (kbdMgr.isKeyPressed('a')) {
        camPos.x -= camSpeed;
      }
      if (kbdMgr.isKeyPressed('w')) {
        camPos.y -= camSpeed;
      }
      if (kbdMgr.isKeyPressed('d')) {
        camPos.x += camSpeed;
      }
      if (kbdMgr.isKeyPressed('s')) {
        camPos.y += camSpeed;
      }
    } else {
      camPos.add(targetCamPos.copy().sub(camPos).mult(smooth));
    }
  }

  PVector worldToScreen(PVector wordCoord) {
    return wordCoord.copy().sub(camPos);
  }

  PVector screenToWorld(PVector screenCoord) {
    return screenCoord.copy().add(camPos);
  }
}
