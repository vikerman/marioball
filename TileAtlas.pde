class TileAtlas {
  PImage image;
 
  PGraphics buffer, rotImage; // Buffers for tile rotation.

  TileAtlas(String imageName) {
    image = loadImage(imageName);
    
    buffer = createGraphics(8, 8, JAVA2D);
    rotImage = createGraphics(8, 8, JAVA2D);
  }

  void draw(PGraphics context, int tile, int screenX, int screenY, int tileWidth, int tileHeight, int mode) {
    tile--; // Convert to zero based index.

    if ((tile < 0) || (screenX + tileWidth < 0)) {
      return;
    }
    
    int width = image.width / tileWidth;
    int srcX = (tile % width) * tileWidth;
    int srcY = (tile / width) * tileHeight;

    // Work around stupid bug inm Processing where it can't handle offscreen dstX and dstY.
    int copyWidth = tileWidth;
    if (screenX < 0) {
      copyWidth += screenX;
      srcX -= screenX; 
      screenX = 0;
    }
    int copyHeight = tileHeight;
    if (screenY < 0) {
      copyHeight += screenY;
      srcY -= screenY; 
      screenY = 0;
    }

    if (mode == BLEND) {
      context.blend(image, srcX, srcY, copyWidth, copyHeight, screenX, screenY, copyWidth, copyHeight, BLEND);
    } else {
      context.copy(image, srcX, srcY, copyWidth, copyHeight, screenX, screenY, copyWidth, copyHeight);
    }
  }
}
