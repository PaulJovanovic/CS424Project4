public class TimelineSubOption extends FlickableOption {
  public TimelineSubOption(String d, int i, ArrayList<String> e) {
    super(d, i, e);
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    if(selected){
      fill(#136EAB);
    }
    else{
      fill(bg);
    }
    rect(left, top, left + w, top + h);
    fill(category_colors.get(id));
    rect(left + h/4, top + h/4, left + 3*h/4, top + 3*h/4);
    fill(40);
    textAlign(LEFT);
    textSize(h / 2);
    fill(240);
    text("Category", left + h, top + .7*h);
    textAlign(RIGHT);
    text(id, left + w - h/4, top + .7*h);
  }
}
