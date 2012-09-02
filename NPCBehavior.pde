// File with mostly NPC behaviors.

float GRAVITY = 2000.00f;

class GravityBehavior implements Behavior {
  int last = 0;

  void update(Element e) {
    if (last == 0) {
      last = millis();
    }
    int current = millis();
    int delta = current - last;
    last = current;

    if (e.state == 2)  return;

    // Add Gravity.
    e.vy = e.vy + GRAVITY * delta / 1000.0;
  }
}

// Wrap from one side of the screen to other.
class WrapBehavior implements Behavior {
  void update (Element e) {
    if (e.state == 2)  return;

    Rect box = e.sprite.getCollisionBox();
    if (e.x + box.x2 < 0) {

      if (e.y >= 200) {
        // Inside the bottom pipe.
        // Respawn at the top.
        if (!e.group.equals("coin")) {
          playAudio(HIT_AUDIO);
          e.y = 40;
          e.x = VIEWPORT_WIDTH - 32;
        }
      } 
      else {
        e.x = VIEWPORT_WIDTH;
      }
    } 
    else if (e.x > VIEWPORT_WIDTH) {
      if (e.y >= 200) {
        // Inside the bottom pipe.
        // Respawn at the top.
        if (!e.group.equals("coin")) {
          playAudio(HIT_AUDIO);
          e.y = 40;
          e.x = 32;
        }
      } 
      else {
        e.x = -box.x2 + 1;
      }
    }
  }
}

class TileCollisionBehavior implements Behavior {
  void update(Element e) {
    if (e.state == 2)  return;

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

    int endY = ((int)(e.y + collisionBox.y2)) / tileHeight;
    int lastEndY = ((int)(e.lasty + collisionBox.y2)) / tileHeight;
    endY = max(endY, lastEndY);

    for (int i = startX; i <= endX; i++) {
      for (int j = startY; j <= endY; j++) {
        if ((collisionMap.getTile(DETAILS_LAYER, i, j) == 1) ||
          ((collisionMap.getTile(DETAILS_LAYER, i, j) == 2) && (e.group.equals("coin") || e.group.equals("turtle")))) {

          // Find direction of collision.
          /*
          float tx, ty;
           if (e.vx < 0) {
           // Time for left collision.
           tx = -(e.lastx + collisionBox.x1 - i * tileWidth) / e.vx; 
           } else if (e.vx > 0) {
           tx = -(e.lastx + collisionBox.x2 - i * tileWidth) / e.vx;
           } else {
           tx = 1000000; 
           }
           
           println("tx = " + tx); 
           
           if (tx < 0) {
           // already intersecting in x. Ignore x collision.
           tx = 1000000;
           }
           
           if (e.vy < 0) {
           // Time for left collision.
           ty = -(e.lasty + collisionBox.y1 - i * tileHeight) / e.vy; 
           } else if (e.vy > 0) {
           ty = -(e.lasty + collisionBox.y2 - i * tileHeight) / e.vy;
           } else {
           ty = 1000000; 
           }
           
           if (ty < 0) {
           // already intersecting in y. Ignore y collision
           ty = 1000000;
           }
           
           if (tx < ty) {
           if (e.vx < 0) { // Collision from right.
           e.x = (i + 1) * tileWidth + collisionBox.x1;
           if (_DEBUG) {
           println("Collision right");  
           }
           } else { // Collision from left.
           e.x = i * tileWidth - collisionBox.x2;
           if (_DEBUG) {
           println("Collision left");  
           }
           }
           e.vx = 0;
           } else {
           if (e.vy < 0) { // Collision from bottom.
           e.y = (j + 1) * tileHeight + collisionBox.y1;
           if (_DEBUG) {
           println("Collision bottom");  
           }
           } else { // Collision from left.
           e.y = j * tileHeight - collisionBox.y2;
           if (_DEBUG) {
           println("Collision up");  
           }
           }
           e.vy = 0;            
           }
           
           println("Setting " + e.x + ", " + e.y);
           */

          if (e.rot == 0) {
            e.y = j * tileHeight - collisionBox.y2;
          } 
          else {
            e.y = (j + 1) * tileHeight + collisionBox.y2;
          }
          e.vy = 0;
          //println("Setting " + e.x + ", " + e.y);
          break;
        }
      }
    }
  }
}

class DetectHitBehavior implements Behavior {
  Sprite lHitSprite, rHitSprite;

  DetectHitBehavior(Sprite lHitSprite, Sprite rHitSprite) {
    this.lHitSprite = lHitSprite; 
    this.rHitSprite = rHitSprite;
  }

  void update(Element e) {
    if (e.state == 2)  return;

    TileMap collisionMap = game.getTileMap();
    int tileWidth = collisionMap.tileWidth;
    int tileHeight = collisionMap.tileHeight;
    if (collisionMap.bumpFrames > 0) {
      // Check whether we are above any of bumped tiles.
      int bx = collisionMap.bumpX;
      int by = collisionMap.bumpY;

      for (int i = -3; i <= 3; i++) {
        int deltaY = collisionMap.getBump(i); 
        Rect r = new Rect((bx + i) * tileWidth, by * tileHeight - deltaY, (bx + i + 1) * tileWidth, (by + 1) * tileHeight - deltaY);
        if (checkCollision(e, e.sprite.getCollisionBox(), r)) {
          if (e.bumpId != collisionMap.bumpId) { // Don't hit/unhit on same bump.
            e.bumpId = collisionMap.bumpId;

            if (lHitSprite == null) { // Coin.
              game.score += 500;
              int index = game.coins.indexOf(e);
              if (index != -1) {
                game.coins.remove(index);
              }
            }
            else {
              if (e.state == 0) { 
                game.score += 10;
                e.state = 1; // Hit!!!
                playAudio(HIT_AUDIO);
                if (e.vx > 0) {
                  e.sprite = rHitSprite;
                } 
                else {
                  e.sprite = lHitSprite;
                }
              } 
              else {
                //playAudio(HIT_AUDIO);
                //e.state = 0; // Unhit!!!
              }
            } // Enemy.
          } // bumpId != bumpId
        } // checkCollision
      } // for
    } // bumpFrames > 0
  }

  boolean checkCollision(Element e, Rect r1, Rect r2) {
    float left1 = e.x + r1.x1;
    float right1 = e.x + r1.x2;
    float left2 = r2.x1;
    float right2 = r2.x2;

    if (right1 < left2) return false;
    if (right2 < left1) return false;

    float top1 = e.y + r1.y1;
    float bot1 = e.y + r1.y2;
    float top2 = r2.y1;
    float bot2 = r2.y2;

    if (bot1 < top2) return false;
    if (bot2 < top1) return false;

    return true;
  }
}

class RecoverBehavior implements Behavior {
  int start = 0;

  void update(Element e) {
    if (e.state == 1) {
      if (start == 0) {
        start = millis();
      } 
      else if (millis() - start > 40000) {
        // Reinstate turtle after X seconds
        playAudio(HIT_AUDIO);
        e.sprite.offset(0); 
        e.state = 0;
      } 
      else if (millis() - start > 30000) { 
        e.sprite.offset((millis() % 2) * 64);
      }
    } 
    else {
      start = 0;
    }
  }
}

class EnemyCollisionBehavior implements Behavior {
  String type;

  EnemyCollisionBehavior(String type) {
    this.type = type;
  }

  void update(Element e) {
    if (e.state == 2) return;

    if (e.y == 200 || e.y == 40) return; // Inside the pipe.

    Mario m = game.mario;
    if (checkCollision(e, e.sprite.getCollisionBox(), m, m.sprite.getCollisionBox(), m.rot)) {

      if (type.equals("enemy")) {
        if (e.state == 0) { // Mario Dies! if he is not invincible
          if (!m.invincible && !m.dying) {
            if (m.y < 80 && ((m.x < 32) || (m.x >= 200)))  {
              // Do nothin.
            } else {
              playAudio(TOUCH_AUDIO);
              m.dying = true;
              m.lives--; // Display Game ver here.
            }
          }
        } 
        else { //Turtle dies!
          //println("Turtle Dies");
          playAudio(HIT_AUDIO);
          e.state = 2; // Dying animation.
          game.score += 800;
        }
      } 
      else { // It's a coin
        game.score += 500;
        // Play sound.
        playAudio(COIN_AUDIO);

        // Remove the coin
        int index = game.coins.indexOf(e);
        if (index != -1) {
          game.coins.remove(index);
        }
      }
    }

    // Check interobject collision.
    int l;
    if (e.group.equals("coin")) {
      l = game.coins.indexOf(e);
    } 
    else {
      l = game.turtles.indexOf(e);
    }

    for (int i = 0; i < game.turtles.size(); i++) {
      // Only collide with indices less than yours to avoid duplicate collision.
      if (i > l) {
        break;
      }

      Turtle t = (Turtle) game.turtles.get(i);

      if (e != t) {
        if (checkCollision(e, e.sprite.getCollisionBox(), t, t.sprite.getCollisionBox(), 0)) {
          if (e.x <= t.x) {
            e.x = t.x - e.sprite.getCollisionBox().x2 - 1;
          } else {
            e.x =  t.x + t.sprite.getCollisionBox().x2 + 1;
          }
          e.vx = -e.vx;
          t.vx = -t.vx;
        }
      }
    }
    for (int i = 0; i < game.coins.size(); i++) {
      // Only collide with indices less than yours to avoid duplicate collision.
      if (i > l) {
        break;
      }

      Coin c = (Coin) game.coins.get(i);
      if (e != c) {
        if (checkCollision(e, e.sprite.getCollisionBox(), c, c.sprite.getCollisionBox(), 0)) {
          if (e.x <= c.x) {
            e.x = c.x - e.sprite.getCollisionBox().x2 - 1;
          } else {
            e.x =  c.x + c.sprite.getCollisionBox().x2 + 1;
          }
          e.vx = -e.vx;
          c.vx = -c.vx;
        }
      }
    }
  }

  boolean checkCollision(Element e1, Rect r1, Element e2, Rect r2, float rot) {
    float left1 = e1.x + r1.x1;
    float right1 = e1.x + r1.x2;
    float left2 = e2.x + r2.x1;
    float right2 = e2.x + r2.x2;

    if (right1 < left2) return false;
    if (right2 < left1) return false;

    float top1 = e1.y + r1.y1;
    float bot1 = e1.y + r1.y2;
    float top2 = e2.y + r2.y1;
    float bot2 = e2.y + r2.y2;
    
    if (rot == 180) {
      // Give upside Mario some space.
      bot2 -= 5; 
    }

    if (bot1 < top2) return false;
    if (bot2 < top1) return false;

    return true;
  }
}

class EnemyDieBehavior implements Behavior {
  void update(Element e) {
    if (e.state == 2) {
      if (e.y < VIEWPORT_HEIGHT) {
        e.y += 5;
        //println("die.y " + e.y);
      } 
      else {
        // Kill the turtle.
        int index = game.turtles.indexOf(e);
        if (index != -1) {
          game.turtles.remove(index);
        }
      }
    }
  }
}

