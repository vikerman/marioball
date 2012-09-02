class Life {
  
 Sprite s; 
  
 Life(Sprite s) {
   this.s = s;
 } 
  
 void draw() {
   for (int i = 0; i < game.mario.lives; i++) {
     s.draw((10 - i) * 8, 40, 0);
   }
 } 
  
}

class Score {
 
 Sprite s;
 int x;

 Score(Sprite s, int x) {
   this.s = s;
   this.x = x;
 }
 
 void draw(int score) {
   String str = nf(score, 7);
   for (int i = 0; i < 7; i++) {
      s.layer.tiles[i][0] = 129 + (int)(str.charAt(i) - '0');
   }
   s.draw(x, 32, 0); 
 }
}


class GameOver {
  Sprite s;
 
  GameOver(Sprite s) {
    this.s = s; 
  }
 
  void draw() {
    s.draw(104, 96,0);
  } 
}
