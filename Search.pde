
class Search {
  String searchTerm = "";
  String previousSearchNonFormat, previousSearch;
  PImage img, thumbnail;
  String[] imgUrls;
  PrintWriter jsonFile, defJSON;
  JSONObject json;
  float neww, newh;

  Search(String searchTerm_) {
    if (searchTerm_.charAt(0) == ' ') {
      errors = "Incorrect search term";
      return;
    } 
    else {
      
      searchTerm = ammendSearch(searchTerm_);
      previousSearchNonFormat = searchTerm;
      JSONObject response;

      File fileName = new File(dataPath(searchTerm+".json"));
      if (!fileName.exists()) {
        println(searchTerm + " does not exist");
        makeJSON(searchTerm);
      }
      try {
        json = loadJSONObject(searchTerm+".json");
      } 
      catch(Exception e) {
        //If the JSON file is fucked, delete it and try again.
        errors = "JSON Error, Try Again";
        fileName.delete();
        return;
      }
      try {
        response = json.getJSONObject("responseData");
      } 
      catch(Exception e) {
        response = null;
      }
      if (response == null) {
        errors = "Search yeilded no results, but try again...";
        makeJSON(searchTerm);
        return;
      }
      else {
        JSONArray results = response.getJSONArray("results");
        imgUrls = new String[results.size()];
        for (int i = 0; i < results.size(); i++) {
          JSONObject obj = results.getJSONObject(i); 
          String imgUrl = obj.getString("unescapedUrl");
          imgUrls[i] = imgUrl;
        }
      }
      try {
        loadBG(imgUrls);
      } 
      catch (Exception e) {
        errors = "Image load error";
        println("Image load error");
        //loadBG(imgUrls);
        return;
      }
      previousSearch = searchTerm;
      searched = true;
      searchTerm = "";
      errors = "";
    }
  }

  void makeThumbDims() {
    float imgw = img.width;
    float imgh = img.height;
    if (imgw > imgh) {
      float d = imgw/200.0;
      neww = 200;
      newh = imgh/d;
    } 
    else {
      float d = imgh/200.0;
      newh = 200;
      neww = imgw/d;
    }
  }

  void makeJSON(String toSearch) {
    println("Making a JSON");
    //&imgsz=large
    String lines[] = loadStrings("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="+toSearch+"&rsz=8");
    jsonFile = createWriter("data/"+toSearch+".json");
    for (int l=0; l<lines.length; l++) {
      jsonFile.println(lines[l]);
    }
    jsonFile.flush();
    jsonFile.close();
  }


  void loadBG(String[] imgs_) {
    println("Loading an Image");
    String[] imgs = imgs_;
    String url = imgs[floor(random(imgs.length))];
    println("Found " + imgs.length + " Images");
    println(url);
    PImage temp;
    try {
      temp = loadImage(url);
      if (!(temp.width>0 && temp.height>0)) loadBG(imgs);
      img = temp.get();
      makeThumbDims();
    } 
    catch(Exception e) {
      errors = "Reloaded Image";
      loadBG(imgs);
    }
  }

  String ammendSearch(String searchTerm_) {
    String searchTerm = searchTerm_;
    String searchTermMod = "";
    String space = "+";
    ArrayList<String> subStrings = new ArrayList<String>();
    int index = 0;

    //Make ammended search-term string
    searchTerm = searchTerm.toLowerCase();
    for (int i=0; i<searchTerm.length(); i++) {
      if (searchTerm.charAt(i) == ' ') {
        subStrings.add(searchTerm.substring(index, i));
        subStrings.add(space);
        index = i+1;
      }
    }

    subStrings.add(searchTerm.substring(index, searchTerm.length()));

    for (int j=0; j<subStrings.size(); j++) {
      searchTermMod += subStrings.get(j);
    }
    return searchTermMod;
  }
}

