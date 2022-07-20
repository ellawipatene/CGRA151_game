class Potion{
  float x, y, w, h;
  PImage[] img; 
  int img_counter = 0;
  
  Potion(float x, float y, PImage[] image){
    this.x = x;
    this.y = y;
    this.w = image[0].width/10;
    this.h = image[0].height/10;
    this.img = image;
  }
  
  /**
    Displays the potion on the screen
  **/
  void display(){
    image(img[img_counter], x, y, img[img_counter].width/10, img[img_counter].height/10); 
    if (img_counter < 8){img_counter++;}
    else{img_counter = 0;}
  }
  
  /**
    Checks if the Sprite has touched the potion
  **/
  boolean collected(Sprite s){
    if(s.get_x() + s.get_w() - 50 == this.x){
      return true; 
    }
    return false;
  }
  
  // Move the potion to the right
  void move_right(){
    this.x = this.x - 5; 
  }
  
  // Move the potion to the left
  void move_left(){
    this.x = this.x + 5; 
  }


}
