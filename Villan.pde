class Villan{
  float x, y; 
  PImage villan[]; 
  PImage life_img[];
  int img_counter = 0; 
  
  boolean attack = false; 
  boolean dead = false; 
  int attack_counter; // The amount of attacks that the villan can do
  int injury_counter; // The amount of times the sprite has hit the villan
  
  Villan(float x, float y, PImage[] img_array, PImage[] life_img){
    this.x = x; 
    this.y = y;
    this.villan = img_array; 
    this.life_img = life_img; 
  }
  
  /**
    Draw the villan
  **/ 
  void display(){
    if(!dead){
      if(attack == true){ // if they are attacking the sprite
        image(villan[img_counter], x, y, villan[img_counter].width, villan[img_counter].height); // display attack imgs
        if(img_counter < villan.length -1){img_counter++;}
        else{
          attack = false;
          img_counter = 0; 
        }
      }else{
        image(villan[img_counter], x, y, villan[img_counter].width, villan[img_counter].height); // display resting imgs
        if (img_counter < 6){img_counter++;}
        else{img_counter = 0;}
      }
    }
  }
  
  // setters
  void set_x(float new_x){this.x = new_x;}
  void attack(){this.attack = true; }
  
  // getters
  float get_x(){return this.x;}
  
 
  
  //
  //------------------------------------------------------------------------------------------------------
  // For the final battle: 
  
  /**
    Sets the attack_counter based on the sprites orb counter
  **/
  void set_attack_counter(Sprite s){
    if(s.get_orb_counter() == 30){attack_counter = 5;}
    else{attack_counter = 6;}
  }
  
  void display_health(){image(life_img[injury_counter], 530, 10, life_img[injury_counter].width/2, life_img[injury_counter].height/2);}
  
  // Move left and right
  void move_left(){this.x = this.x - 4;}
  void move_right(){this.x = this.x + 4;}
  
  // Getters:
  boolean get_attack_state(){return this.attack;}
  int get_img_counter(){return img_counter;}
  int get_injury_counter(){return injury_counter;}
  
  // Setters:
  void decrease_health(){this.injury_counter++; }
  void isDead(){dead = true;}
  void set_img_counter(int counter){this.img_counter = counter;}
  
  // Display the villan dying
  void display_dead(){
    image(explosion[img_counter], x, y, explosion[img_counter].width/7, explosion[img_counter].height/7); 
    img_counter++;
  }
}
