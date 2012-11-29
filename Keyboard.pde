public class Keyboard{
  float left, right, top, bottom, w, h, rectHeight;
  ArrayList<Button> keys = new ArrayList<Button>();
  String[] letters = {"q","w","e","r","t","y","u","i","o","p","a","s","d","f","g","h","j","k","l","#","z","x","c","v","b","n","m","<--"};
  
  public Keyboard(float l, float t, float r, float b){
    this.left = l;
    this.top = t;
    this.right = r;
    this.bottom = b;
    this.w = r - l;
    this.h = b - t;
    
    float spacing = 5*scaleFactor;
    float xPos = l + spacing;
    float yPos = t + spacing;
    float xDisp = 0;
    float yDisp = 0;
    float buttonWidth = (w - 11 * spacing) / 10;
    float buttonHeight = buttonWidth;
    for(int i = 0; i < letters.length; i ++){
      if(i % 10 == 0 && i != 0){
        xDisp = 0;
        yDisp+= spacing + buttonWidth;
      }
      if(i == letters.length - 1){
        buttonWidth = 3*buttonWidth + 2*spacing;
      }
      keys.add(new Button(letters[i], xPos + xDisp, yPos + yDisp, xPos + xDisp + buttonWidth, yPos + yDisp + buttonHeight, scaleFactor*2, 240, 40));
      keys.get(i).bigFont();
      xDisp += spacing + buttonWidth;
    }
  }
  
  public void drawIt(){
    for(int i = 0; i < keys.size(); i++){
      keys.get(i).drawIt();
    }
  }
  
  public void touched(float xPos, float yPos){
    for(int i = 0; i < keys.size(); i++){
      if(keys.get(i).touched(xPos, yPos)){
        if(keys.get(i).label == "<--" && currentWord.length() > 0){
          currentWord = currentWord.substring(0, currentWord.length() - 1);
        }
        else{
          currentWord += keys.get(i).label;
        }
      }
    }
  }
}
