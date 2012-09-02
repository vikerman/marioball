int BASE_LAYER = 0;
int DETAILS_LAYER = 1;

class TileMap {
  int tileWidth, tileHeight;
  int width, height; // Map width and height in tiles.

  int numLayers;
  Layer[] layers;

  TileAtlas tileAtlas;
  int bumpX = 0, bumpY = 0;
  int bumpFrames = 0;
  int bumpId = 0;

  TileMap(PApplet p, String tmx, TileAtlas tiles) {
    // Load the TMX XML document.
    XMLElement map = new XMLElement(p, tmx);
    width = map.getInt("width");
    height = map.getInt("height");

    tileWidth = map.getInt("tilewidth");
    tileHeight = map.getInt("tileheight");

    // Count the number of layers.
    numLayers = 0;
    int childCount = map.getChildCount();
    for (int i = 0; i < childCount; i++) { 
      XMLElement child = map.getChild(i);
      if (child.getName().equals("layer")) {
        numLayers++;
      }
    }

    // Load the actual layers data.
    layers = new Layer[numLayers];
    int j = 0;
    for (int i = 0; i < childCount;i++) {
      XMLElement child = map.getChild(i);
      if (child.getName().equals("layer")) {
        layers[j++] = new Layer(child);
      }
    }

    tileAtlas = tiles;
  }
  
  void bump(int x, int y) {
     bumpX = x / tileWidth;
     bumpY = y / tileHeight;
     bumpFrames = 20;
     bumpId++;
  }

  int getTile(int layer, int x, int y) {
    if ((layer >= 0) && (layer < numLayers)) {
      return layers[layer].getTile(x, y);
    } 
    else {
      return 0;
    }
  }

  int getBump(int i) {
    return bumpFrames * 2 / (4 + abs(i));
  }

  // Draw out the drawable layer of the tile map.
  void draw() {
    int x = 0, y = 0;
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        int deltaY = 0;
        if ((bumpFrames > 0) && (abs(i - bumpX) < 4) && (j == bumpY)) {
          //context.fill(256, 0, 0, 128);
          //context.rect(bumpX * tileWidth, bumpY * tileHeight, tileWidth, tileHeight);
          //println("bumpx " + bumpX + "bumpy " + bumpY);
          deltaY = getBump(i - bumpX);
        } 
        tileAtlas.draw(context, getTile(BASE_LAYER, i, j), x, y - deltaY, tileWidth, tileHeight, OVERLAY);
        y += tileHeight;
      }
      y = 0;
      x += tileWidth;
    }
    if (bumpFrames > 0) {
      bumpFrames--; 
    }
  }
}

class Layer {
  int width, height; // In tiles.
  HashMap properties;
  int[][] tiles;

  Layer(XMLElement layer) {
    // Get the height and the width.
    width = layer.getInt("width");
    height = layer.getInt("height");

    properties = new HashMap();

    // Init tiles array.
    tiles = new int[width][height];

    // Load the layer data.
    for (int i = 0; i < layer.getChildCount(); i++) {
      XMLElement child = layer.getChild(i);
      if (child.getName().equals("properties")) {
        int numProperties =  child.getChildCount();
        for (int j = 0; j < numProperties; j++) {
          XMLElement property = child.getChild(j);
          properties.put(property.getString("name"), property.getString("value"));
        }
      } 
      else if (child.getName().equals("data")) {
        int numTiles = child.getChildCount();
        for (int j = 0; j < numTiles; j++) {
          XMLElement tile = child.getChild(j);

          int x = j % width;
          int y = j / width;

          tiles[x][y] = tile.getInt("gid");

          if (_DEBUG) {
            println("Adding tile " + tiles[x][y] + " at " + x + ", " + y);
          }
        }
      }
    }
  }

  String getProperty(String name) {
    return (String)properties.get(name);
  }

  int getTile(int x, int y) {
    if ((x >= 0) && (x < width) && (y >= 0) && (y < height)) {
      return tiles[x][y];
    } 
    else {
      return 0;
    }
  }
}

