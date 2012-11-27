import de.bezier.data.sql.*;

class DatabaseAdapter {
  PApplet parent;
  MySQL msql;
  String user;
  String pass;
  String database;
  String server;
 
  public DatabaseAdapter(PApplet p, String username, String password, String db, String s) {
   user = username;
   pass = password;
   database = db;
   parent = p;
   server = s;
   msql = new MySQL(parent, server, database, user, pass);
   if(msql.connect()){
   println("created DB");
   }
  }
  
  //Get all dates (do duplicates)
  public ArrayList<String> getDates()
  {
    ArrayList<String> result = new ArrayList<String>();
    msql.query("SELECT distinct DATE(STR_TO_DATE(createdAt, '%c/%e/%Y %T')) AS 'dates' from info order by dates ASC");
    while(msql.next()) {
      result.add(msql.getString("dates"));
    } 
   return result; 
  }
  
  //Get all messageIds for a word
  public ArrayList<String> getMessageIdsForWord(String word)
  {
    int wordId = 0;
    msql.query("select wordId from words where word = '"+word+"'");
    while(msql.next()) {
      wordId = msql.getInt("wordId");
    }
    
    ArrayList<String> result = new ArrayList<String>();
    msql.query("select distinct messageId from messages where wordId = '"+wordId+"'");
    while(msql.next()) {
      result.add(msql.getString("messageId"));
    } 
   return result; 
  }
  
  //Get all messageIds with given date and word
  public ArrayList<String> getMessageIds(String date, String word)
  {
    ArrayList<String> result = new ArrayList<String>();
    msql.query("select distinct info.messageId from info, messages, words where info.messageId = messages.messageId AND messages.wordId = words.wordId AND createdAt LIKE '%"+date+"%' AND words.word = '"+word+"' ");
    while(msql.next()) {
      result.add(msql.getString("messageId"));
    } 
   return result; 
  }
  
  //Get all messageIds for given personId
  public ArrayList<String> getMessageIds(String personId)
  {
    ArrayList<String> result = new ArrayList<String>();
    msql.query("select messageId from info where personId = '"+personId+"'");
    while(msql.next()) {
      result.add(msql.getString("messageId"));
    } 
   return result; 
  }
  
//  public ArrayList<String> getMessageDetails(String messageId)
//  {
//    ArrayList<String> result = new ArrayList<String>();
//    msql.query("select DATE(STR_TO_DATE(createdAt, '%c/%e/%Y %T')) AS 'date', TIME(STR_TO_DATE(createdAt, '%c/%e/%Y %T')) AS 'time',location, text from info where messageId = '"+messageId+"'");
//    while(msql.next()) {
//      result.add(msql.getString("date"));
//      result.add(msql.getString("time"));
//    } 
//   return result; 
//  }
  
  //Get message details
  public TextMessage getMessageDetails(String messageId)
  {
    TextMessage result;
    String date = "";
    String time = "";
    String location = "";
    String content = "";
    msql.query("select DATE(STR_TO_DATE(createdAt, '%c/%e/%Y %T')) AS 'date', TIME(STR_TO_DATE(createdAt, '%c/%e/%Y %T')) AS 'time',location, text from info where messageId = '"+messageId+"'");
    while(msql.next()) {
      date = msql.getString("date");
      time = msql.getString("time");
      location = msql.getString("location");
      content = msql.getString("text");
    } 
    result = new TextMessage(date, time, location, content);
    return result; 
  }
  
  
}


