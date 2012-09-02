// Base class for all game elements.
class Element {
  float x, y;
  float lastx, lasty;
  float vx, vy;
  float lastvx, lastvy;
  float ax = 0, ay = 0;
  float rot; // Rotation in degrees.
  
  int state; // Generic State string - Used for indicating current object state like - Idle, Running etc.
  Sprite sprite; // Current sprite.
  String group; // Indentify which group of elements this belongs to. Eg. "player", "enemy" 
  ArrayList behaviors;
  
  int bumpId;

  Element(int ix, int iy, int ivx, int ivy, float irot, int istate, Sprite isprite, String igroup) {
    x = ix;
    y = iy;
    lastx = ix;
    lasty = iy;
    vx = ivx;
    vy = ivy;
    rot = irot;
    state = istate;
    sprite = isprite;
    group = igroup;

    behaviors = new ArrayList();
  }

  void addBehavior(Behavior b) {
    behaviors.add(b);
  }

  void removeBehavior(Behavior b) {
    int index = behaviors.indexOf(b);
    if (index != -1) {
      behaviors.remove(index);
    }
  }

  void update() {
    // Update Sprite animation.
    sprite.update();

    // Go through all the behaviors and run them in order.
    for (int i = 0; i < behaviors.size(); i++) {
      Behavior b = (Behavior)behaviors.get(i);
      b.update(this);
    }
  }

  void draw() {
    // Draw the current sprite at the current position.
    pushMatrix();
    sprite.draw(x, y, rot);
    popMatrix();
  }
}
