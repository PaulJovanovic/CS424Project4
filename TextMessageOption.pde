public class TextMessageOption extends FlickableOption {
  Button mapButton;
  Button moreButton;
  public TextMessageOption(String d, int i, ArrayList<String> e) {
    super(d, i, e);
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    fill(#63100F);
    rect(left, top, left + w, top + h);
    
    //drawTextMessageMenu();
    fill(bg);
    float menuLeft = left + v_map.width;
    float menuWidth = w - v_map.width;
    float spacing = 10 * scaleFactor;
    rect(menuLeft, top, menuLeft + menuWidth, top+h);
    if(mapButton == null){
      float menuButtonWidth = (menuWidth - 3*spacing)/2;
      float menuButtonLeft = menuLeft + spacing;
      mapButton = new Button("Map", menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor, 240, 40);
      menuButtonLeft = menuButtonLeft + spacing + menuButtonWidth;
      moreButton = new Button("More", menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor, 240, 40);
    }
    mapButton.top = top+spacing;
    mapButton.bottom = top+h-spacing;
    moreButton.top = top+spacing;
    moreButton.bottom = top+h-spacing;
    mapButton.drawIt();
    moreButton.drawIt();
    
    textAlign(LEFT);
    textSize(h/5);
    fill(240);
    text("When is ribbon cutting on Grand Ave Project? Should be done about now. (WHAT??? HAVEN'T LAID A BRICK?) Way to go Jan Perry & County Supe", left + menuWidth + 10 * scaleFactor, top + h/5, left + v_map.width - 10 * scaleFactor, top + h);
    textSize(h/2);
    fill(bg);
    rect(left, top, left + menuWidth, top + h);
    fill(240);
    text("#" + display, left + spacing, top + h/2);
    textSize(h/4);
    fill(200);
    text("Date: " + display, left + spacing, top + 7*h/8);
    fill(#136EAB);
    for(int i = 0; i < listing.size() && i < 23; i++){
      rect(left + h/4 + i*h/4, top + 5*h/8, left + h/2 + i*h/4, top + 7*h/8);
    }
  }
}
