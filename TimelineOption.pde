public class TimelineOption extends FlickableOption {
  public TimelineOption(String d, int i, ArrayList<String> e) {
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
    fill(40);
    textAlign(LEFT);
    textSize(h/2);
    fill(240);
    text("Date: " + display, left + h/4, top + h/2);
    for(int i = 0; i < listing.size() && i < 23; i++){
      if(timeline_sub.selected == i){
        stroke(#FF6600);
        fill(color(category_colors.get(i), 255));
      }
      else{
        stroke(stroke_color);
        fill(color(category_colors.get(i), 120));
      }
      rect(left + h/4 + i*h/4, top + 5*h/8, left + h/2 + i*h/4, top + 7*h/8);
    }
    stroke(stroke_color);
  }
}
