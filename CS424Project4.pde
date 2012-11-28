import org.gicentre.utils.colour.*;
import org.gicentre.utils.io.*;
import org.gicentre.utils.gui.*;
import org.gicentre.utils.move.*;
import org.gicentre.utils.multisketch.*;
import org.gicentre.utils.stat.*;
import org.gicentre.utils.*;
import org.gicentre.utils.network.*;
import org.gicentre.utils.spatial.*;
import org.gicentre.utils.geom.*;

import hypermedia.net.*;
import omicronAPI.*;
import processing.net.*;

final static int WALLWIDTH = 8160;
final static int WALLHEIGHT = 2304;

String currentWord = "";
String currentLocation = "";

OmicronAPI omicronManager;
TouchListener touchListener;
PApplet applet;
boolean displayOnWall = false;

DatabaseAdapter DB;

float scaleFactor;
int dWidth, dHeight;

PFont font;

PVector lastTouchPos = new PVector();
PImage v_map;


//Flickable menus
Flickable timeline;
Flickable timeline_sub;
Flickable text_messages;
Flickable word_list;

int maxY = 0;
int minY = 0;
float avgY = 0;
float stdY = 0;
//float imageScale = 10.04924;

float friction = 63.0/64.0;

int oldTimelineSelected;

color stroke_color = #7C8387;
color bg_color = #17191A;
HashMap<Integer, Integer> category_colors = new HashMap<Integer, Integer>();

float xChangePixels;
float yChangePixels;

//Buttons
Button[] mapButtons = new Button[4];
Button searchButton;
Button wordButton;
Button wordListButton;
Keyboard kb;

//view controls
boolean textView = false;
boolean keyboardView = true;


//Graph
XYChart lineChart;

ArrayList<String> dates;
ArrayList<String> messageIds;
ArrayList<String> messageDetails;
//Date -> messages
HashMap<String, ArrayList<TextMessage>> messages = new HashMap<String, ArrayList<TextMessage>>();


public void init() {
  super.init();
  omicronManager = new OmicronAPI(this);      
  if(displayOnWall) {
      omicronManager.setFullscreen(true);
      omicronManager.ConnectToTracker(7001, 7340, "131.193.77.159");
  }
}

void setup(){
  scaleFactor = (displayOnWall)?6:1; // 1 for widescreen monitors and 6 for the wall
  dWidth = (int)((WALLWIDTH / 6) * scaleFactor);
  dHeight = (int)((WALLHEIGHT / 6) * scaleFactor);
  
  size(dWidth, dHeight, P2D);
  applet = this;
  touchListener = new TouchListener();
  omicronManager.setTouchListener(touchListener);
  DB = new DatabaseAdapter(this, "root", "root", "project4", "localhost:3306");
  
  lineChart = new XYChart(this);
  lineChart.setPointSize(scaleFactor*4);
  lineChart.setLineWidth(scaleFactor*4);
  
  loadData();
  
  
  category_colors.put(0, #911616);
  category_colors.put(1, #249116);
  category_colors.put(2, #165E91);
  category_colors.put(3, #831691);
  category_colors.put(4, #918F16);
  category_colors.put(5, #915C16);
  category_colors.put(6, #FA2626);
  category_colors.put(7, #3EFA26);
  category_colors.put(8, #26A2FA);
  category_colors.put(9, #E226FA);
  category_colors.put(10, #FAF626);
  category_colors.put(11, #FA9F26);
  
  v_map = loadImage("map_grayscale_yellow.png");
  float imageScale = v_map.height / text_messages.h;
  v_map.resize(Math.round(v_map.width/imageScale), Math.round(v_map.height/imageScale));
  
  //UI Buttons
  float spacing = 10*scaleFactor;
  float buttonWidth = text_messages.w - v_map.width - 2*spacing;
  float buttonHeight = (text_messages.h - 5 * spacing) / mapButtons.length;
  for (int i = 0; i < mapButtons.length; ++i){
    mapButtons[i] = new Button("Text" + i, text_messages.left + v_map.width + spacing, text_messages.top + spacing*(i+1) + buttonHeight*i, text_messages.left + v_map.width + spacing + buttonWidth, text_messages.top + spacing*(i+1) + buttonHeight*(i+1), 2*scaleFactor, 240, 40);
  }
  mapButtons[0].label = "Population";
  mapButtons[1].label = "Weather";
  mapButtons[2].label = "Something";
  mapButtons[3].label = "Texts";
  
  wordButton = new Button(currentWord, timeline_sub.left + 10*scaleFactor, timeline_sub.bottom + 10*scaleFactor, timeline_sub.right - 10*scaleFactor, timeline_sub.bottom + 40*scaleFactor, 2*scaleFactor, timeline_sub.bg, 240);
  wordButton.bigFont();
  searchButton = new Button("Search", wordButton.left, wordButton.bottom + 10 * scaleFactor, wordButton.left + wordButton.w/2 - 5*scaleFactor, wordButton.bottom + 40*scaleFactor, 2*scaleFactor, timeline_sub.bg, 240);
  searchButton.bigFont();
  wordListButton = new Button("Words", wordButton.right - wordButton.w/2 + 5*scaleFactor, wordButton.bottom + 10 * scaleFactor, wordButton.right, wordButton.bottom + 40*scaleFactor, 2*scaleFactor, timeline_sub.bg, 240);
  wordListButton.bigFont();
  
  kb = new Keyboard(timeline_sub.left, wordListButton.bottom + 35 * scaleFactor, timeline.left, dHeight);
  
  xChangePixels = v_map.width;
  yChangePixels = text_messages.bottom - text_messages.top;
  
  font = createFont("Helvetica", 48);
  textFont(font);
  rectMode(CORNERS);
  strokeWeight(scaleFactor);
  stroke(stroke_color);
  smooth();
  println("Setup complete");
}

void draw(){
  background(bg_color);
  strokeWeight(scaleFactor);
  if(textView){
    text_messages.drawF();
  }
  else{
    image(v_map, text_messages.left, text_messages.top);
    fill(#360D0C);
    rect(text_messages.left + v_map.width, text_messages.top, text_messages.left + text_messages.w, text_messages.bottom);
    for (int i = 0; i < mapButtons.length; ++i){
      mapButtons[i].drawIt();
    }
    drawPoints();
    drawPoint();
    //Weather
    //Population
    //Trends
    //Texts
  }
  fill(bg_color);
  strokeWeight(0);
  rect(text_messages.left-scaleFactor, 0, text_messages.right+scaleFactor, text_messages.top);
  rect(text_messages.left-scaleFactor, text_messages.bottom, text_messages.right+scaleFactor, dHeight);
  strokeWeight(scaleFactor);
  drawTimeline();
//  drawWord();
//  drawKeyBoard();
  omicronManager.process();
}

void drawTimeline(){
  timeline.drawF();
  //drawTimelineSub();
  drawWordlist();
  drawGraph();
}

void drawTimelineSub(){
  timeline_sub.drawF();
}

void drawGraph(){
  fill(#1F2224);
  rect(timeline.left - 300 * scaleFactor, 0, timeline.left, 3*dHeight/8);
  lineChart.draw(timeline.left - 300 * scaleFactor, 0, 300*scaleFactor, 3*dHeight/8);
  
  float distance = timeline.elementsTop.get(0)/(timeline.elementsTop.size()*timeline.rectHeight-timeline.rectHeight/2)*300*scaleFactor;
  rect(timeline.left - 300 * scaleFactor - distance, 0, timeline.left - 300 * scaleFactor - distance + scaleFactor, 3*dHeight/8); 
}

//(42.3017, 93.5673)
//(42.1609, 93.1923)
float xMaxDegree = 93.5673;
float yMaxDegree = 42.3017;
float xChangeDegree = 93.5673 - 93.1923;
float yChangeDegree = 42.3017 - 42.1609;

void drawPoints(){
  String date = dates.get(timeline.selected+1);
  ArrayList<TextMessage> txts = messages.get(date);
  strokeWeight(scaleFactor*6);
  stroke(#FA8A11);
  for(int i = 0; i < txts.size(); i++){
    String[] location = txts.get(i).location.split(" ");
    float xP = Float.parseFloat(location[1]);
    float yP = Float.parseFloat(location[0]);
    point(text_messages.left + (xMaxDegree - xP)/xChangeDegree*xChangePixels, text_messages.top + (yMaxDegree - yP)/yChangeDegree*yChangePixels);
  }
}

void drawWordlist(){
  fill(timeline_sub.bg);
  rect(timeline_sub.left, timeline_sub.bottom, timeline_sub.right, dHeight);
  if (keyboardView){
    kb.drawIt();
  }
  else{
    word_list.drawF();
  }
  fill(#263A42);
  rect(timeline_sub.left, timeline_sub.bottom, timeline_sub.right, wordListButton.bottom+10*scaleFactor);
  wordButton.label = currentWord;
  wordButton.drawIt();
  searchButton.drawIt();
  wordListButton.drawIt();
//  searchButton = new Button(String s, float l, float t, float r, float b, float rad, int bg, int tc){
//  
//  float textXOffset = 10 * scaleFactor;
//  float textYOffset = 10 * scaleFactor;
//  float spacing = 10 * scaleFactor;
//  float padding = 5 * scaleFactor;
//  float rectHeight = (dHeight - timeline_sub.bottom - 6*spacing)/8f;
//  textSize(14* scaleFactor);
//  textAlign(LEFT);
//  for(int i = 0; i < timeline_sub.selected; i++){
//    float tw = textWidth(i + "");
//    if(timeline_sub.left + tw + spacing + padding*2 + textXOffset > timeline_sub.right){
//      textYOffset += rectHeight + spacing;
//      textXOffset = 10*scaleFactor;
//    }
//    float textX = timeline_sub.left + textXOffset;
//    float textY = timeline_sub.bottom + textYOffset;
//    fill(240);
//    rect(textX, textY, textX + padding*2 +tw, textY + rectHeight, 2 * scaleFactor);
//    fill(40);
//    text(i + "",textX + padding, textY + 2*(rectHeight)/3);
//    textXOffset = textXOffset + spacing + padding*2 +tw;
//  }
}

public void loadData() {
  println("Getting years...");
  dates = DB.getDates();
  println("Years complete");
  for(int i = 1; i < dates.size(); i++){
    ArrayList<TextMessage> tm;
    tm = new ArrayList<TextMessage>();
    messages.put(dates.get(i), tm);
  }
  
//  println("Getting message IDs...");
//  messageIds = DB.getMessageIdsForWord("accident");
//  println("Message IDs complete");
//  
////  println("Getting message IDs...");
////  messageIds = DB.getMessageIds("5/20/2011", "sick");
////  println("Message IDs complete");
////  println(messageIds.get(0));
////  println(messageIds.size());
////  
////  println("Getting message IDs...");
////  messageIds = DB.getMessageIds("3");
////  println("Message IDs complete");
////  println(messageIds.get(2));
////  
//  println("Getting message details...");
//  for(int i = 0; i < messageIds.size(); i++){
//    TextMessage tx;
//    tx = DB.getMessageDetails(messageIds.get(i));
//    messages.get(tx.date.split(" ")[0]).add(tx);
//  }
//  println("Message details complete");
//  println(messages.get("2011-05-20").size());

  ArrayList<TimelineOption> something = new ArrayList<TimelineOption>();
  ArrayList<String> somethingElse = new ArrayList<String>();
  for(int i = 0; i < messages.size(); ++i){
    somethingElse.clear();
    for(int j = 0; j < i; j++){
      somethingElse.add(j+"");
    }
    something.add(new TimelineOption(dates.get(i+1), i, somethingElse));
  }
  timeline = new Flickable(something, dWidth - 240 * scaleFactor, 0, dWidth, dHeight, 8f, #021A24);
  
  oldTimelineSelected = timeline.selected;

  ArrayList<TimelineSubOption> timelineOptionSub = new ArrayList<TimelineSubOption>();
  for(int i = 0; i < 12; ++i){
    timelineOptionSub.add(new TimelineSubOption(i + "", i, new ArrayList()));
  }
  timeline_sub = new Flickable(timelineOptionSub, timeline.left - 300 * scaleFactor, 0, timeline.left, 3*dHeight/8, 4f, #1F2224);

  word_list = new Flickable(new ArrayList<WordListOption>(), timeline.left - 300 * scaleFactor, timeline_sub.bottom + 90*scaleFactor, timeline.left, dHeight, 4f, #1F2224);

  updateData();
}

void clearData(){
  for (int i = 0; i < messages.size(); i++){
    messages.get(dates.get(i+1)).clear();
  }
  messageIds.clear();
  maxY = 0;
}

void updateData(){
  println("Updating data");
    messageIds = DB.getMessageIdsForWord(currentWord);
    
    println("getting text data");
    for(int i = 0; i < messageIds.size(); i++){
      TextMessage tx;
      tx = DB.getMessageDetails(messageIds.get(i));
      messages.get(tx.date.split(" ")[0]).add(tx);
    }
    
    println("saving texts to flickable");
    ArrayList<TextMessageOption> textMessageOptions = new ArrayList<TextMessageOption>();
    ArrayList<TextMessage> txts = messages.get(dates.get(timeline.selected + 1));
    for(int i = 0; i < txts.size(); ++i){
      ArrayList<String> information = new ArrayList<String>();
      information.add(txts.get(i).personId);//0
      information.add(txts.get(i).date);//1
      information.add(txts.get(i).time);//2up
      information.add(txts.get(i).content);//3
      information.add(txts.get(i).location);//4
      textMessageOptions.add(new TextMessageOption(txts.get(i).personId, i, information));
    }
    text_messages = new Flickable(textMessageOptions, 20*scaleFactor, 40*scaleFactor, timeline_sub.left - 20 * scaleFactor, dHeight - 20*scaleFactor, 4f, #360D0C);
    
    println("filling in graph data");
    float[] yValues = new float[messages.size()];
    float[] xValues = new float[messages.size()];
    float total = 0;
    for(int i = 1; i < dates.size(); i++){
      xValues[i-1] = i;
      yValues[i-1] = (float)messages.get(dates.get(i)).size();
      total += yValues[i-1];
    }
    maxY = (int)max(yValues);
    minY = (int)min(yValues);
    avgY = total / (dates.size() - 1);
    
    total = 0;
    for(int i = 1; i < dates.size(); i++){
      total += sq(messages.get(dates.get(i)).size() - avgY);
    }
    total /= dates.size() - 1;
    stdY = sqrt(total);
    
    lineChart.setData(xValues, yValues);
    lineChart.setMaxY(maxY);
    lineChart.setMinY(minY);
    println("Updating data complete");
}

void updateTexts(){
  text_messages.clearElements();
  ArrayList<TextMessageOption> textMessageOptions = new ArrayList<TextMessageOption>();
  ArrayList<TextMessage> txts = messages.get(dates.get(timeline.selected + 1));
  for(int i = 0; i < txts.size(); ++i){
    ArrayList<String> information = new ArrayList<String>();
    information.add(txts.get(i).personId);//0
    information.add(txts.get(i).date);//1
    information.add(txts.get(i).time);//2up
    information.add(txts.get(i).content);//3
    information.add(txts.get(i).location);//4
    text_messages.addElement(new TextMessageOption(txts.get(i).personId, i, information));
  }
  
  word_list.clearElements();
  ArrayList wordlist = DB.getWordsFromDate(dates.get(timeline.selected + 1));
  for(int i = 0; i < wordlist.size(); i+=2){
    word_list.addElement(new WordListOption(wordlist.get(i).toString(), Integer.parseInt(wordlist.get(i+1).toString()), new ArrayList<String>()));
  }
  //text_messages = new Flickable(textMessageOptions, 20*scaleFactor, 40*scaleFactor, timeline_sub.left - 20 * scaleFactor, dHeight - 20*scaleFactor, 4f, #360D0C);
}

void drawPoint(){
  if(currentLocation != ""){
    strokeWeight(scaleFactor*6);
    stroke(#FF0000);
    String[] location = currentLocation.split(" ");
    float xP = Float.parseFloat(location[1]);
    float yP = Float.parseFloat(location[0]);
    point(text_messages.left + (xMaxDegree - xP)/xChangeDegree*xChangePixels, text_messages.top + (yMaxDegree - yP)/yChangeDegree*yChangePixels);
  }
}

void updateTextsByUser(String userId){
  text_messages.clearElements();
  ArrayList<String> messageids = DB.getMessageIds(userId);
  ArrayList<TextMessage> txts = new ArrayList<TextMessage>();
  for(int i = 0; i < messageids.size(); i++){
    txts.add(DB.getMessageDetails(messageids.get(i)));
  }
  for(int i = 0; i < txts.size(); ++i){
    ArrayList<String> information = new ArrayList<String>();
    information.add(txts.get(i).personId);//0
    information.add(txts.get(i).date);//1
    information.add(txts.get(i).time);//2up
    information.add(txts.get(i).content);//3
    information.add(txts.get(i).location);//4
    text_messages.addElement(new TextMessageOption(txts.get(i).personId, i, information));
  }
}

void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
  // Update the last touch position
  lastTouchPos.x = xPos;
  lastTouchPos.y = yPos;
  timeline.moving = timeline.touched(xPos, yPos);
  timeline_sub.moving = timeline_sub.touched(xPos, yPos);
  if(textView){
    boolean buttonTouched = false;
    for(int i = 0; i < text_messages.elements.size(); i++){
      TextMessageOption temp = (TextMessageOption)text_messages.elements.get(i);
      if(temp.buttonsTouched(xPos, yPos)){
        buttonTouched = true;
      }
    }
    if(!buttonTouched){
      text_messages.moving = text_messages.touched(xPos, yPos);
    }
  }
  if(keyboardView){
    kb.touched(xPos, yPos);
  }
  else{
    word_list.moving = word_list.touched(xPos, yPos);
  }
  if(searchButton.touched(xPos, yPos)){
    clearData();
    updateData();
  }
  if(wordListButton.touched(xPos, yPos)){
    if (wordListButton.label == "Words"){
      wordListButton.label = "Keyboard";
      keyboardView = !keyboardView;
    }
    else{
      wordListButton.label = "Words";
      keyboardView = !keyboardView;
    }
  }
  if(textView == false){
    if(mapButtons[3].touched(xPos, yPos)){
      textView = true;
    }
  }
  // Add a new touch ID to the list
//  Touch t = new Touch( ID, xPos, yPos, xWidth, yWidth );
//  touchList.put(ID,t);
}// touchDown

void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
  lastTouchPos.x = xPos;
  lastTouchPos.y = yPos;
}// touchMove

void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
  lastTouchPos.x = xPos;
  lastTouchPos.y = yPos;
  timeline.moving = false;
  timeline_sub.moving = false;
  text_messages.moving = false;
  word_list.moving = false;
}
