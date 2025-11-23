class KeyboardMgr {
  HashMap<String, Boolean> keysPressed = new HashMap();
  HashMap<String, ArrayList<Runnable>> keyDownCallbacks = new HashMap();

  void onKeyPressed() {
    if (key == CODED) return;
    
    if (!isKeyPressed(key)) { // transition is in this frame
      var callbacks = keyDownCallbacks.get(""+key);
      if (callbacks != null) {
        for (Runnable callback : callbacks) {
          callback.run();
        }
      }
    }
    
    keysPressed.put("" + key, true);
  }

  void onKeyReleased() {
    if (key != CODED) {
      keysPressed.put("" + key, false);
    }
  }

  boolean isKeyPressed(char keyToCheck) {
    return keysPressed.getOrDefault(""+keyToCheck, false);
  }

  void doOnKeyDownStroke(char keyToCheck, Runnable callback) {
    ArrayList callbackList = keyDownCallbacks.get(""+keyToCheck);
    if(callbackList != null) {
      callbackList.add(callback);
      return;
    }
    callbackList = new ArrayList();
    callbackList.add(callback);
    keyDownCallbacks.put(""+keyToCheck, callbackList);
    
  }

  void debugPressedKeys() {
    println(keysPressed);
  }
}
