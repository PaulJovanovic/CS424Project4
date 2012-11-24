import processing.net.*;
import java.util.*;

DatabaseAdapter DB;
PApplet applet;

ArrayList<String> dates;
ArrayList<String> messageIds;
ArrayList<String> messageDetails;
TextMessage tx;

void setup(){ 
  size(600, 400);
 
  applet = this;
  //DB = new DatabaseAdapter(this, "cs424", "cs424", "microblogs", "omgtracker.evl.uic.edu");
  DB = new DatabaseAdapter(this, "root", "anna", "microblogs", "localhost:3306");
  loadData();
}

public void loadData() {
//  println("Getting years...");
//  dates = DB.getDates();
//  println("Years complete");
//  println(dates.get(0));
  
//  println("Getting message IDs...");
//  messageIds = DB.getMessageIds("2011-05-20", "this");
//  println("Message IDs complete");
//  println(messageIds.get(0));
  
//  println("Getting message IDs...");
//  messageIds = DB.getMessageIds("3");
//  println("Message IDs complete");
//  println(messageIds.get(2));
  
  println("Getting message details...");
  tx = DB.getMessageDetails("1");
  println("Message details complete");
  println(tx.date);
  println(tx.time);
  println(tx.location);
  println(tx.content);
  println(tx.latitude);
  println(tx.longitude);

}
