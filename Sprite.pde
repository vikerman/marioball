// Sprite class.
class Sprite {
  TileAtlas tileAtlas;
  int tileWidth, tileHeight;
  int width, height; // In Tiles

  Layer layer;

  int numFrames;
  int[] frameTimes; // Cumulative time for which each frame should remain in the animation.
  int totalTime;
  int currentFrame;
  int frameWidth; // Width of each frame in tiles.

  // Collision rect per frame.
  Rect[] collision;
  
  // Buffers for rotation.
  PGraphics buffer, rotImage;
  int dim;
  int offsetTiles = 0;
  
  boolean blnk = false;
  boolean show = true;

  Sprite(PApplet p, String spriteMap, TileAtlas itileAtlas) {
    tileAtlas = itileAtlas;


    // Read in the Sprite Map
    if (_DEBUG) {
      println("Loading " + spriteMap);
    }
     
    XMLElement map = new XMLElement(p, spriteMap);
    width = map.getInt("width");
    height = map.getInt("height");

    tileWidth = map.getInt("tilewidth");
    tileHeight = map.getInt("tileheight");

    currentFrame = 0;

    int childCount = map.getChildCount();
    for (int i = 0; i < childCount;i++) {
      XMLElement child = map.getChild(i);
      if (child.getName().equals("layer")) {
        layer = new Layer(child);

        numFrames = int(layer.getProperty("frames"));
        frameWidth = width / numFrames;
        frameTimes = new int[numFrames];
        totalTime = 0;
        for (int j = 0; j < numFrames; j++) {
          int time = int(layer.getProperty("frame" + j));
          totalTime += time;
          frameTimes[j] = totalTime;
        }
      } 
      else if (child.getName().equals("objectgroup")) {
        // Collision boxes for each frame.
        int numCollisionBoxes = child.getChildCount();

        collision = new Rect[numCollisionBoxes];
        //println("numCollisionBoxes: " + numCollisionBoxes);

        for (int j = 0; j < numCollisionBoxes; j++) {
          XMLElement object = child.getChild(j);
          XMLElement polyline = object.getChild(0);

          String[] coords = split(polyline.getString("points"), " ");
          String[] top = split(coords[0], ",");
          String[] bottom = split(coords[1], ",");
          int x1 = int(top[0]); 
          int y1 = int(top[1]);
          int x2 = int(bottom[0]);
          int y2 = int(bottom[1]);

          collision[j] = new Rect(x1, y1, x2, y2);
        }
      }
    }
    
    buffer = createGraphics(width * tileWidth, height * tileHeight, JAVA2D);
    dim = max(frameWidth * tileWidth, height * tileHeight);
    rotImage = createGraphics(dim, dim, JAVA2D);
  }

  Rect getCollisionBox() {
    if (show) {
     return collision[currentFrame];
    } else {
     return new Rect(0,0,0,0); 
    }
  }

  void offset(int tiles) {
    this.offsetTiles = tiles;
  }

  void blink(boolean b) {
    this.blnk = b;
  }
  
  void hide() {
    this.show = false; 
  }

  void show() {
    this.show = true; 
  }

  void update() {
    // Set the current frame based on the millis().
    int time = millis() % totalTime;
    for (int i = 0; i < numFrames; i++) {
      if (time < frameTimes[i]) {
        currentFrame = i;
        break;
      }
    }
  }

  void draw(float x, float y, float rot) {
    //println("Drawing at " + x + ", " + y);
    
    if (!show) {
      return; 
    }
    
    if (blnk) {
      // Randomly skip drawing.
      if (millis() % 2 == 0) {
        return; 
      }
    }
    
    int dx = 0, dy = 0;
    for (int i = currentFrame * frameWidth; i < (currentFrame + 1) * frameWidth; i++) {
      for (int j = 0; j < height; j++) {
        //println("tileAtlas.draw(" + layer.getTile(i, j) + ", " + (x + dx) + ", " + (y + dy) + "," + tileWidth + ", " + tileHeight + ")");
        if (rot == 0) {
          tileAtlas.draw(context, layer.getTile(i, j) + offsetTiles, int(x) + dx, int(y) + dy, tileWidth, tileHeight, BLEND); 
        } else {
          buffer.beginDraw();
          buffer.background(0, 0, 0, 0);
          tileAtlas.draw(buffer, layer.getTile(i, j) + offsetTiles, dx, dy, tileWidth, tileHeight, BLEND);
          buffer.endDraw();
          
          rotImage.beginDraw();
          rotImage.background(0, 0, 0, 0);
          rotImage.translate(dim / 2, dim / 2);
          rotImage.rotate(-rot * PI / 180);
          rotImage.translate(-dim / 2, -dim / 2);
          rotImage.image(buffer, (dim - frameWidth * tileWidth) / 2, (dim - height * tileHeight) / 2);
          rotImage.endDraw();
          
          context.blend(rotImage, 0, 0, dim, dim, int(x), int(y), dim, dim, BLEND);
        } 
        dy += tileHeight;
      }     
      dx += tileWidth;
      dy = 0;
    }
  }
}

class Rect {
  int x1, y1, x2, y2;

  Rect(int x1, int y1, int x2, int y2) {
    //println("Creating Rect : " + x1 + ", " + y1 + " " + x2 + ", " + y2);
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }

 /*
  boolean collide(Rect other) {
    if (((x1 <= other.x1) && (x2 >= other.x1) && (x2 <= other.x2)) ||
      ((other.x1 <= x1) && (other.x2 >= x1) && (other.x2 <= x2))) {
      if (((y1 <= other.y1) && (y2 >= other.y1) && (y2 <= other.y2)) ||
        ((other.y1 <= y1) && (other.y2 >= y1) && (other.y2 <= y2))) {
        return true;
      }
    }
    return false;
  }
  */
}
