public class TimelineSubOption extends FlickableOption {
  public TimelineSubOption(String d, ArrayList<String> e) {
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
    fill(240);
    rect(left + h/4, top + h/4, left + 3*h/4, top + 3*h/4);
    fill(40);
    textAlign(LEFT);
    textSize(h / 2);
    if (selected){
      fill(240);
    }
    else{
      fill(240);
    }
    text("Category", left + h, top + .7*h);
    textAlign(RIGHT);
    text(display, left + w - h, top + .7*h);
  }
}
