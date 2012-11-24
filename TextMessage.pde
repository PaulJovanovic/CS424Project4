class TextMessage {
  public String date = "";
  public String time = "";
  public float latitude = 0;
  public float longitude = 0;
  public String location = "";
  public String content = "";
 
  public TextMessage(String date, String time, String location, String content) {
    this.date = date;
    this.time = time;
    this.location = location;
    this.content= content;
    
    //split location
    try
    {
      String[] strSplit = location.split(" ");
      latitude = Float.parseFloat(strSplit[0]);
      longitude = Float.parseFloat(strSplit[1]);
    }
    catch (Exception e)
    {
      println(e);
    }
    
  }
  
}
