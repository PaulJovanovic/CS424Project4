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
    float menuButtonWidth = (menuWidth - 3*spacing)/2;
    float menuButtonLeft = menuLeft + spacing;
    mapButton = new Button("Map", menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor, 240, 40);
    menuButtonLeft = menuButtonLeft + spacing + menuButtonWidth;
    moreButton = new Button("More", menuButtonLeft, top + spacing, menuButtonLeft + menuButtonWidth, top+h-spacing, 2*scaleFactor, 240, 40);
    mapButton.top = top+spacing;
    mapButton.bottom = top+h-spacing;
    moreButton.top = top+spacing;
    moreButton.bottom = top+h-spacing;
    mapButton.drawIt();
    moreButton.drawIt();
    
    textAlign(LEFT);
    textSize(h/5);
    fill(240);
    text("" + listing.get(3), left + menuWidth + 10 * scaleFactor, top + h/5, left + v_map.width - 10 * scaleFactor, top + h);
    textSize(h/3);
    fill(bg);
    rect(left, top, left + menuWidth, top + h);
    fill(240);
    text("#" + listing.get(0), left + spacing, top + h/2);
    textSize(h/4);
    fill(200);
    text("" + listing.get(2), left + spacing, top + 7*h/8);
    fill(#136EAB);
  }
  
  public boolean buttonsTouched(float xPos, float yPos){
    println(mapButton == null);
    if(mapButton == null || moreButton == null){
      return false;
    }
    if(mapButton.touched(xPos, yPos)){
      //listing of the message coordinates
      currentLocation = listing.get(4).toString();
      textView = !textView;
      return true;
    }
    else if(moreButton.touched(xPos, yPos)){
      //search for all written by that user
      updateTextsByUser(listing.get(0).toString());
      return true;
    }
    else{
      return false;
    }
  }
}
