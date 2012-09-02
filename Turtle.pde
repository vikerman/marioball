int TRUN = 0;
int THIT = 1;

class Turtle extends Element {

  Sprite[] sprites;
  
  Turtle(Sprite[] sprites, int ivx) {
    super(0, 0, 0, 0, 0, 0, null, "turtle");
    this.sprites = sprites;
    y = 40;
    vy = 0;
    int spriteIndex;
    vx = ivx;
    if (ivx > 0) {
      x = 24;
      spriteIndex = TSPRITE_LEFT_WALK;
    } 
    else {
      x = VIEWPORT_WIDTH - 24;
      spriteIndex = TSPRITE_RIGHT_WALK;
    }
    sprite = sprites[spriteIndex]; 
    playAudio(HIT_AUDIO);
    
    addBehavior(new GravityBehavior());
    addBehavior(new MoveBehavior(sprites[TSPRITE_LEFT_WALK], sprites[TSPRITE_RIGHT_WALK]));
    addBehavior(new TileCollisionBehavior());
    addBehavior(new WrapBehavior());
    addBehavior(new DetectHitBehavior(sprites[TSPRITE_LEFT_FLIP], sprites[TSPRITE_RIGHT_FLIP]));
    addBehavior(new RecoverBehavior());
    addBehavior(new EnemyCollisionBehavior("enemy"));
    addBehavior(new EnemyDieBehavior());
  }
  
  void flip() {
    sprite = sprites[TSPRITE_LEFT_FLIP];
  }
}
