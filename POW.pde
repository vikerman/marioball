class POW extends Element {
  Sprite[] sprites;
  int index = 0;
  
   POW(Sprite[] sprites) {
     super(0, 0, 0, 0, 0, 0, null, "pow");
     x =  120;
     y = 176;
     vx = 0;
     vy = 0;
     sprite = sprites[0];
     this.sprites = sprites;
   }
   
   void hit() {
     if (index < 2) {
       //index++;
       //sprite = sprites[index];
       
       playAudio(HIT_AUDIO);
       
       // Go through all turtles and toggle.
       for (int i = 0; i < game.turtles.size(); i++) {
         Turtle t = (Turtle) game.turtles.get(i);
         if (t.state == 0) {
           t.state = 1;
           t.flip();
         } else if (t.state == 1) {
           //t.state = 0;
         } 
       }
       
       // Get the coins in discount.
       game.score += 100 * game.coins.size();
       game.coins.clear();
     }
     else {
       sprite.hide(); 
     }
   }
}
