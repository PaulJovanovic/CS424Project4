public class WordListOption extends FlickableOption {
  public WordListOption(String d, int i, ArrayList<String> e) {
    super(d, i, e);
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
    fill(bg);
    rect(left, top, left + w, top + h);
    fill(40);
    textAlign(LEFT);
    textSize(h/2);
    fill(240);
    text(display, left + h/4, top + h*.7);
    textAlign(RIGHT);
    text(id, left + w - h/4, top + h*.7);
  }
}
