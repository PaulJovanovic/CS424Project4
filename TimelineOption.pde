public class TimelineOption extends FlickableOption {
  public TimelineOption(String d, ArrayList<String> e) {
    super(d, e);
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    if(selected){
      fill(#136EAB);
    }
    else{
      fill(bg);
    }
    rect(left, top, left + w, top + h);
    fill(40);
    textAlign(LEFT);
    textSize(h/2);
    if (selected){
      fill(240);
    }
    else{
      fill(240);
    }
    text("Date: " + display, left + h/4, top + h/2);
    fill(#136EAB);
    for(int i = 0; i < listing.size() && i < 23; i++){
      rect(left + h/4 + i*h/4, top + 5*h/8, left + h/2 + i*h/4, top + 7*h/8);
    }
  }
}
