import hypermedia.net.*;
import omicronAPI.*;

final static int WALLWIDTH = 8160;
final static int WALLHEIGHT = 2304;

OmicronAPI omicronManager;
TouchListener touchListener;
PApplet applet;
boolean displayOnWall = false;

float scaleFactor;
int dWidth, dHeight;

PFont font;

PVector lastTouchPos = new PVector();
PImage v_map;

Flickable timeline;
Flickable timeline_sub;
Flickable text_messages;

//float imageScale = 10.04924;

float friction = 63.0/64.0;

int oldTimelineSelected;

color stroke_color = #7C8387;
color bg_color = #17191A;
HashMap<Integer, Integer> category_colors = new HashMap<Integer, Integer>();

public void init() {
  super.init();
  omicronManager = new OmicronAPI(this);      
  if(displayOnWall) {
      omicronManager.setFullscreen(true);
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
  if(displayOnWall) {    
    omicronManager.ConnectToTracker(7001, 7340, "131.193.77.159");
  }
  
  ArrayList<TimelineOption> something = new ArrayList<TimelineOption>();
  ArrayList<String> somethingElse = new ArrayList<String>();
  for(int i = 0; i < 100; ++i){
    somethingElse.clear();
    for(int j = 0; j < i; j++){
      somethingElse.add(j+"");
    }
    something.add(new TimelineOption(i + "", i, somethingElse));
  }
  timeline = new Flickable(something, dWidth - 300 * scaleFactor, 0, dWidth, dHeight, 8f, #263A42);
  
  oldTimelineSelected = timeline.selected;
  
  ArrayList<TimelineSubOption> timelineOptionSub = new ArrayList<TimelineSubOption>();
  for(int i = 0; i < 23; ++i){
    timelineOptionSub.add(new TimelineSubOption(i + "", i, new ArrayList()));
  }
  timeline_sub = new Flickable(timelineOptionSub, timeline.left - 240 * scaleFactor, 0, timeline.left, 3*dHeight/8, 4f, #1F2224);
  
  
  ArrayList<TextMessageOption> textMessageOptions = new ArrayList<TextMessageOption>();
  for(int i = 0; i < 10; ++i){
    textMessageOptions.add(new TextMessageOption(i + "", i, new ArrayList()));
  }
  text_messages = new Flickable(textMessageOptions, 20*scaleFactor, 40*scaleFactor, timeline_sub.left - 20 * scaleFactor, dHeight - 20*scaleFactor, 4f, #360D0C);
  
  
  for(int i = 0; i < 23; i++){
    category_colors.put((Integer)i, 255/23*i);
  }
  v_map = loadImage("map.png");
  float imageScale = v_map.height / text_messages.h;
  v_map.resize(Math.round(v_map.width/imageScale), Math.round(v_map.height/imageScale));
  
  font = createFont("Helvetica", 48);
  textFont(font);
  rectMode(CORNERS);
  strokeWeight(scaleFactor);
  stroke(stroke_color);
  smooth();
}

void draw(){
  background(bg_color);
  strokeWeight(scaleFactor);
  if(false){
    text_messages.drawF();
  }
  else{
    image(v_map, text_messages.left, text_messages.top);
    fill(#360D0C);
    rect(text_messages.left + v_map.width, text_messages.top, text_messages.left + text_messages.w, text_messages.bottom);
    float spacing = 10*scaleFactor;
    float buttonWidth = text_messages.w - v_map.width - 2*spacing;
    float buttonHeight = (text_messages.h - 5 * spacing) / 4;
    for (int i = 0; i < 4; ++i){
      fill(240);
      rect(text_messages.left + v_map.width + spacing, text_messages.top + spacing*(i+1) + buttonHeight*i, text_messages.left + v_map.width + spacing + buttonWidth, text_messages.top + spacing*(i+1) + buttonHeight*(i+1));
    }
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
  omicronManager.process();
}

void drawTimeline(){
  timeline.drawF();
  drawTimelineSub();
  drawWordlist();
}

void drawTimelineSub(){
  timeline_sub.drawF();
}

void drawWordlist(){
  fill(#17191A);
  rect(timeline_sub.left, timeline_sub.bottom, timeline_sub.right, dHeight);
  
  float textXOffset = 10 * scaleFactor;
  float textYOffset = 10 * scaleFactor;
  float spacing = 10 * scaleFactor;
  float padding = 5 * scaleFactor;
  float rectHeight = (dHeight - timeline_sub.bottom - 6*spacing)/8f;
  textSize(14* scaleFactor);
  textAlign(LEFT);
  for(int i = 0; i < timeline_sub.selected; i++){
    float tw = textWidth(i + "");
    if(timeline_sub.left + tw + spacing + padding*2 + textXOffset > timeline_sub.right){
      textYOffset += rectHeight + spacing;
      textXOffset = 10*scaleFactor;
    }
    float textX = timeline_sub.left + textXOffset;
    float textY = timeline_sub.bottom + textYOffset;
    fill(240);
    rect(textX, textY, textX + padding*2 +tw, textY + rectHeight, 2 * scaleFactor);
    fill(40);
    text(i + "",textX + padding, textY + 2*(rectHeight)/3);
    textXOffset = textXOffset + spacing + padding*2 +tw;
  }
}

void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
  // Update the last touch position
  lastTouchPos.x = xPos;
  lastTouchPos.y = yPos;
  timeline.moving = timeline.touched(xPos, yPos);
  timeline_sub.moving = timeline_sub.touched(xPos, yPos);
  text_messages.moving = text_messages.touched(xPos, yPos);
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
}
