public class Flickable {
  
  float left, top, right, bottom, w, h, oldY;
  float movement = 0;  
  float rectHeight;
  ArrayList<Object> elements = new ArrayList<Object>();
  ArrayList<Float> elementsTop = new ArrayList<Float>();
  boolean moving = false;
  int selected = 0;
  color bg;
  public Flickable(ArrayList e, float l, float t, float r, float b, float numDisplayed, color c){
    left = l;
    top = t;
    right = r;
    bottom = b;
    w = right - left;
    h = bottom - top;
    rectHeight = h / numDisplayed;
    bg = c;
    for (int i = 0; i < e.size(); ++i){
      addElement(e.get(i));
    }
  }
  
  public void addElement(Object o){
    elementsTop.add(top + elements.size() * rectHeight);
    elements.add(o);
    moving = false;
    movement = 0;
  }
  
  public void clearElements(){
    elements.clear();
    elementsTop.clear();
  }
  
  public FlickableOption getSelected(){
    return (FlickableOption)elements.get(selected);
  }
  
  public boolean touched(float xPos, float yPos){
    if(xPos >= left && xPos <= right && yPos >= top && yPos <= bottom){
      oldY = yPos;
      return true;
    }
    else{
      return false;
    }
  }
  
  public void drawF(){
    fill(0);
    this.moveIt();
    this.drawIt();
    this.saveIt();
  }
  
  private void moveIt(){
    if (moving){
      movement = lastTouchPos.y - oldY;
      oldY = lastTouchPos.y;
      for (int i = 0; i < elements.size(); i++){
        elementsTop.set(i, elementsTop.get(i) + movement);
      }
    }
    else {
      if (abs(movement) > 1){
        for (int i = 0; i < elements.size(); i++){
          elementsTop.set(i, elementsTop.get(i) + movement);
        }
        movement = movement*friction;
      }
    }
  }
  
  private void drawIt(){
    fill(bg);
    rect(left, top, right, bottom);
    fill(240);
    textAlign(CENTER);
    textSize(h/10);
    text("FLICK\nZONE", left + w/2, top + 11*h/24); 
    for (int i = 0; i < elements.size(); i++){
      if(elementsTop.get(i) > top - rectHeight && elementsTop.get(i) < bottom){
        if(dist(left, elementsTop.get(i), left, top) < rectHeight/2){
          if (selected != i){
            selected = i;
            if(elements.get(i) instanceof TimelineOption){
              updateTexts();
            }
          }
        }
        boolean currentOption = false;
        if(i == selected){
          currentOption = true;
        }
        if(elements.get(i) instanceof String){
        }
        else{
          FlickableOption test = (FlickableOption)(elements.get(i));
          test.drawIt(left, (float)elementsTop.get(i), w, rectHeight, currentOption, bg);
        }
      }
//      rect(left, elementsTop.get(i), right, elementsTop.get(i) + rectHeight);
//      fill(40);
//      textAlign(LEFT);
//      textSize(2*rectHeight / 3);
//      text(elements.get(i).toString(), left + 10*scaleFactor, elementsTop.get(i) + 2*rectHeight/3);
    }
  }
  
  private void saveIt(){
    //Pull back into list bounds
    if(elements.size() > 0){
      if (elementsTop.get(elements.size()-1) < top){
        float temp = top - elementsTop.get(elements.size() - 1);
        for(int i = 0; i < elements.size(); i++){
          if (temp < 2){
            elementsTop.set(i, elementsTop.get(i) + temp); 
          }
          else{
            elementsTop.set(i, elementsTop.get(i) + temp*friction);
          }
        }
      }
      if (elementsTop.get(0) > top){
        float temp = elementsTop.get(0) - top;
        for(int i = 0; i < elements.size(); i++){
          if (temp < 2){
            elementsTop.set(i, elementsTop.get(i) - temp); 
          }
          else{
            elementsTop.set(i, elementsTop.get(i) - temp*friction);
          }
        }
      }
    }
  }
}
