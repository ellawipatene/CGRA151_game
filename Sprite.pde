class Sprite{
  float x, y, vy, w, h; 
  float gravity = 0.8; 
  int lives;  
  PImage sprite[]; 
  PImage life_img[];
  
  int img_counter = 0; 
  int orb_counter = 0; 
 
  boolean attack = false;
  boolean dead = false; 
  int attack_counter; // The amount of attacks that the character can do
  int injury_counter; // The amount of times the villan has hit the sprite

  Sprite(float y, PImage[] image_array, PImage[] life_img){
    this.x = 0;
    this.y = y;
    this.vy = 0;
    this.w = image_array[0].width/7;
    this.h = image_array[0].height/7;
    this.lives = 3;
    this.sprite = image_array; 
    this.life_img = life_img; 
   
  }
  
  // Getters: 
  float get_x(){return this.x;}
  float get_y(){return this.y;}
  float get_w(){return this.w;}
  float get_h(){return this.h;}
  int get_lives(){return lives;}
  
  /**
    Draw the sprite
  **/
  void display(){ 
    if(!dead){
      changeY(); 
      if(attack){
        image(sprite[img_counter], x, y, sprite[img_counter].width/7, sprite[img_counter].height/7); 
        if(img_counter < sprite.length - 1){img_counter++;}
        else{
          attack = false;
          img_counter = 0; 
        }  
      }else{ // move as normal
        image(sprite[img_counter], x, y, sprite[img_counter].width/7, sprite[img_counter].height/7); 
        if(img_counter < 5){img_counter++;}
        else{img_counter = 0;}
      }
    }
  }
 
  /**
    Display the amount of lives that the Sprite has left 
  **/ 
  void display_lives(){
    tint(255, 255);
    if(this.lives == 3){
      image(heart, 20, 20, 25, 25); 
      image(heart, 50, 20, 25, 25); 
      image(heart, 80, 20, 25, 25); 
    }else if(this.lives == 2){
      image(heart, 20, 20, 25, 25); 
      image(heart, 50, 20, 25, 25); 
    }else if(this.lives == 1){
      image(heart, 20, 20, 25, 25); 
    }
  }
  
  /**
    Displays the amount of orbs that the sprite has collected so far 
  **/
  void display_orbs(){text(this.orb_counter + "/30 Orbs", 670, 40);}
  
   
  // Setters
  void set_x(float new_x){this.x = new_x;} 
  void set_y(float new_y){this.y = new_y;}
  void set_orbs(int n){this.orb_counter = n; }
  void loose_life(){this.lives--;}
  void gain_life(){if(this.lives < 3){this.lives++;}}
  void gain_orb(){orb_counter++; }
  void attack(){this.attack = true; }
  
  // Move the sprite to the right
  void move_right(){
    if(this.x + this.sprite[0].width/7 < 800){ // so it cant go off the right side of the screen
      this.x = this.x + 5; 
    }
  }
  
  // Move the sprite to the left
  boolean move_left(){    
    if(this.x > 0){ // so it cant go off the left of the screen
      this.x = this.x - 5;
      return true; 
    }
    return false;
  }
  
  // When the sprite wants to jump
  void jump(){
    if(this.y > char_height - 80){this.vy = -5;}
  }
  
  // Checks that the jump is valid
  void changeY(){
    if(this.vy != 0 && this.y > char_height - 100){
      this.vy += gravity; 
      this.y += vy; 
      if(this.y >= char_height){this.vy = 0; }
    }else if(y < char_height){ // Sprite goes back down after jump
      this.y = this.y + 5;
    }
  }
 
  
  //
  //------------------------------------------------------------------------------------------------------
  // For the final battle: 
  
  // Getters:
  boolean get_attack_state(){return attack;}
  int get_img_counter(){return img_counter;}
  int get_injury_counter(){return injury_counter;}
  int get_orb_counter(){return orb_counter; }

  /**
    Calculate how many attacks the sprite will have in the battle
    Based on the amount of orbs they collect
  **/
  void set_attack_counter(){
    attack_counter = (int) orb_counter/5; 
    println("amount of attacks: " + attack_counter); 
  }
  
  /**
    Decides which health image to display based on how many times 
    the villan has hit the sprite
  **/
  void display_health(){ image(life_img[injury_counter], 30, 10, life_img[injury_counter].width/2, life_img[injury_counter].height/2);}
  
  // Move character left and right
  void move_right_attack(){this.x = this.x + 4;}
  void move_left_attack(){this.x = this.x - 4; }
  
  // Change image of injury counter
  void decrease_health(){this.injury_counter++; }
  
  // Re-set image counter
  void set_img_counter(int counter){this.img_counter = counter;}
  
  // If the sprite has died
  void display_dead(){
    image(explosion[img_counter], x, y, explosion[img_counter].width/4, explosion[img_counter].height/4); 
    img_counter++;
  }
  
  // If the sprite is dead
  void isDead(){this.dead = true; }
  
  
  

  

}
