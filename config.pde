class Config {
  static final float acc = 1; // pixel/frame^2
  static final float gravity = 0.5; // pixel/frame^2
  static final float groundDrag = 0.85; // multiplier
  static final float jumpForce = 14; // pixel/frame
  static final float playerHeight = 80; // pixel
  static final float shootSpeed = 10; // in pixel/frame
  static final float groundHeight = 800; // pixel down from origin
  static final int walkAnimationSpeed = 5; // frames/image (higher is slower)
  static final int jumpAnimationDuration = 30; // frames
  static final float camTransitionTime = 240; // in frames
}
