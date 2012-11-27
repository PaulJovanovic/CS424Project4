public class TimelineOption extends FlickableOption {
  Button warning;
  public TimelineOption(String d, int i, ArrayList<String> e) {
    super(d, i, e);
    warning = new Button("!", 0, 0, 0, 0, 2*scaleFactor, #FA8A11, 240);
    warning.bigFont();
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    warning.move(left + w - 3*h/4, top + h/4, left + w - h/4, top + 3*h/4);
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
    text("Date: " + display, left + h/4, top + h*.7);
    stroke(stroke_color);
    warning.drawIt();
//    for(int i = 0; i < listing.size() && i < 12; i++){
//      if(timeline_sub.selected != i){
//        stroke(stroke_color);
//        fill(color(category_colors.get(i), 60));
//        rect(left + h/4 + i*h/4, top + 5*h/8, left + h/2 + i*h/4, top + 7*h/8);
//      }
//    }
//    if (listing.size() > timeline_sub.selected){
//      stroke(#FF6600);
//      fill(color(category_colors.get(timeline_sub.selected), 255));
//      rect(left + h/8 + timeline_sub.selected*h/4, top + h/2 - h/8, left + h/2 + timeline_sub.selected*h/4 + h/8, top + 7*h/8);
//    }
//    stroke(stroke_color);
  }
}
