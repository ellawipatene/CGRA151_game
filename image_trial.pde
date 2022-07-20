import java.util.Map;

// For the images used for all of the elements
PImage starting_images[]; 
PImage background; 
PImage background_end; 
PImage sprite[]; 
PImage sprite_lifes[];
PImage villan_img[]; 
PImage villan_lifes[];
PImage explosion[];
PImage heart; 
PImage potion_img[]; 
PImage orb_img; 
PImage normal_floor; 
PImage small_floor; 
PImage spike; 
PImage hole;                             // maybe put images into a map?? 
PImage wall;
PImage rocks_img[]; 

HashMap<String, PImage> images_map = new HashMap<String, PImage>();

PFont main_font;                         // pixel font 

boolean left, right, up, attack; 

float background_x = 0; 
int counter = 0;                         // counts the animation for the begining screens 
int time = 0;                            // incharge of how through the sprite is through the course
int opacity = 0;                         // controls the opacity of the fading transitions
float char_height = 425;                 // the y value that the ground is at
boolean loaded_villan = false; 
boolean floor_in_range = false;          // if there is a floor between 350 and 400

Sprite character; 
Villan villan; 
ArrayList<Orb> orbs = new ArrayList<Orb>(); 
ArrayList<Potion> potions = new ArrayList<Potion>();
ArrayList<Floor> floors = new ArrayList<Floor>(); 
ArrayList<Rock> rocks = new ArrayList<Rock>(); 

String state = "begin"; 
String battle_state = "setup"; 


void setup(){
  size(800,800);
  loadSpriteImg(); 
  loadVillanImg(); 
  loadElements(); 
  loadOrbs();
  loadPotions();
  loadFloors(); 
  
  main_font = createFont("pixel_font.ttf", 15);
  textFont(main_font);
  character = new Sprite(char_height, sprite, sprite_lifes);
}

void draw(){
  if(state.equals("begin")){
    begin(starting_images); 
  }else if (state.equals("rules")){
    rules(starting_images);
  }else if (state.equals("start game")){
    get_to_center(); 
  }else if (state.equals("middle game")){
    main_game();
  }else if (state.equals("transition")){
    transition(); 
  }else if(state.equals("end transition")){
    end_transition(); 
  }else if(state.equals("end game")){
    end_game(); 
  }else if(state.equals("game over")){
    game_over(); 
  }
  display_text(); // instructions for game
}

/**
  Shows the begining screen
**/
void begin(PImage[] img){
  frameRate(5);
  image(img[counter], 0, 0, width, height); 
  if(counter > 0){counter--;}
  else{counter++;}
  
   if(keyPressed){
     if(key == 'p'){state = "start game";}
     if(key == 'r'){
       state = "rules";
       counter = 2; 
     } 
   }
}

/**
  Shows the screen with all of the rules on it
**/
void rules(PImage[] img){
  image(img[counter], 0, 0, width, height); 
  if(counter == 3){counter--;}
  else{counter++;}
  if(keyPressed){
    if(key == 'h'){state = "begin";}
  }
}

/** 
  Runs the main game
**/ 
void main_game(){
    if(time < - 1){
        state = "start game";
        character.set_x(298); 
        time = 0;         
    }
    
    if(time >= 1420){state = "end transition";} // if you have finished the course
    loadFloors();
    loadOrbs(); 
    frameRate(20); 
    background(#1A191F);
    image(background, background_x, 0, background.width, background.height); 
    
    if(left){
      background_x  = background_x + 3;
      move_objects_left(); 
      time--; 
    }
    if(right){
      background_x = background_x - 3;
      move_objects_right();
      time++; 
    }
    if(up){
      character.jump();
    }
    
    for(Orb o: orbs){
      if(o.active()){
        o.display(); 
        if(o.collected(character)){ //checks if the sprite has touched the orb
          character.gain_orb();
          o.not_active(); 
        }
      }
    }
    
    for(Potion p: potions){
      p.display(); 
      if(p.collected(character)){
        character.gain_life();
        potions.remove(p);
        break;
      }
    }
    
    
    for(Floor f: floors){
      if(f.active()){
        if(f.touching_left(character)){
          if(f.get_type() == "spike"){state = "transition";}  // if you touch the spike, loose a life
          move_left(); 
        }
        if(f.touching_right(character)){
          move_right();  
        }
        if(f.get_type() == "hole"){
          if(f.touching_top(character)){state = "transition";}
        }
        if(f.get_x() + 25 < 400 && f.get_x() + f.get_w() - 25 > 350){
          floor_in_range = true; 
          if(char_height > f.get_y() - 100){char_height = f.get_y() - 100;} // if there are multiple floors, it will take the highest one
        }
        if(!floor_in_range){char_height = 425;}
        f.display();    
      }
    }
    floor_in_range = false; 
     
    character.display(); 
    character.display_lives(); 
    character.display_orbs();
    if(loaded_villan){villan.display();}
    
    // Display and generate rocks at the correct part of the course
    if(time > 850 && time < 1000){
      int percentage = (time - 850)/100;
      int lowerX = 800 - (800 * percentage); 
      makeRock(lowerX, 800); 
      for(Rock r: rocks){
        r.display(); 
        if(r.hit_sprite(character)){state = "transition";} 
      }
    }else if(time >= 1000 && time < 1100){
      int percentage = (time - 1000)/100; 
      int upperX = 800 - (800 * percentage);   
      makeRock(0, upperX); 
      for(Rock r: rocks){
        r.display();
        if(r.hit_sprite(character)){state = "transition";} 
      }
    }else if (time > 1100 && time < 1200){
      for(Rock r: rocks){
        r.display();
        if(r.hit_sprite(character)){state = "transition";} 
      }
    
    }
}


/**
  If the sprite dies along the course
**/ 
void transition(){
  image(background, background_x, 0, background.width, background.height); 
  character.display(); 
  for(Rock r: rocks){r.display();}
  for(Floor f: floors){f.display();}
  for(Potion p: potions){p.display();}
  for(Orb o: orbs){o.display();}
  fill(0, opacity); 
  rect(0, 0, width, height); 
  if(opacity < 255){opacity = opacity + 5;}
  else {
    state = "middle game";
    killed(); 
  }
}

/**
  Once the player has finished the course
  Transition to the final battle
**/
void end_transition(){
  frameRate(20); 
  image(background, background_x, 0, background.width, background.height); 
  villan.display(); 
  character.display(); 
  fill(0, opacity); 
  rect(0, 0, width, height); 
  if(opacity < 255){opacity = opacity + 5;}
  else {state = "end game";}
} 

/**
  Right at the start of the game, allows the player to move the sprite to the center. 
**/
void get_to_center(){
  if(character.get_x() >= 300){state = "middle game";}
  frameRate(20); 
  background(#1A191F); 
  image(background, background_x, 0, background.width, background.height); 
  
  if(right){character.move_right();}
  if(left){character.move_left();}
  
  if(keyPressed){
    if(key == 'q'){ // for testing purposes!! DELETE
      villan = new Villan(800, 365, villan_img, villan_lifes);
      state = "end game";
    }
    if(key == 'w'){ // for testing purposes!!! DELETE
      state = "end game"; 
      character.set_orbs(30); 
    }
  }
  

  character.display(); 
  character.display_lives(); 
  character.display_orbs(); 
}


// Battle section at the end of the game
void end_game(){
  image(background_end, 0, 0, width, height); 
  
  if(battle_state.equals("setup")){
    opacity = 0; 
    character.set_x(200);
    character.set_y(425); 
    villan.set_x(400);
    character.set_attack_counter();
    villan.set_attack_counter(character); 
    if(character.get_orb_counter() == 30){battle_state = "sprite wait";}
    else{battle_state = "villan to center";}
    
  }else if(battle_state.equals("villan to center")){
    if(villan.get_x() > 250){villan.move_left();}
    else{battle_state = "villan attack";}
    
  }else if(battle_state.equals("villan attack")){
    if(!villan.get_attack_state()){villan.attack();}
    if(villan.get_img_counter() == 27){
      character.decrease_health(); 
      if(character.get_injury_counter() == 6){battle_state = "villan wins";}
      else{battle_state = "villan to edge";}
    }
    
  }else if(battle_state.equals("villan to edge")){
    if(villan.get_x() < 400){villan.move_right();}
    else{battle_state = "sprite wait";}
  
  }else if(battle_state.equals("sprite wait")){
    text("Press 'a' to attack villan.", 250, 650);
    if(keyPressed){
      if(key == 'a'){battle_state = "sprite to center";}
    }
    
  }else if(battle_state.equals("sprite to center")){
    if(character.get_x() < 350){character.move_right_attack();}
    else{battle_state = "sprite attack";}
    
  }else if(battle_state.equals("sprite attack")){
    if(!character.get_attack_state()){character.attack();}
    if(character.get_img_counter() == 14){
      villan.decrease_health();
      if(villan.get_injury_counter() == 6){battle_state = "sprite wins";}
      else{battle_state = "sprite to edge";}
    }
    
  }else if(battle_state.equals("sprite to edge")){
    if(character.get_x() > 200){character.move_left_attack();}
    else{battle_state = "villan to center";}
    
  }else if(battle_state.equals("sprite wins")){
    println("sprite wins"); 
    villan.display_dead(); // will display the villan blowing up
    villan.isDead(); // means the villan will not display after during the fade
    if(villan.get_img_counter() == 13){
      battle_state = "sprite display win";
    }
    
  }else if(battle_state.equals("villan wins")){
    println("villan wins");
    character.display_dead(); // will display the sprite blowing up
    character.isDead(); // means the sprite will not display after during the fade
    if(character.get_img_counter() == 13){
      battle_state = "villan display win";
      
    }
  }
  
  if(!battle_state.equals("villan wins")){character.display();}
  character.display_health(); 
  if(!battle_state.equals("sprite wins")){villan.display();}
  villan.display_health(); 
  
  if(battle_state.equals("sprite display win")){
    fill(0, opacity); 
    rect(0, 0, width, height); 
    if(opacity < 255){opacity = opacity + 20;}
    else {battle_state = "sprite text";}
    
  }else if(battle_state.equals("villan display win")){
    fill(0, opacity);  
    rect(0, 0, width, height); 
    if(opacity < 255){opacity = opacity + 20;}
    else {battle_state = "villan text";}
    
  }else if(battle_state.equals("sprite text")){
    fill(0);  
    rect(0, 0, width, height); 
    fill(255);
    text("Congratulations!", 300, 320); 
    text( "You have defeated the Ecthrois and saved your village!", 140, 350);
    text("Press 'H' to go back to the home page.", 230, 380);
    if(keyPressed){
      if(key == 'h'){
        state = "begin";
        battle_state = "setup"; 
      }
    }
    
    
  }else if(battle_state.equals("villan text")){
    fill(0);  
    rect(0, 0, width, height); 
    fill(255);
    text("Oh no! The Ecthrois won!", 280, 350);
    text("To try again Press 'H' to go to the home page.", 180, 390);
    if(keyPressed){
      if(key == 'h'){
        state = "begin";
        battle_state = "setup";
      }
    }
  }
}

void game_over(){
    fill(0);  
    rect(0, 0, width, height); 
    fill(255);
    text("Oh no! You have been killed!", 280, 350);
    text("To try again Press 'H' to go to the home page.", 180, 390);
    if(keyPressed){
      if(key == 'h'){
        reset();
        state = "begin";
        battle_state = "setup";
      }
    }
}


/** 
  If the character has been killed during the course, 
  Reset all the bellow values
**/
void killed(){
  character.loose_life();
  if(character.get_lives() == 0){state = "game over";}
  character.set_orbs(0);
  character.set_y(425); 
  
  background_x = 0;
  time = 0;
  opacity = 0; 
  reset_keys();
  
  orbs = new ArrayList<Orb>(); 
  potions = new ArrayList<Potion>();
  floors = new ArrayList<Floor>(); 
}

/** 
  If they have finished the game,
  Reset all the bellow values
**/
void reset(){
  character.set_orbs(0); 
  character.dead = false;
  character.lives = 3; 
  character.img_counter = 0; 
  character.injury_counter = 0; 
  character.set_x(0);
  
  if(loaded_villan){villan.dead = false;}
  
  time = 0; 
  background_x = 0;
  counter = 0;
  opacity = 0; 
  
  orbs = new ArrayList<Orb>(); 
  potions = new ArrayList<Potion>();
  floors = new ArrayList<Floor>();
  
  reset_keys();
}

/**
  Instructions of how to play displayed throught the game
**/
void display_text(){
  fill(#B0BCAF); 
  if(state.equals("start game") && character.get_x() > 20){
    text("Use the arrows to move left and right.", 230, 650);
  }else if(time > 30 && time < 70){
    text("Collect all of the orbs to win!", 250, 650);
  }else if(time > 90 && time < 150){
    text("Use the up arrow to jump.", 290, 650);
  }else if(time > 220 && time < 270){
    text("Avoid the spikes, they could kill you!", 230, 650);
  }else if(time > 620 && time < 670){
    text("Dont fall into the hole!", 290, 650);
  }else if(time > 880 && time < 940){
    text("Watch out for the falling rocks!", 290, 650);
  }
}

//
//--------------------------------------------------------------------------------------------------
// MOVING OBJECTS WHEN SPRITE MOVES

void move_objects_right(){
  for(Floor f: floors){f.move_right();}
  for(Orb o: orbs){o.move_right();}
  for(Potion p: potions){p.move_right(); }
  for(Rock r: rocks){r.move_right();}
  if(loaded_villan){villan.move_left();}
}

void move_objects_left(){
  for(Floor f: floors){f.move_left();}
  for(Orb o: orbs){o.move_left();}
  for(Potion p: potions){p.move_left(); }
  for(Rock r: rocks){r.move_left();}
  if(loaded_villan){villan.move_right();}
}

// Move everything to the left
void move_left(){
  background_x  = background_x + 3;
  move_objects_left(); 
  time--;
}

// Move everything to the right
void move_right(){
  background_x = background_x - 3;
  move_objects_right();
  time++; 
}

//
//--------------------------------------------------------------------------------------------------
// CHECKING CHARACTER BOUNDARIES:

boolean check_char_left(){
  boolean valid = false; 
  for(Floor f: floors){
    if(f.touching_left(character)){valid = true;}
  }
  return valid; 
}

//
//--------------------------------------------------------------------------------------------------
// IMAGE SET-UP CODE: 

/**
  Loads in the array of sprite images for its animation
**/
void loadSpriteImg(){
  sprite = new PImage[15]; 
  sprite[0] = loadImage("sprite/0.png"); 
  sprite[1] = loadImage("sprite/0.png");
  sprite[2] = loadImage("sprite/0.png"); 
  sprite[3] = loadImage("sprite/1.png");
  sprite[4] = loadImage("sprite/1.png"); 
  sprite[5] = loadImage("sprite/1.png"); 
  
  for(int i = 6; i < sprite.length; i++){
    int x = i - 4; 
    sprite[i] = loadImage("sprite/" + x + ".png");
  }
  
  sprite_lifes = new PImage[7]; 
  for(int i = 0; i < sprite_lifes.length; i++){
    sprite_lifes[i] = loadImage("sprite/kibasa_life/kibasa_life_" + i + ".png"); 
  }
}

/**
  Loads in the array of villan images for its animation
**/
void loadVillanImg(){
  villan_img = new PImage[28];
  villan_img[0] = loadImage("villan/villan_0.png");
  villan_img[1] = loadImage("villan/villan_0.png");
  villan_img[2] = loadImage("villan/villan_0.png");
  villan_img[3] = loadImage("villan/villan_1.png");
  villan_img[4] = loadImage("villan/villan_1.png");
  villan_img[5] = loadImage("villan/villan_1.png");
  
  for(int i = 6; i < 28; i++){
    int x = i - 4; 
    villan_img[i] = loadImage("villan/villan_" + x + ".png"); 
  }
  
  villan_lifes = new PImage[7]; 
  for(int i = 0; i < sprite_lifes.length; i++){
    villan_lifes[i] = loadImage("villan/villan_life/villan_life_" + i + ".png"); 
  }
}

/**
  Loads in the main elements images, e.g. background, potions, begining images etc.
**/
void loadElements(){
  explosion = new PImage[13];
  for(int i = 0; i < 13; i++){
    explosion[i] = loadImage("explosion/explosion_" + i + ".png");
  }
  
  starting_images = new PImage[4]; 
  for(int i = 0; i < 4; i++){
    starting_images[i] = loadImage("starting_images/" + i + ".jpg");
  }
  
  background = loadImage("background.jpg"); 
  background_end = loadImage("end.jpg"); 
  normal_floor = loadImage("floor_w_shadow.png");
  small_floor = loadImage("small_floor.png");
  wall = loadImage("wall.png"); 
  hole = loadImage("hole.png"); 
  spike = loadImage("spike.png"); 
  heart = loadImage("heart.png"); 
  orb_img = loadImage("orb.png"); 
  
  rocks_img = new PImage[4]; 
  for(int i = 0; i < 4; i++){
    rocks_img[i] = loadImage("rocks/rock" + i + ".png");
  }
  
  potion_img = new PImage[9];
  for (int i = 0; i < 9; i++){
    potion_img[i] = loadImage("potion/potion_"+i+".png"); 
  }
}

// Randomly generates a rock
void makeRock(int x1, int x2){
  int probability = 20;
  int image = int(random(0, 4)); 
  int random = int(random(0, probability));
  float randomX = random(x1, x2); 
  if(random == 1){
    rocks.add(new Rock(randomX, rocks_img[image])); 
  }
}


// Load in the orbs at the correct time and position in the game
void loadOrbs(){
  if(time > 0 && orbs.size() == 0){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 10 && orbs.size() == 1){orbs.add(new Orb(800, 500, orb_img));}
  
  if(time > 231 && orbs.size() == 2){orbs.add(new Orb(800, 430, orb_img));}
  
  if(time > 290 && orbs.size() == 3){orbs.add(new Orb(800, 450, orb_img));}
  if(time > 300 && orbs.size() == 4){orbs.add(new Orb(800, 450, orb_img));}
  
  if(time > 360 && orbs.size() == 5){orbs.add(new Orb(800, 450, orb_img));}
  if(time > 380 && orbs.size() == 6){orbs.add(new Orb(800, 410, orb_img));}
  if(time > 400 && orbs.size() == 7){orbs.add(new Orb(800, 370, orb_img));}
  if(time > 420 && orbs.size() == 8){orbs.add(new Orb(800, 370, orb_img));}
  if(time > 440 && orbs.size() == 9){orbs.add(new Orb(800, 410, orb_img));}
  
  if(time > 515 && orbs.size() == 10){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 545 && orbs.size() == 11){orbs.add(new Orb(800, 500, orb_img));}
  
  if(time > 635 && orbs.size() == 12){orbs.add(new Orb(800, 400, orb_img));}
  if(time > 655 && orbs.size() == 13){orbs.add(new Orb(800, 380, orb_img));}
  if(time > 675 && orbs.size() == 14){orbs.add(new Orb(800, 400, orb_img));}
  
  if(time > 763 && orbs.size() == 15){orbs.add(new Orb(800, 450, orb_img));}
  if(time > 773 && orbs.size() == 16){orbs.add(new Orb(800, 410, orb_img));}
  if(time > 783 && orbs.size() == 17){orbs.add(new Orb(800, 370, orb_img));}
  if(time > 793 && orbs.size() == 18){orbs.add(new Orb(800, 330, orb_img));}
  
  if(time > 875 && orbs.size() == 19){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 900 && orbs.size() == 20){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 925 && orbs.size() == 21){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 950 && orbs.size() == 22){orbs.add(new Orb(800, 500, orb_img));}
  if(time > 975 && orbs.size() == 23){orbs.add(new Orb(800, 500, orb_img));}
  
  if(time > 1051 && orbs.size() == 24){orbs.add(new Orb(800, 470, orb_img));}
  if(time > 1081 && orbs.size() == 25){orbs.add(new Orb(800, 470, orb_img));}
  
  if(time > 1149 && orbs.size() == 26){orbs.add(new Orb(800, 430, orb_img));}
  if(time > 1184 && orbs.size() == 27){orbs.add(new Orb(800, 430, orb_img));}
  if(time > 1219 && orbs.size() == 28){orbs.add(new Orb(800, 430, orb_img));}
  
  if(time > 1290 && orbs.size() == 29){orbs.add(new Orb(800, 500, orb_img));}
}

void loadPotions(){
    
}


// Adds the floor elements in at the right time at the right position
void loadFloors(){    
    if(time > 50 && floors.size() == 0){floors.add(new Floor(800, 490, "normal", normal_floor));}    
    if(time > 70 && floors.size() == 1){floors.add(new Floor(800, 450, "normal", normal_floor));}
    if(time > 90 && floors.size() == 2){floors.add(new Floor(800, 490, "normal", normal_floor));}
    
    if(time > 200 && floors.size() == 3){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 217 && floors.size() == 4){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 230 && floors.size() == 5){floors.add(new Floor(800, 482, "spike", spike));}
    if(time > 235 && floors.size() == 6){floors.add(new Floor(800, 482, "spike", spike));}
   
    if(time > 280 && floors.size() == 7){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 285 && floors.size() == 8){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 285 && floors.size() == 9){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 308 && floors.size() == 10){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 313 && floors.size() == 11){floors.add(new Floor(800, 519, "spike", spike));}
    
    if(time > 350 && floors.size() == 12){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 370 && floors.size() == 13){floors.add(new Floor(800, 450, "normal", normal_floor));}
    if(time > 390 && floors.size() == 14){floors.add(new Floor(800, 410, "normal", normal_floor));}
    if(time > 410 && floors.size() == 15){floors.add(new Floor(800, 410, "normal", normal_floor));}
    if(time > 430 && floors.size() == 16){floors.add(new Floor(800, 450, "normal", normal_floor));}
    if(time > 450 && floors.size() == 17){floors.add(new Floor(800, 490, "normal", normal_floor));}
    
    if(time > 500 && floors.size() == 18){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 530 && floors.size() == 19){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 560 && floors.size() == 20){floors.add(new Floor(800, 519, "spike", spike));}
    
    if(time > 580 && floors.size() == 21){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 590 && floors.size() == 22){floors.add(new Floor(800, 550, "hole", hole));}
    if(time > 600 && floors.size() == 23){floors.add(new Floor(800, 450, "normal", normal_floor));}
    if(time > 630 && floors.size() == 24){floors.add(new Floor(800, 430, "small", small_floor));}
    if(time > 650 && floors.size() == 25){floors.add(new Floor(800, 410, "small", small_floor));}
    if(time > 670 && floors.size() == 26){floors.add(new Floor(800, 430, "small", small_floor));}
    if(time > 690 && floors.size() == 27){floors.add(new Floor(800, 450, "normal", normal_floor));}
    if(time > 710 && floors.size() == 28){floors.add(new Floor(800, 490, "normal", normal_floor));}
    
    if(time > 760 && floors.size() == 29){floors.add(new Floor(800, 490, "small", small_floor));}
    if(time > 770 && floors.size() == 30){floors.add(new Floor(800, 450, "small", small_floor));}
    if(time > 780 && floors.size() == 31){floors.add(new Floor(800, 410, "small", small_floor));}
    if(time > 790 && floors.size() == 32){floors.add(new Floor(800, 370, "small", small_floor));}
    
    if(time > 813 && floors.size() == 33){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 818 && floors.size() == 34){floors.add(new Floor(800, 519, "spike", spike));}
    
    if(time > 1050 && floors.size() == 35){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 1055 && floors.size() == 36){floors.add(new Floor(800, 519, "spike", spike));}
    
    if(time > 1080 && floors.size() == 37){floors.add(new Floor(800, 519, "spike", spike));}
    if(time > 1085 && floors.size() == 38){floors.add(new Floor(800, 519, "spike", spike));}
    
    if(time > 1120 && floors.size() == 39){floors.add(new Floor(800, 550, "hole", hole));}
    if(time > 1130 && floors.size() == 40){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 1147 && floors.size() == 41){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 1150 && floors.size() == 42){floors.add(new Floor(800, 480, "spike", spike));}
    
    if(time > 1179 && floors.size() == 43){floors.add(new Floor(800, 490, "small", small_floor));}
    if(time > 1200 && floors.size() == 44){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 1215 && floors.size() == 45){floors.add(new Floor(800, 490, "normal", normal_floor));}
    if(time > 1220 && floors.size() == 46){floors.add(new Floor(800, 480, "spike", spike));}
    
    // Loads in the villan at the end. 
    if(time > 1350 && !loaded_villan){
      villan = new Villan(800, 365, villan_img, villan_lifes);
      loaded_villan = true;
  }
}

//-------------------------------------------------------------------------------------------
// Key Controls

void keyPressed(){
  if(state.equals("start game") || state.equals("middle game")){
    if(key == CODED){
      if(keyCode == RIGHT){right = true;}
      if(keyCode == LEFT){left = true;}
      if(keyCode == UP){up = true;}
    }
  }
}

void keyReleased(){
  if(state.equals("start game") || state.equals("middle game")){
    if(key == CODED){
      if(keyCode == RIGHT){right = false;}
      if(keyCode == LEFT){left = false;}
      if(keyCode == UP){up = false;}
    }
  }
}

void reset_keys(){
  up = false;
  right = false;
  left = false; 
}
