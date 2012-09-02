// Mario Sprites
Sprite[] MarioSprites;
int MSPRITE_LEFT_IDLE = 0;
int MSPRITE_RIGHT_IDLE = 1;
int MSPRITE_LEFT_WALK = 2;
int MSPRITE_RIGHT_WALK = 3;
int MSPRITE_LEFT_FLY = 4;
int MSPRITE_RIGHT_FLY = 5;
int MSPRITE_LEFT_STOP = 6;
int MSPRITE_RIGHT_STOP = 7;
int MSPRITE_LEFT_DIE = 8;
int MSPRITE_RIGHT_DIE = 9;
int MSPRITE_CENTER_DIE = 10;
int MSPRITE_MAX = 11;

// Turtle Sprites
Sprite[] TurtleSprites;
int TSPRITE_LEFT_IDLE = 0;
int TSPRITE_RIGHT_IDLE = 1;
int TSPRITE_LEFT_WALK = 2;
int TSPRITE_RIGHT_WALK = 3;
int TSPRITE_LEFT_FLIP = 4;
int TSPRITE_RIGHT_FLIP = 5;
int TSPRITE_MAX = 6;

// Crab Sprites
Sprite[] CrabSprites;
int CSPRITE_LEFT_IDLE = 0;
int CSPRITE_RIGHT_IDLE = 1;
int CSPRITE_LEFT_WALK = 2;
int CSPRITE_RIGHT_WALK = 3;
int CSPRITE_LEFT_FLIP = 4;
int CSPRITE_RIGHT_FLIP = 5;
int CSPRITE_MAX = 6;

// Fire Sprites
Sprite[] FireSprites;
int FSPRITE_RSTART = 0;
int FSPRITE_GSTART = 1;
int FSPRITE_RLEFT_MOVE = 2;
int FSPRITE_RRIGHT_MOVE = 3;
int FSPRITE_GLEFT_MOVE = 4;
int FSPRITE_GRIGHT_MOVE = 5;
int FSPRITE_MAX = 6;

// Coin
Sprite CoinSprite;

// POW
Sprite[] POWSprites;

// Scores
Sprite ScoreSprite;

// Lives
Sprite LifeSprite;

Sprite GameOverSprite;

Sprite BonusSprite;

class Game {
  TileAtlas tileAtlas;
  TileMap tileMap;

  Score pscore;
  Score hscore;
  Life life;
  Ball ball;  
  Controller controller;
  Level lvl;
  Mario mario;
  //EnemyCreator enemies;
  ArrayList turtles = new ArrayList();
  ArrayList coins = new ArrayList();
  POW pow;
  GameOver over;
  
  int score = 0;
  int highScore;

  int delay = 0; // Delay for displaying game over / Phase sign
  boolean gameOver = false;

  void loadSprites(PApplet p) {
    
    // Mario
    MarioSprites = new Sprite[MSPRITE_MAX];
    MarioSprites[MSPRITE_LEFT_IDLE] = new Sprite(p, "mario-left-idle.tmx", tileAtlas);
    MarioSprites[MSPRITE_RIGHT_IDLE] = new Sprite(p, "mario-right-idle.tmx", tileAtlas);
    MarioSprites[MSPRITE_LEFT_WALK] = new Sprite(p, "mario-left-walk.tmx", tileAtlas);
    MarioSprites[MSPRITE_RIGHT_WALK] = new Sprite(p, "mario-right-walk.tmx", tileAtlas);
    MarioSprites[MSPRITE_LEFT_FLY] = new Sprite(p, "mario-left-fly.tmx", tileAtlas);
    MarioSprites[MSPRITE_RIGHT_FLY] = new Sprite(p, "mario-right-fly.tmx", tileAtlas);
    MarioSprites[MSPRITE_LEFT_STOP] = new Sprite(p, "mario-left-stop.tmx", tileAtlas);
    MarioSprites[MSPRITE_RIGHT_STOP] = new Sprite(p, "mario-right-stop.tmx", tileAtlas);
    MarioSprites[MSPRITE_LEFT_DIE] = new Sprite(p, "mario-left-die.tmx", tileAtlas);
    MarioSprites[MSPRITE_RIGHT_DIE] = new Sprite(p, "mario-right-die.tmx", tileAtlas);
    MarioSprites[MSPRITE_CENTER_DIE] = new Sprite(p, "mario-center-die.tmx", tileAtlas);
    
    // Turtle
    TurtleSprites = new Sprite[TSPRITE_MAX];
    TurtleSprites[TSPRITE_LEFT_IDLE] = new Sprite(p, "turtle-left-idle.tmx", tileAtlas);
    TurtleSprites[TSPRITE_RIGHT_IDLE] = new Sprite(p, "turtle-right-idle.tmx", tileAtlas);
    TurtleSprites[TSPRITE_LEFT_WALK] = new Sprite(p, "turtle-left-walk.tmx", tileAtlas);
    TurtleSprites[TSPRITE_RIGHT_WALK] = new Sprite(p, "turtle-right-walk.tmx", tileAtlas);
    TurtleSprites[TSPRITE_LEFT_FLIP] = new Sprite(p, "turtle-left-flip.tmx", tileAtlas);
    TurtleSprites[TSPRITE_RIGHT_FLIP] = new Sprite(p, "turtle-right-flip.tmx", tileAtlas);

    // Crab
    CrabSprites = new Sprite[CSPRITE_MAX];
    CrabSprites[CSPRITE_LEFT_IDLE] = new Sprite(p, "crab-run.tmx", tileAtlas);
    CrabSprites[CSPRITE_RIGHT_IDLE] = new Sprite(p, "crab-run.tmx", tileAtlas);
    CrabSprites[CSPRITE_LEFT_WALK] = new Sprite(p, "crab-run.tmx", tileAtlas);
    CrabSprites[CSPRITE_RIGHT_WALK] = new Sprite(p, "crab-run.tmx", tileAtlas);
    CrabSprites[CSPRITE_LEFT_FLIP] = new Sprite(p, "crab-flip.tmx", tileAtlas);
    CrabSprites[CSPRITE_RIGHT_FLIP] = new Sprite(p, "crab-flip.tmx", tileAtlas);

    // Fire
    FireSprites = new Sprite[FSPRITE_MAX];
    FireSprites[FSPRITE_RSTART] = new Sprite(p, "rfire-start.tmx", tileAtlas);
    FireSprites[FSPRITE_GSTART] = new Sprite(p, "gfire-start.tmx", tileAtlas);
    FireSprites[FSPRITE_RLEFT_MOVE] = new Sprite(p, "rfire-left-move.tmx", tileAtlas);
    FireSprites[FSPRITE_RRIGHT_MOVE] = new Sprite(p, "rfire-right-move.tmx", tileAtlas);
    FireSprites[FSPRITE_GLEFT_MOVE] = new Sprite(p, "gfire-left-move.tmx", tileAtlas);
    FireSprites[FSPRITE_GRIGHT_MOVE] = new Sprite(p, "gfire-right-move.tmx", tileAtlas);

    // Coin
    CoinSprite = new Sprite(p, "coin-flip.tmx", tileAtlas);
    
    // POW
    POWSprites = new Sprite[3];
    POWSprites[0] =  new Sprite(p, "pow1.tmx", tileAtlas);
    POWSprites[1] =  new Sprite(p, "pow2.tmx", tileAtlas);
    POWSprites[2] =  new Sprite(p, "pow3.tmx", tileAtlas);
    
    // Score
    ScoreSprite = new Sprite(p, "score.tmx", tileAtlas);
    
    // Life Sprite
    LifeSprite = new Sprite(p, "lives.tmx", tileAtlas);
    
    GameOverSprite = new Sprite(p, "gameover.tmx", tileAtlas);
    
    BonusSprite = new Sprite(p, "bonus.tmx", tileAtlas);
  }

  Game(PApplet p) {
    // Load graphics tiles.
    tileAtlas = new TileAtlas("Tiles1.png");

    // Load the level map for a normal level.
    tileMap = new TileMap(p, "regular.tmx", tileAtlas);

    // Load all sprite maps
    this.loadSprites(p);

    String lines[] = loadStrings("hscore.txt");
    highScore = int(lines[0]);

    pscore = new Score(ScoreSprite, 32);
    hscore = new Score(ScoreSprite, 160);
    
    life = new Life(LifeSprite);

    over = new GameOver(GameOverSprite); 

    pow = new POW(POWSprites);

    // Simulated ball.
    ball = new Ball(pow);

    // Initialize the controller.
    controller = new Controller(ball);

    lvl = new Level();

    // Initialize Mario.
    mario = new Mario(MarioSprites, controller, pow);

    // Initialize enemy creator.
  }

  TileAtlas getTileAtlas() {
    return tileAtlas;
  }

  TileMap getTileMap() {
    return tileMap;
  }

  void update() {
    if (mario.lives == 0) {
      if (delay == 0) {
        // Game over.
        playAudio(GAME_OVER_AUDIO);
        delay = millis(); 
        if (score > highScore) {
          highScore = score; 
          PrintWriter w = createWriter("data/hscore.txt");
          w.println("" + highScore);
          w.flush();
          w.close();
        }
      } else if (millis() - delay > 6000) {
          //bonusReached = false;
          score = 0;
          mario.state = 0;
          mario.lives = MAX_MARIO;
          turtles.clear();
          coins.clear();
          lvl.reset();          
      }
      return;
    }
    delay = 0;
    
    lvl.update();
    ball.update();
    controller.update();
    for (int i = 0; i < turtles.size(); i++) {
      Turtle turtle = (Turtle)turtles.get(i);
      turtle.update();
    }
    for (int i = 0; i < coins.size(); i++) {
      Coin coin = (Coin) coins.get(i);
      coin.update();
    }
    pow.update();
    mario.update();
  }

  void draw() {
    if (mario.lives == 0) {
      // Game over
      over.draw(); 
    }
    
    pscore.draw(score);
    hscore.draw(highScore);
    life.draw();
    for (int i = 0; i < turtles.size(); i++) {
      Turtle turtle = (Turtle)turtles.get(i);
      if (turtle.state != 2) {
        turtle.draw();
      }
    }
    for (int i = 0; i < coins.size(); i++) {
      Coin coin = (Coin)coins.get(i);
      coin.draw();
    }
    tileMap.draw();
    pow.draw();
    if (SIM) {
      ball.draw();
    }
    for (int i = 0; i < turtles.size(); i++) {
      Turtle turtle = (Turtle)turtles.get(i);
      if (turtle.state == 2) {
        turtle.draw();
      }
    }
    mario.draw();
  }
}
