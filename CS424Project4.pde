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

PVector lastTouchPos = new PVector();;

Flickable timeline;
Flickable timeline_sub;
Flickable text_messages;

float friction = 31.0/32.0;

int oldTimelineSelected;

color bg_color = #17191A;

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
    something.add(new TimelineOption(i + "", somethingElse));
  }
  timeline = new Flickable(something, dWidth - 300 * scaleFactor, 0, dWidth, dHeight, 8f, #263A42);
  
  oldTimelineSelected = timeline.selected;
  
  
  FlickableOption temp = timeline.getSelected();
  ArrayList<TimelineSubOption> timelineOptionSub = new ArrayList<TimelineSubOption>();
  for(int i = 0; i < temp.listing.size(); ++i){
    timelineOptionSub.add(new TimelineSubOption(i + "", new ArrayList()));
  }
  timeline_sub = new Flickable(timelineOptionSub, timeline.left - 240 * scaleFactor, 0, timeline.left, 3*dHeight/8, 4f, #1F2224);
  
  
  ArrayList<TextMessageOption> textMessageOptions = new ArrayList<TextMessageOption>();
  for(int i = 0; i < 10; ++i){
    textMessageOptions.add(new TextMessageOption(i + "", new ArrayList()));
  }
  text_messages = new Flickable(textMessageOptions, 40*scaleFactor, 80*scaleFactor, timeline_sub.left - 40 * scaleFactor, dHeight - 40*scaleFactor, 4f, #45040F);
  
  
  font = createFont("Helvetica", 48);
  textFont(font);
  rectMode(CORNERS);
  strokeWeight(scaleFactor);
  stroke(#7C8387);
  smooth();
}

void draw(){
  background(bg_color);
  strokeWeight(scaleFactor);
  fill(240);
  textAlign(LEFT);
  text_messages.drawF();
  fill(bg_color);
  strokeWeight(0);
  rect(text_messages.left-scaleFactor, 0, text_messages.right+scaleFactor, text_messages.top);
  rect(text_messages.left-scaleFactor, text_messages.bottom, text_messages.right+scaleFactor, dHeight);
  strokeWeight(scaleFactor);
  fill(240);
  textSize(32*scaleFactor);
  text("Good Stuff Greg", 40*scaleFactor, 50*scaleFactor);
  drawTimeline();
  omicronManager.process();
}

void drawTimeline(){
  timeline.drawF();
  drawTimelineSub();
  drawWordlist();
}

void drawTimelineSub(){
  if(timeline.selected != oldTimelineSelected){
    oldTimelineSelected = timeline.selected;
    FlickableOption temp = timeline.getSelected();
    timeline_sub.clearElements();
    for(int i = 0; i < temp.listing.size(); ++i){
      timeline_sub.addElement(new TimelineSubOption(i + "", new ArrayList()));
    }
  }
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
