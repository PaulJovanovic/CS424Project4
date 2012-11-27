public class Button{
  String label;
  float left, top, right, bottom, w, h, radius, fontScale;
  color background_color, text_color;
  boolean disabled;
  boolean active;
  
  public Button(String s, float l, float t, float r, float b, float rad, int bg, int tc){
    this.label = s;
    this.left = l;
    this.top = t;
    this.right = r;
    this.bottom = b;
    this.radius = rad;
    this.w = r - l;
    this.h = b - t;
    this.background_color = bg;
    this.text_color = tc;
    this.disabled = false;
    this.fontScale = 1;
  }
  
  public void move(float l, float t, float r, float b){
    this.left = l;
    this.top = t;
    this.right = r;
    this.bottom = b;
    this.w = r - l;
    this.h = b - t;
  }
  
  public void bigFont(){
    this.fontScale = 4;
  }
  
  public boolean touched(float xPos, float yPos){
    if(disabled == false){
      if(xPos >= left && xPos <= right && yPos >= top && yPos <= bottom){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }
  }
  
  public void drawIt(){
    rectMode(CORNERS);
    if(disabled == false){
      fill(background_color);
    }
    else{
      fill(150);
    }
    rect(left, top, right, bottom, radius);
    fill(text_color);
    textAlign(CENTER);
    textSize(fontScale*h/4);
    text(label, left + w / 2, top + h*(.5 + .1*fontScale));
  }
  
  public void enable(){
    this.disabled = false;
  }
  
  public void disable(){
    this.disabled = true;
  }
  
}
