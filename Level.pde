class LevelData {
  int time;
  String npc;
  int speed; 

  LevelData(int time, String npc, int speed) {
    this.time = time;
    this.npc = npc;
    this.speed = speed;
  }
}

LevelData[] Level1 = new LevelData[7];
LevelData[] Level2 = new LevelData[7];
LevelData[] Level3 = new LevelData[9];

class Level {
  int level = 1;
  int start = 0;
  int index = 0;

  Level() {
    Level1[0] = new LevelData(1000, "turtle", 20);
    Level1[1] = new LevelData(4000, "turtle", -20);
    Level1[2] = new LevelData(9000, "crab", 20);
    Level1[3] = new LevelData(15000, "coin", 40);
    Level1[4] = new LevelData(21000, "crab", -20);
    Level1[5] = new LevelData(30000, "coin", -40);
    Level1[6] = new LevelData(40000, "crab", 20);


    Level2[0] = new LevelData(1000, "turtle", 20);
    Level2[1] = new LevelData(4000, "turtle", -20);
    Level2[2] = new LevelData(9000, "coin", 40);
    Level2[3] = new LevelData(17000, "crab", -20);
    Level2[4] = new LevelData(24000, "turtle", 20);
    Level2[5] = new LevelData(32000, "coin", -40);
    Level2[6] = new LevelData(41000, "crab", 30);

    Level3[0] = new LevelData(1000, "turtle", 30);
    Level3[1] = new LevelData(4000, "turtle", -30);
    Level3[2] = new LevelData(9000, "turtle", 30);
    Level3[3] = new LevelData(17000, "coin", 40);
    Level3[4] = new LevelData(25000, "crab", -30);
    Level3[5] = new LevelData(36000, "crab", 30);
    Level3[6] = new LevelData(46000, "coin", 20);
    Level3[7] = new LevelData(54000, "crab", -40);
    Level3[8] = new LevelData(63000, "crab", 40);
  }

  void update() { 
    if (start == 0) {
      start = millis(); 
    }
    
    LevelData[] l = Level1;
    if (level == 1) {
      l = Level1;
    } 
    else if (level == 2) {
      l = Level2;
    } 
    else if (level == 3) {
      l = Level3;
    }

    if (index == l.length) {
      if (game.turtles.size() == 0) {
        nextLevel();
      }  
    } else if (millis() - start > l[index].time) {
      println("Creating " + level + ":" + index); 
      create(l[index]);
    }
  } 

  void create(LevelData l) {
    index++;
    if (l.npc.equals("turtle")) {
      game.turtles.add(new Turtle(TurtleSprites, l.speed));
    } else if (l.npc.equals("crab")) {
      game.turtles.add(new Turtle(CrabSprites, l.speed));
    } 
    else if (l.npc.equals("coin")) {
      game.coins.add(new Coin(CoinSprite, l.speed));
    }
  }

  void reset() {
    level = 1;
    start = 0;
    index = 0;
  }

  void nextLevel() {
    start = millis() + 1000;
    index = 0;
    if (level == 3) {
      level = 1;
    } 
    else {
      level++;
    }
  }
}

