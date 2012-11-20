public class Category{
  String name;
  int total;
  
  //TODO: Change to <Word>
  ArrayList<String> words = new ArrayList<String>();
  
  public Category(String n, String[] list){
    this.name = n;
    this.total = 0;
    for(int i = 0; i < list.length; i++){
      //TODO: Creates new Word
      words.add(list[i]);
    }
  }
  
  public void setCount(){
    //TODO Queries for count for all words in category for that year.
    total = 0;
  }
}
