class Orb{
  float x, y, w, h; 
  PImage img; 
  boolean active; // if it is on the screen and not collected 

  Orb(float x, float y, PImage img){
    this.x = x;
    this.y = y; 
    this.w = img.width/2;
    this.h = img.height/2;
    this.img = img; 
    this.active = true; 
  }
  
  /**
    Displays the orb on the screen
  **/
  void display(){
    if(active){
      image(img, x, y, img.width/2, img.height/2);
    }
  }
  
  /**
    Checks if the Sprite has touched the orb
  **/
  boolean collected(Sprite s){
    if ((s.get_x() + s.get_w() - 50 >= this.x) && (s.get_x() <= this.x + this.w)){ // within the x range
      if(this.y + this.h >= s.get_y() && this.y + this.h <= s.get_y() + s.get_h()){return true;} // within the y range
      else{return false;}
    }
    return false;
  }
  
  // Move the orb to the right
  void move_right(){
    this.x = this.x - 5; 
  }
  
  // Move the orb to the left
  void move_left(){
    this.x = this.x + 5; 
  }
  
  // If it has already been collected
  void not_active(){
    this.active = false; 
  }
  
  // check if it is active
  boolean active(){
    return this.active; 
  }

}
