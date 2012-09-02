import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

import processing.serial.*;

PGraphics context;
Game game;
boolean _DEBUG = false;
boolean SIM = true; // Simulate ball

int SCREEN_WIDTH = 512;
int SCREEN_HEIGHT = 480;

int VIEWPORT_WIDTH = 256;
int VIEWPORT_HEIGHT = 240;

Minim minim;

Serial myPort;

void setup() {
  //size(SCREEN_WIDTH, SCREEN_HEIGHT);

  size(screen.width, screen.height);
  SCREEN_WIDTH = screen.width;
  SCREEN_HEIGHT = screen.height;

  context = createGraphics(VIEWPORT_WIDTH, VIEWPORT_HEIGHT, JAVA2D);

  if (!SIM) {
    openPort();
  }

  // Load all the audio
  minim = new Minim(this);
  loadAudio();

  game = new Game(this);
  frameRate(60);
}

int COIN_AUDIO  = 0;
int WALK_AUDIO = 1;
int HIT_AUDIO = 2;
int TOUCH_AUDIO = 3;
int DIE_AUDIO = 4;
int JUMP_AUDIO = 5;
int GAME_OVER_AUDIO = 6;
int MAX_AUDIO = 7;

AudioPlayer[] player;

void openPort() {
  String[] ports = Serial.list();
  
  int i = 0;
  if (ports.length > 1) {
    i = 1;
  }
  String portName = Serial.list()[i];
  myPort = new Serial(this, portName, 9600);
}

String lastVal = "";
float AX = 0.20;
float AY = -0.0008;
void readController(Controller controller) {
  String val;
  if ( myPort.available() > 0) {  // If data is available,
    val = lastVal + myPort.readString();         // read it and store it in val

    println(val);

    // Split the string by newline.
    // Just get till the last new line.
    int index = val.lastIndexOf('\n');

    if (index == -1) {
      lastVal = val;
      return;
    }

    println("val length : " + val.length());
    println("index: " + index);
    String cval = val.substring(0, index);

    if (index + 1 < val.length() - 1) {
      lastVal = val.substring(index + 1, val.length() - 1);
    } 
    else {
      lastVal = "";
    }

    String[] lines = split(cval, "\n");
    boolean found = false;
    boolean afound = false;
    int magnet = 0;
    for (int i = lines.length - 1; i >= 0; i--) {
      String[] comp = lines[i].trim().split(",");
      if (comp.length == 5) {
        if (!afound) {
          float ax = float(comp[0]);
          float ay = float(comp[1]);

          // Do some sanity checks
          if (abs(ax) <= 1.0 && abs(ay) <= 1.0) {
            controller.accelX = -(ax + AX);
            controller.accelY = -(ay + AY);
            afound = true;
          }
        }
        magnet = int(comp[3]);
        int numDigits = int(comp[4]);
        int actualDigits = 0;
        int m = magnet;
        do {
          m /= 10;
          actualDigits++;
        } 
        while (m > 0);
        if (numDigits != actualDigits) {
          // Error in serial communication. Ignore this line.
          continue;
        } 
        else {
          found = true;
        }

        if (magnet != 0) { 
          break;
        }
      }
    }

    //print("lastMagnet: " + controller.lastMagnet + " ");

    if (found) {
      if (controller.magnet != 0) {
        controller.lastMagnet = controller.magnet;
      }
      controller.magnet = magnet;
    }
  }
  println("ax: " + controller.accelX + " ay: " + controller.accelY + " magnet: " + controller.magnet);
}

void loadAudio() {
  player = new AudioPlayer[MAX_AUDIO];

  player[COIN_AUDIO] = minim.loadFile("smb_coin.mp3", 8192);
  player[WALK_AUDIO] = minim.loadFile("walking.mp3", 8192);
  player[HIT_AUDIO] = minim.loadFile("mb_sc.mp3", 8192);
  player[TOUCH_AUDIO] = minim.loadFile("mb_touch.mp3", 8192);
  player[DIE_AUDIO] = minim.loadFile("mb_die.mp3", 8192);
  player[JUMP_AUDIO] = minim.loadFile("mb_jump.mp3", 8192);
  player[GAME_OVER_AUDIO] = minim.loadFile("Game_Over.mp3", 8192);
}

void playAudio(int sound) {
  if ((sound >= 0) && (sound < MAX_AUDIO)) {
    if (!player[sound].isPlaying()) {
      player[sound].play(0);
    }
  }
}

void draw() {
  background(0);

  game.update();

  context.beginDraw();
  context.background(0);
  game.draw();
  context.endDraw();
  image(context, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
}

boolean K_UP = false;
boolean K_DOWN = false;
boolean K_LEFT = false;
boolean K_RIGHT = false;

void keyPressed() {
  if (keyCode == UP) {
    K_UP = true;
    //println("UP pressed");
  } 
  else if (keyCode == DOWN) {
    K_DOWN = true; 
    //println("DOWN pressed");
  } 
  else if (keyCode == LEFT) {
    K_LEFT = true; 
    //println("LEFT pressed");
  } 
  else if (keyCode == RIGHT) {
    K_RIGHT = true; 
    //println("RIGHT pressed");
  }
}

void keyReleased() {
  if (keyCode == UP) {
    K_UP = false; 
    //println("UP released");
  } 
  else if (keyCode == DOWN) {
    K_DOWN = false; 
    //println("DOWN released");
  } 
  else if (keyCode == LEFT) {
    K_LEFT = false;
    //println("LEFT released");
  } 
  else if (keyCode == RIGHT) {
    K_RIGHT = false;
    //println("RIGHT released");
  }
}

