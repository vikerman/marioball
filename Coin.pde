class Coin extends Element {
  Sprite s;
  
  Coin(Sprite coinSprite, int ivx) {
    super(0, 0, 0, 0, 0, 0, null, "coin");
    y = 40;
    vy = 0;
    vx = ivx;
    if (vx > 0) {
      x = 8;
    } 
    else {
      x = VIEWPORT_WIDTH - 8;
    }
    sprite = coinSprite; 
    
    addBehavior(new GravityBehavior());
    addBehavior(new MoveBehavior(coinSprite, coinSprite));
    addBehavior(new TileCollisionBehavior());
    addBehavior(new WrapBehavior());
    addBehavior(new DetectHitBehavior(null, null));
    addBehavior(new EnemyCollisionBehavior("coin"));
  }
  
  
}
