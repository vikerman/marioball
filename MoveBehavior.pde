class MoveBehavior implements Behavior {
  int last = 0;
  TileMap collisionMap;
  Sprite left, right;

  MoveBehavior(Sprite left, Sprite right) {
    this.left = left;
    this.right = right;
  }

  void update(Element e) {    
    if (last == 0) {
      last = millis();
    }
    int current = millis();
    int delta = current - last;
    last = current;

    if (e.state != 0) { // Don't move on hit or die state
      return; 
    }

    // Update velocity.
    e.lastvx = e.vx;
    e.lastvy = e.vy;
    
    e.vx += e.ax * (delta) / 1000;
    e.vy += e.ay * (delta) / 1000;
    
    // Update position.
    e.lastx = e.x;
    e.lasty = e.y;
    
    e.x += e.vx * (delta) / 1000;
    e.y += e.vy * (delta) / 1000;

    // Update animation based on direction.
    if (e.vx > 0) {
      e.sprite = right;
    } 
    else {
      e.sprite = left;
    }
    
    //println("Moving to " + e.x + " " + e.y);
  }
}

