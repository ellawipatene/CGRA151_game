class Rock{
  float x, y, w, h;
  boolean active = true;  // if it is on the screen
  PImage image; 
  
  public Rock(float x, PImage image){
    this.x = x;  
    this.image = image; 
    this.w = image.width/5; 
    this.h = image.height/5; 
  }
  
  // getters: 
  float getX(){return this.x;}
  float getY(){return this.y;}
  boolean getActive(){return active;}
  
  // Change if the rock is displayed
  void changeActive(){
    if (active){
      active = false; 
    }
  }
  
  // Display the rock on the screen
  void display(){
    if(active){
      image(image, x, y, w, h);
      y = y + 5; 
      if(y > 530){active = false;}
    }
  }
  
  // Move the rock to the right
  void move_right(){
    this.x = this.x - 5; 
    if(this.x + this.w < 0){active = false;} // if it leaves the screen, do not display it
  }
  
  // Move the rock to the left
  void move_left(){
    this.x = this.x + 5; 
    if(!active && this.x + this.w > 0){
      if(this.y < 520){active = true;}
    } // if it re-enters the screen, display it
  }
  
  // If the rock hits the sprite
  boolean hit_sprite(Sprite s){
    if(active){
      if ((s.get_x() + s.get_w() - 50 >= this.x) && (s.get_x() <= this.x + this.w)){ // the x range
        if(this.y + this.h >= s.get_y() + 20 && this.y + this.h <= s.get_y() + s.get_h() + 20){ // the y range
          active = false; 
          text("Hit!", 400, 400);
          return true;
        }
        else{return false;}
      }
      return false;
    }
    return false;
  }

}
