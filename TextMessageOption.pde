public class TextMessageOption extends FlickableOption {
  public TextMessageOption(String d, ArrayList<String> e) {
    super(d, e);
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    fill(bg);
    fill(#7D1324);
    rect(left, top, left + w, top + h);
    
    //drawTextMessageMenu();
    fill(#45040F);
    textAlign(CENTER);
    textSize(h/4);
    float menuLeft = left + 3*w/4;
    float menuWidth = w/4;
    rect(menuLeft, top, menuLeft + menuWidth, top+h);
    fill(200);
    float spacing = 10* scaleFactor;
    float menuButtonWidth = (menuWidth - 3*spacing)/2;
    float menuButtonLeft = menuLeft + spacing;
    rect(menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor);
    fill(40);
    text("Map It!", menuButtonLeft + menuButtonWidth / 2, top+3*h/5);
    fill(200);
    menuButtonLeft = menuButtonLeft + spacing + menuButtonWidth;
    rect(menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor);
    fill(40);
    text("More...", menuButtonLeft + menuButtonWidth / 2, top+3*h/5);
    
    textAlign(LEFT);
    textSize(h/5);
    fill(240);
    text("When is ribbon cutting on Grand Ave Project? Should be done about now. (WHAT??? HAVEN'T LAID A BRICK?) Way to go Jan Perry & County Supe", left + w/4 + 10 * scaleFactor, top + h/5, left + 3*w/4 - 10 * scaleFactor, top + h);
    textSize(h/2);
    fill(#45040F);
    rect(left, top, left + w / 4, top + h);
    fill(240);
    text("#" + display, left + h/4, top + h/2);
    textSize(h/4);
    fill(200);
    text("Date: " + display, left + h/4, top + 7*h/8);
    fill(#136EAB);
    for(int i = 0; i < listing.size() && i < 23; i++){
      rect(left + h/4 + i*h/4, top + 5*h/8, left + h/2 + i*h/4, top + 7*h/8);
    }
  }
}
