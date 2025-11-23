class KeyboardMgr {
  HashMap<String, Boolean> keysPressed = new HashMap();
  HashMap<String, ArrayList<Runnable>> keyDownCallbacks = new HashMap();

  void onKeyPressed() {
    if (key == CODED) return;
    
    char keyUncased = (""+key).toLowerCase().charAt(0);
    
    if (!isKeyPressed(keyUncased)) { // transition is in this frame
      var callbacks = keyDownCallbacks.get(""+keyUncased);
      if (callbacks != null) {
        for (Runnable callback : callbacks) {
          callback.run();
        }
      }
    }
    
    keysPressed.put("" + keyUncased, true);
  }

  void onKeyReleased() {
    if (key != CODED) {
      keysPressed.put((""+key).toLowerCase(), false);
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
