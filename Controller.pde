class Controller {
  int magnet, lastMagnet;
  float accelX, accelY; 

  // Simulation fields.
  boolean sim = true;
  int dir; 
  int last = 0;
  Ball ball;

  Controller(Ball ball) {
    magnet = 0;
    lastMagnet = 0;
    accelX = 0;
    accelY = 0;

    dir = -1;
    last = 0;
    this.ball = ball;
  }

  void update() {
    /*
    if (last == 0) {
     last = millis();
     } 
     int now = millis();
     if (now - last > 100) {
     if ((magnet == 1) || (magnet == 80)) {
     dir =-dir;
     }
     
     magnet += dir;
     last = now;
     println("Magnet " + magnet);
     }
     */

    if (SIM) {
      accelX = (int)ball.ax / 120;
      accelY = (int)ball.ay / 120;

      // Map ball's position to the switch numbers
      magnet = ball.activeMagnet + 1;
    } else {
       readController(this);
    }
  }

  int getMagnet() {
    return magnet;
  }

  float getAccelX() {
    return accelX;
  }

  float getAccelY() {
    return accelY;
  }
}

class Ball {
  float x, y;
  float lastx, lasty;
  float vx, vy;
  int r;
  float ax, ay;

  int last = 0;

  float ACCEL = 240;
  float RST = 0.1; // Restitution.
  POW pow;
  
  int NUM_MAGNETS = 96;
  Rect[] magnets;
  int activeMagnet = -1;

  Ball(POW pow) {
    this.pow = pow;
    this.x = 120;
    this.y = 210;
    this.lastx = x;
    this.lasty = y;
    this.r = 4;

    this.vx = 0;
    this.vy = 0;
    generateMagnetPoints();
  } 
  
  void generateMagnetPoints() {
    magnets = new Rect[NUM_MAGNETS];
    for (int i = 1; i <= NUM_MAGNETS; i++) {
      MPos p = getTargetPosition(i);
      
      // Create a small magnet area.
      if (p.dir == MDOWN) {
        magnets[i - 1] = new Rect((int)p.x, (int)p.y - 8, (int)p.x + 2, (int)p.y);
      } else {
        magnets[i - 1] = new Rect((int)p.x, (int)p.y, (int)p.x + 2, (int)p.y + 8);
      } 
    } 
  }

  void update() {
    if (last == 0) {
      last = millis();
    }

    int now = millis();
    int deltaT = now - last;
    last = now;

    if (K_UP) {
      if (ay == ACCEL) {
        ay = 0;
      } 
      else {
        ay = -ACCEL;
      }
    } 
    else if (K_DOWN) {
      if (ay == -ACCEL) {
        ay = 0;
      } 
      else {
        ay = ACCEL;
      }
    }  
    else if (K_LEFT) {
      if (ax == ACCEL) {
        ax = 0;
      } 
      else {
        ax = -ACCEL;
      }
    }  
    else if (K_RIGHT) {
      if (ax == -ACCEL) {
        ax = 0;
      } 
      else {
        ax = ACCEL;
      }
    }

    lastx = x;
    lasty = y;
    x += vx * deltaT / 1000;
    y += vy * deltaT / 1000;

    vx += ax * deltaT / 1000;
    vy += ay * deltaT / 1000;

    if (x - r <= 0) {
      x = r; 
      vx = -vx * RST;
    } 
    else if (x + r >= VIEWPORT_WIDTH) {
      x = VIEWPORT_WIDTH - r;
      vx = -vx * RST;
    }

    if (y - r <= 0) {
      y = r; 
      vy = -vy * RST;
    } 
    else if (y + r >= VIEWPORT_HEIGHT) {
      y = VIEWPORT_HEIGHT - r;
      vy = -vy * RST;
    }

    // Check Collision with blocks.
    TileMap collisionMap = game.getTileMap();
    int tileWidth = collisionMap.tileWidth;
    int tileHeight = collisionMap.tileHeight;

    int startX = ((int)(x - r)) / tileWidth;
    int lastStartX = ((int)(lastx - r)) / tileWidth;
    startX = min(startX, lastStartX);

    int endX = ((int)(x + r)) / tileWidth;
    int lastEndX = ((int)(lastx + r)) / tileWidth;
    endX = max(endX, lastEndX);

    int startY = ((int)(y - r)) / tileHeight;
    int lastStartY = ((int)(lasty - r)) / tileHeight;
    startY = min(startY, lastStartY);

    int endY = ((int)(y + r)) / tileHeight;
    int lastEndY = ((int)(lasty + r)) / tileHeight;
    endY = max(endY, lastEndY);

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        if (collisionMap.getTile(DETAILS_LAYER, i, j) == 1) {
          doCollision(i * tileWidth, j * tileHeight, (i + 1) * tileHeight, (j + 1) * tileHeight);
          return;
        }
      }
    }

    // Check collision with POW block.
    Rect box = pow.sprite.getCollisionBox();
    if (checkCollision(pow.x, pow.y, box)) {
      doCollision((int)(pow.x + box.x1), (int)(pow.y + box.y1), (int)(pow.x + box.x2), (int)(pow.y + box.y2));
    }
    
    // Check collision with all the magnet switches.
    activeMagnet = -1;
    for (int i = 0; i < NUM_MAGNETS; i++) {
      if (checkCollision(0, 0, magnets[i])) {
        activeMagnet = i;
        break; 
      }
    }
  }

  boolean checkCollision(float x2, float y2, Rect box) {
    float left1 = x - r;
    float right1 = x + r;
    float left2 = x2 + box.x1;
    float right2 = x2 + box.x2;
    
    if (right1 < left2) return false;
    if (right2 < left1) return false;

    float top1 = y - r;
    float bot1 = y + r;
    float top2 = y2 + box.y1;
    float bot2 = y2 + box.y2;
    
    if (bot1 < top2) return false;
    if (bot2 < top1) return false;

    //println("POW!!");
    return true;        
  }

  void doCollision(int x1, int y1, int x2, int y2) {
    float tx = 10000, ty = 10000;
    if (vx > 0) {
      tx = (x1 - (lastx + r)) / vx;
    } 
    else if (vx < 0) {
      tx = -(lastx - r - x2) / vx;
    }
    //println("tx = " + tx);

    if (vy > 0) {
      ty = (y1 - (lasty + r)) / vy;
    } 
    else if (vy < 0) {
      ty = -(lasty - r - y2) / vy;
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
      if (vx > 0) {
        //println("left");
        //x = lastx + vx * tx;
        //y = lasty + vy * tx;
        x = lastx;
        y = lasty;
        vx = -vx * RST;
      } 
      else {
        //println("right");
        //x = lastx + vx * tx;
        //y = lasty + vy * tx;
        x = lastx;
        y = lasty;
        vx = -vx * RST;
      }
    } 
    else if (ty < tx) {
      if (vy > 0) {
        //println("top");
        //x = lastx + vx * ty;
        //y = lasty + vy * ty;
        //x = lastx;
        y = lasty;
        vy = -vy * RST;
      } 
      else {
        //println("bottom");
        //x = lastx + vx * ty;
        //y = lasty + vy * ty;
        //x = lastx;
        y = lasty;
        vy = -vy * RST;
      }
    }


    /*
          x = lastx;
     y = lasty;
     vx = -vx;
     vy = -vy * 4 / 5;
     */
  }

  void draw() {
    for (int i = 0; i < NUM_MAGNETS; i++) {
       //if ((i < 46) || (i > 47)) continue;
       if (i == activeMagnet) { 
         context.fill(0, 0, 100, 256);
       } else {
         context.fill(100, 0, 0, 256);
       }
       //context.rect(magnets[i].x1, magnets[i].y1, (magnets[i].x2 - magnets[i].x1), (magnets[i].y2 - magnets[i].y1));
       //context.text("" + (i + 1), magnets[i].x1, magnets[i].y1, 20, 20);
    }
    
    context.fill(153, 128);
    context.ellipse(x, y, r * 2, r * 2);
  }
}

