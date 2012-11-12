public class FlickableOption {
  String display;
  ArrayList listing = new ArrayList();
  public FlickableOption(String d, ArrayList l) {
    this.display = d;
    for(int i = 0; i < l.size(); ++i){
      listing.add(l.get(i));
    }
  }
  
  public void drawIt(float left, float top, float w, float h, boolean selected, color bg){
  }
}
