class Floor{
  float x, y, w, h;
  String type;  // types = normal, small, bridge etc.
  PImage img;
  boolean active = true; // if it is on the screen 
  
  Floor(float x, float y, String t, PImage image){
    this.x = x;
    this.y = y; 
    this.w = image.width; 
    this.h = image.height;
    this.type = t;
    this.img = image; 
  }
  
  /**
    Draw the floor img on the screen
  **/ 
  void display(){
    if(active){image(img, x, y, img.width, img.height);}
  }
  
  /**
    Check if the right of the sprite is touching the left of the floor
  **/
  boolean touching_left(Sprite s){
    if(active){
      if(type.equals("spike")){
        if ((s.get_x() + s.get_w() - 50 >= this.x) && (s.get_x() + 35 <= this.x + 5)){
        if(this.y + this.h >= s.get_y() + 10 && this.y + this.h <= s.get_y() + s.get_h() - 10){return true;}
        else{return false;}
        }
      }else if ((s.get_x() + s.get_w() - 68 >= this.x) && (s.get_x() + 35<= this.x + 5)){
        if(this.y + this.h >= s.get_y() + 10 && this.y + this.h <= s.get_y() + s.get_h() - 10){return true;}
        else{return false;}
        }
      else{return false; }
    }
    return false;
  }
  
  
  // Check if the left of the Sprite is touching the right of the floor
  boolean touching_right(Sprite s){
    if(active){
      if(type.equals("normal") || type.equals("small")){
        if ((s.get_x() <= this.x + this.w - 75) && (s.get_x() >= this.x + this.w - 95)){
          if(this.y + this.h >= s.get_y() + 10 && this.y + this.h <= s.get_y() + s.get_h() - 10){return true;}
          else{return false;}
        }
        else{return false; }
      }
      return false;
    }
    return false;
  }
  
  // If the sprite falls into the hole
  boolean touching_top(Sprite s){
    if(active){
      if(type.equals("hole")){
        if ((s.get_x() + s.get_w() - 80 >= this.x) && (s.get_x() + 35 <= this.x + this.w)){
          if(this.y <= s.get_y() + s.get_h() && s.get_y() + s.get_h() <= this.y + this.h){
            return true; 
          }
        }
        return false;
      }
      return false; 
    }
    return false; 
  }

  
  
  // Getters:
  String get_type(){return type;}
  float get_x(){return x;}
  float get_y(){return y;}
  float get_w(){return w;}
  
  
  /**
    Move the floor to the right
  **/
  void move_right(){
    this.x = this.x - 5; 
    if(this.x + this.w < 0){active = false;} // if it is not on the screen, do not display it
  }
  
  /**
    Move the floor to the left 
  **/ 
  void move_left(){
    this.x = this.x + 5; 
    if(!active && this.x + this.w > 0){active = true;} // if the screen is back on the screen, make it active
  }


  /**
     If the floor is on the screen
  **/ 
  boolean active(){
    return active; 
  }


}
