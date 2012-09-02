int MAX_MARIO = 5;

class Mario extends Element {

  int STARTX = 120;
  int STARTY = 200;
  int lives = MAX_MARIO;
  
  boolean dying = false;
  boolean invincible = false;

  ArrayList waypoints;

  Mario(Sprite[] sprites, Controller controller, POW pow) {
    super(0, 0, 0, 0, 0, 0, null, "mario");
    x =  STARTX;
    y = STARTY;
    vx = 0;
    vy = 0;
    sprite = sprites[MSPRITE_LEFT_IDLE];

    waypoints = new ArrayList();

    addBehavior(new ControllerBehavior(controller, pow));    
    addBehavior(new MarioMoveBehavior(sprites[MSPRITE_LEFT_IDLE], sprites[MSPRITE_LEFT_WALK], sprites[MSPRITE_RIGHT_IDLE], sprites[MSPRITE_RIGHT_WALK]));
    addBehavior(new MarioTileCollisionBehavior());
    addBehavior(new MarioDieBehavior(sprites[MSPRITE_CENTER_DIE]));
    addBehavior(new MarioLimitedInvinciibilityBehavior());
  }
  
  void addWaypoint(MPos pos) {
    // Check for duplicate position and don't add it.
    int size = waypoints.size();
    MPos p = (MPos)waypoints.get(size - 1);
    if ((p.x == pos.x) && (p.y == pos.y)) {
      println("Skipping duplicate waypoint.");
      return; 
    }
    waypoints.add(pos);
  }
  
  void update() {
    // Update Sprite animation.
    sprite.update();

    // Go through all the behaviors and run them in order.
    for (int i = 0; i < behaviors.size(); i++) {
      Behavior b = (Behavior)behaviors.get(i);
      //println(i + "vx = " + vx + " vy = " + vy);
      b.update(this);
    }
  }
}
 
int POW_BLOCK = 49;

MPos getTargetPosition(int m) {
  MPos p = new MPos(120, 224, 0, 0); 
  
  // Do some adhoc mappings.
  if (m == 49) {
    m = 21;
  }
  
  if (m == 15) {
    m = 49; 
  }
  
  if ((m >= 1) && (m <= 15)) {
    p.y = 224;
    p.x = (m - 1) / 14.0 * VIEWPORT_WIDTH;
    p.dir = MDOWN;
    p.level = 0;
  } 
  else if ((m >= 16) && (m <= 20)) {
    p.y = 184;
    p.x = (m - 16) / 4.0 * 88;
    p.dir = MUP;
    p.level = 1;
  } 
  else if (m == 21) {
    p.y = 192;
    p.x = 124;
    p.dir = MUP;
    p.level = 2;
  } 
  else if ((m >= 22) && (m <= 26)) {
    p.y = 184;
    p.x = 168 + (m - 22) / 4.0 * 88;
    p.dir = MUP;
    p.level = 1;
  } 
  else if ((m >= 27) && (m <= 31)) {
    p.y = 176;
    p.x = (m - 27) / 4.0 * 88;
    p.dir = MDOWN;
    p.level = 2;
  } 
  else if (m == 32) {
    p.y = 176;
    p.x = 124;
    p.dir = MDOWN;
    p.level = 3;
  } 
  else if ((m >= 33) && (m <= 37)) {
    p.y = 176;
    p.x = 168 + (m - 33) / 4.0 * 88;
    p.dir = MDOWN;
    p.level = 4;
  } 
  else if ((m >= 38) && (m <= 39)) {
    p.y = 144;
    p.x = (m - 38) / 1.0 * 32;
    p.dir = MUP;
    p.level = 5;
  } 
  else if ((m >= 40) && (m <= 45)) {
    p.y = 136;
    p.x = 64 + (m - 40) / 5.0 * 128;
    p.dir = MUP;
    p.level = 6;
  } 
  else if ((m >= 46) && (m <= 47)) {
    p.y = 144;
    p.x = 220 + (m - 46) / 1.0 * 32;
    p.dir = MUP;
    p.level = 7;
  } 
  else if ((m >= 48) && (m <= 49)) {
    p.y = 136;
    p.x = (m - 48) / 1.0 * 32;
    p.dir = MDOWN;
    p.level = 8;
  } 
  else if ((m >= 50) && (m <= 56)) {
    p.y = 128;
    p.x = 64 + (m - 50) / 6.0 * 128;
    p.dir = MDOWN;
    p.level = 9;
  } 
  else if ((m >= 57) && (m <= 58)) {
    p.y = 136;
    p.x = 220 + (m - 57) / 1.0 * 32;
    p.dir = MDOWN;
    p.level = 10;
  } 
  else if ((m >= 59) && (m <= 63)) {
    p.y = 88;
    p.x = (m - 59) / 4.0 * 104;
    p.dir = MUP;
    p.level = 11;
  } 
  else if ((m >= 64) && (m <= 68)) {
    p.y = 88;
    p.x = 152 + (m - 64) / 4.0 * 104;
    p.dir = MUP;
    p.level = 12;
  } 
  else if ((m >= 69) && (m <= 73)) {
    p.y = 80;
    p.x = (m - 69) / 4.0 * 104;
    p.dir = MDOWN;
    p.level = 13;
  } 
  else if ((m >= 74) && (m <= 78)) {
    p.y = 80;
    p.x = 152 + (m - 74) / 4.0 * 104;
    p.dir = MDOWN;
    p.level = 14;
  } 
  else if ((m >= 79) && (m <= 88)) {
    p.y = 8;
    p.x = (m - 79) / 9.0 * 240;
    p.dir = MUP;
    p.level = 15;
  } else if (m == 89) {
    p.y = 180;
    p.x = 100;
    p.dir = MUP;
    p.level = 16;
  } else if (m == 90) {
    p.y = 180;
    p.x = 152;
    p.dir = MUP;
    p.level = 17;
  } else if (m == 91) {
    p.y = 140;
    p.x = 40;
    p.dir = MUP;
    p.level = 18;
  } else if (m == 92) {
    p.y = 132;
    p.x = 52;
    p.dir = MUP;
    p.level = 19;
  } else if (m == 93) {
    p.y = 128;
    p.x = 196;
    p.dir = MUP;
    p.level = 18;
  } else if (m == 94) {
    p.y = 136;
    p.x = 212;
    p.dir = MUP;
    p.level = 19;
  }  else if (m == 95) {
    p.y = 80;
    p.x = 112;
    p.dir = MUP;
    p.level = 18;
  } else if (m == 96) {
    p.y = 80;
    p.x = 140;
    p.dir = MUP;
    p.level = 19;
  }

  //println("Mario pos: " + p.x + ", " + p.y);
  return p;
}


int MDOWN = 0;
int MUP = 1;

class MPos {
  float x, y;
  int dir;
  int level;

  MPos(float x, float y, int dir, int level) {
    this.x = x;
    this.y = y;
    this.dir = dir;
    this.level = 0;
  }
}

class FollowWaypointsBehavior implements Behavior {
  void update(Element e) {
    // See if we already reached a way point.
    Mario m = game.mario;
    
    if (m.waypoints.size() > 0) {
       
    }
  }
  
}
  
// Behavior to follow the controller
class ControllerBehavior implements Behavior {
  Controller controller;
  POW pow;
  int last = 0;
  
  // ACCELERATION SCALE FACTOR!!!
  int XF = 100;
  int YF = 100;

  ControllerBehavior(Controller controller, POW pow) {
    this.controller = controller;
    this.pow = pow;
  }

  void update(Element e) {
    int magnet = controller.getMagnet();
    float accelX = controller.getAccelX();
    float accelY = controller.getAccelY();

    if (last == 0) {
      last = millis();
    }
    int now = millis();
    int deltaT = now - last;
    last = now;

    if (game.mario.dying) return;

    e.ax = XF * accelX;
    if (Math.abs(e.ax) < 0.01) {
      e.ax = 0; 
    }
    if (Math.abs(e.ay) < 0.01) {
      e.ay = 0; 
    }
    
    e.ay = YF * accelY; 

    if (magnet > 0) {
      MPos p = getTargetPosition(magnet);
      if ((e.state != p.level) && (p.dir == MUP)) {
        // Bump!
        playAudio(JUMP_AUDIO);
        println("Bump");
        TileMap collisionMap = game.getTileMap();
        collisionMap.bump((int)p.x, (int)p.y - 8);
        
        if ((magnet == POW_BLOCK) && (pow.index < 2)) {
          pow.hit();
        }
      }
      e.state = p.level;

      Rect box = e.sprite.getCollisionBox();
      if (p.dir == MDOWN) {
        e.rot = 0;
        e.x = p.x;
        e.y = p.y - box.y2;
        if (e.vy > 0) {
          //e.vy = 0;
        }
      } 
      else {
        e.rot = 180;
        e.x = p.x;
        e.y = p.y - box.y1 + 4;
        if (e.vy < 0) {
          //e.vy = 0;
        }
      }
    }
  }
}


// Behavior to follow the controller
class ControllerBehavior2 implements Behavior {
  Controller controller;
  POW pow;
  int last = 0;
  
  ControllerBehavior2(Controller controller, POW pow) {
    this.controller = controller;
    this.pow = pow;
  }

  void update(Element e) {
    int magnet = controller.getMagnet();
    float accelX = controller.getAccelX();
    float accelY = controller.getAccelY();
    
    game.mario.addWaypoint(getTargetPosition(magnet));
  }
}


class MarioMoveBehavior implements Behavior {
  int last = 0;
  TileMap collisionMap;
  Sprite ileft, left, iright, right;
  int MAX_VEL = 100;

  MarioMoveBehavior(Sprite ileft, Sprite left, Sprite iright, Sprite right) {
    this.ileft = ileft;
    this.left = left;
    this.iright = iright;
    this.right = right;
  }

  void update(Element e) {
    if (last == 0) {
      last = millis();
    }
    int current = millis();
    int delta = current - last;
    last = current;

    if (game.mario.dying) return;
    
    // Update velocity.
    e.lastvx = e.vx;
    e.lastvy = e.vy;

    //println(": vx = " + e.vx + ", vy = " + e.vy);

    e.vx += e.ax * delta / 1000.0;
    e.vy += e.ay * delta / 1000.0;

    print("ax = " + e.ax + ", ay = " + e.ay);
    println(" vx = " + e.vx + ", vy = " + e.vy);

    if (e.vx > MAX_VEL) {
      e.vx = MAX_VEL; 
    }
    if (e.vx < -MAX_VEL) {
      e.vx = -MAX_VEL;
    }
      
    if (e.vy > MAX_VEL) {
      e.vy = MAX_VEL; 
    }
    if (e.vy < -MAX_VEL) {
      e.vy = -MAX_VEL;
    }
    
    // Update position.
    e.lastx = e.x;
    e.lasty = e.y;

    e.x += e.vx * delta / 1000.0;
    e.y += e.vy * delta / 1000.0;

    //println("deltaT " + delta);
    //println("m x = " + e.x + ", y = " + e.y); 

    Rect box = e.sprite.getCollisionBox();
    if (e.x < 0) {
      e.x = 0; 
    }
    
    if (e.x + box.x2 > VIEWPORT_WIDTH) {
       e.x = VIEWPORT_WIDTH - box.x2;
    }

    if (e.y < 0) {
      e.y = 0; 
    }
    
    if (e.y + box.y2 > VIEWPORT_HEIGHT) {
       e.y = VIEWPORT_WIDTH - box.y2;
    }

    // Update animation based on direction.
    //println("vx = " + e.vx);
    if (e.rot == 180) {
      if (e.ax < 0) {
        if (abs(e.vx) < 10) {
          e.sprite = iright;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = right;
        }
      } 
      else {
        if (abs(e.vx) < 10) {
          e.sprite = ileft;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = left;
        }
      }
    } 
    else {
      if (e.ax > 0) {
        if (abs(e.vx) < 10) {
          e.sprite = iright;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = right;
        }
      } 
      else {
        if (abs(e.vx) < 10) {
          e.sprite = ileft;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = left;
        }
      }
    }
    
    if (game.mario.invincible) {
      e.sprite.blink(true); 
    } else {
      e.sprite.blink(false);
    }

    // println("Moving to " + e.x + " " + e.y);
  }
}


class MarioMoveBehavior2 implements Behavior {
  int last = 0;
  TileMap collisionMap;
  Sprite ileft, left, iright, right;
  int MAX_VEL = 60;

  MarioMoveBehavior2(Sprite ileft, Sprite left, Sprite iright, Sprite right) {
    this.ileft = ileft;
    this.left = left;
    this.iright = iright;
    this.right = right;
  }

  void update(Element e) {
    if (last == 0) {
      last = millis();
    }
    int current = millis();
    int delta = current - last;
    last = current;

    if (game.mario.dying) return;
    
    // Update velocity.
    e.lastvx = e.vx;
    e.lastvy = e.vy;

    e.vx += e.ax * delta / 1000.0;
    e.vy += e.ay * delta / 1000.0;

    //print("ax = " + e.ax + ", ay = " + e.ay);
    //println(" vx = " + e.vx + ", vy = " + e.vy);

    if (e.vx > MAX_VEL) {
      e.vx = MAX_VEL; 
    }
    if (e.vx < -MAX_VEL) {
      e.vx = -MAX_VEL;
    }
      
    if (e.vy > MAX_VEL) {
      e.vy = MAX_VEL; 
    }
    if (e.vy < -MAX_VEL) {
      e.vy = -MAX_VEL;
    }
    
    // Update position.
    e.lastx = e.x;
    e.lasty = e.y;

    e.x += e.vx * delta / 1000.0;
    e.y += e.vy * delta / 1000.0;

    //println("deltaT " + delta);
    //println("x = " + e.x + ", y = " + e.y); 

    Rect box = e.sprite.getCollisionBox();
    if (e.x < 0) {
      e.x = 0; 
    }
    
    if (e.x + box.x2 > VIEWPORT_WIDTH) {
       e.x = VIEWPORT_WIDTH - box.x2;
    }

    if (e.y < 0) {
      e.y = 0; 
    }
    
    if (e.y + box.y2 > VIEWPORT_HEIGHT) {
       e.y = VIEWPORT_WIDTH - box.y2;
    }

    // Update animation based on direction.
    //println("vx = " + e.vx);
    if (e.rot == 180) {
      if (e.ax < 0) {
        if (abs(e.vx) < 10) {
          e.sprite = iright;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = right;
        }
      } 
      else {
        if (abs(e.vx) < 10) {
          e.sprite = ileft;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = left;
        }
      }
    } 
    else {
      if (e.ax > 0) {
        if (abs(e.vx) < 10) {
          e.sprite = iright;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = right;
        }
      } 
      else {
        if (abs(e.vx) < 10) {
          e.sprite = ileft;
        } else {
          playAudio(WALK_AUDIO);
          e.sprite = left;
        }
      }
    }
    
    if (game.mario.invincible) {
      e.sprite.blink(true); 
    } else {
      e.sprite.blink(false);
    }

    // println("Moving to " + e.x + " " + e.y);
  }
}


class MarioTileCollisionBehavior implements Behavior {
  
  
  void update(Element e) {
    if (game.mario.dying) return;
    
    TileMap collisionMap = game.getTileMap();
    int tileWidth = collisionMap.tileWidth;
    int tileHeight = collisionMap.tileHeight;

    // Get the collision tiles for the sprite.
    Sprite sprite = e.sprite;
    Rect collisionBox = sprite.getCollisionBox();

    // Check for each one of the tiles for collision.
    int startX = ((int)(e.x + collisionBox.x1)) / tileWidth;
    int lastStartX = ((int)(e.lastx + collisionBox.x1)) / tileWidth;
    startX = min(startX, lastStartX);

    int endX = ((int)(e.x + collisionBox.x2)) / tileWidth;
    int lastEndX = ((int)(e.lastx + collisionBox.x2)) / tileWidth;
    endX = max(endX, lastEndX);

    int startY = ((int)(e.y + collisionBox.y1)) / tileHeight;
    int lastStartY = ((int)(e.lasty + collisionBox.y1)) / tileHeight;
    startY = min(startY, lastStartY);

    int offset = 1;
    if (e.vy > 0) {
      offset = -1; 
    }

    int endY = ((int)(e.y + collisionBox.y2 - offset)) / tileHeight;
    int lastEndY = ((int)(e.lasty + collisionBox.y2 - offset)) / tileHeight;
    endY = max(endY, lastEndY);

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        if (collisionMap.getTile(DETAILS_LAYER, i, j) == 1) {
          doCollision(e, collisionBox, i * tileWidth, j * tileHeight, (i + 1) * tileHeight, (j + 1) * tileHeight);
          return;
        }
      }
    }
  }

  void doCollision(Element e, Rect box, int x1, int y1, int x2, int y2) {
    float tx = 10000, ty = 10000;
    if (e.vx > 0) {
      tx = (x1 - (e.lastx + box.x2)) / e.vx;
    } 
    else if (e.vx < 0) {
      tx = -(e.lastx + box.x1 - x2) / e.vx;
    }
    //println("tx = " + tx);

    if (e.vy > 0) {
      ty = (y1 - (e.lasty + box.y2)) / e.vy;
    } 
    else if (e.vy < 0) {
      ty = -(e.lasty + box.y1 - y2) / e.vy;
    }
    //println("vy = " + vy);
    //println("ty = " + ty);

    if (tx < 0) {
      tx = 10000;
    }
    if (ty < 0) {
      ty = 10000;
    }

    if (tx < ty) {
      if (e.vx > 0) {
        println("left");
        //x = lastx + vx * tx;
        //y = lasty + vy * tx;
        e.x = e.lastx;
        e.y = e.lasty;
        e.vx = 0;
      } 
      else {
        println("right");
        //x = lastx + vx * tx;
        //y = lasty + vy * tx;
        e.x = e.lastx;
        e.y = e.lasty;
        e.vx = 0;
      }
    } 
    else if (ty < tx) {
      if (e.vy > 0) {
        //println("top");
        //x = lastx + vx * ty;
        //y = lasty + vy * ty;
        //e.x = e.lastx;
        e.y = e.lasty;
        e.vy = 0;
      } 
      else {
        //println("bottom");
        //x = lastx + vx * ty;
        //y = lasty + vy * ty;
        //e.x = e.lastx;
        e.y = e.lasty;
        e.vy = 0;
      }
    }
    /*
          x = lastx;
     y = lasty;
     vx = -vx;
     vy = -vy * 4 / 5;
     */
     
     //println("Tile x: " + e.x + " y: " + e.y);
  }
}

class MarioDieBehavior implements Behavior {
 Sprite die;
 int start = 0;
 
 MarioDieBehavior(Sprite die) {
   this.die = die; 
 }
 
 void update(Element e) {
   if (game.mario.dying) {
     e.sprite = die;
     playAudio(DIE_AUDIO);
     
     if (start == 0) {
       start = millis(); 
     }
     
     if (millis() - start < 200) {
       e.y -= 5; 
     } else if (millis() - start < 400) {
        // Pause
     }
     else if (e.y < VIEWPORT_HEIGHT) {
       e.y += 5;
       //println("die.y " + e.y);
     } else {
       // Respawn with limited invincibility.
       game.mario.dying = false;
       game.mario.invincible = true;
     }
   } else {
     start = 0; 
   }
 }
}


class MarioLimitedInvinciibilityBehavior implements Behavior {

 int start = 0;
  
 void update(Element e) {
   if (game.mario.invincible) {
     if (start == 0) {
      start = millis();
     } else if (millis() - start > 5000) {
       game.mario.invincible = false;
     }
   } else {
     start = 0; 
   }
 }
}
