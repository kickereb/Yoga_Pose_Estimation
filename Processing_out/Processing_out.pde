import oscP5.*;
import netP5.*;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

int state = 0;

//State 0 -> Ask for Difficulty Level
//State 1 -> Choose Pose
//State 2 -> Ask for number of minutes of session
//State 3 -> Initialise Pose Tracking

int width_ = 1095;
int height_ = 720;

OscP5 oscP5;

NetAddress myBroadcastLocation;


JSONObject data;
JSONArray user_pose;
int diff = 0;
void setup() 
{
  size(1095, 720);
  frameRate(24);

  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
}
void text_in_butt(String text, float cx, float cy)
{
  textAlign(CENTER);
  fill(0);
  textSize(40);
  text(text, cx, cy + 12);
}
void makeButton(int cx, int cy, int l, int b, int cVal)
{
  rectMode(CENTER);
  fill(cVal);
  rect(cx, cy, l, b);
}
int rTime;

void draw() 
{
  background(0);

  if (state == 0)
  {
    textAlign(CENTER);
    textSize(40);
    fill(255);
    text("Select a Level of Difficulty", width/2, 100);

    // Open Button - Easy
    makeButton(width/2, 300, 300, 50, 255);
    text_in_butt("Easy", width/2, 300);

    // Open Button - Medium
    makeButton(width/2, 400, 300, 50, 255);
    text_in_butt("Medium", width/2, 400);

    // Open Button - Hard
    makeButton(width/2, 500, 300, 50, 255);
    text_in_butt("Hard", width/2, 500);

    // Highlighted Button - Easy
    if (mouseY <= 325 && mouseY >= 275)
    {
      makeButton(width/2, 300, 300, 50, 185);
      text_in_butt("Easy", width/2, 300);
    }

    // Highlighted Button - Medium
    if (mouseY <= 425 && mouseY >= 375)
    {
      makeButton(width/2, 400, 300, 50, 185);
      text_in_butt("Medium", width/2, 400);
    }

    // Highlighted Button - Hard
    if (mouseY <= 525 && mouseY >= 475)
    {
      makeButton(width/2, 500, 300, 50, 185);
      text_in_butt("Hard", width/2, 500);
    }

    // Pressed Button - Easy
    if (mouseY <= 325 && mouseY >= 275 && mousePressed)
    {
      makeButton(width/2, 300, 300, 50, 185);
      state = 11;
    }

    // Pressed Button - Medium
    if (mouseY <= 425 && mouseY >= 375 && mousePressed)
    {
      makeButton(width/2, 400, 300, 50, 185);
      diff = 2;
    }
    // Pressed Button - Hard
    if (mouseY <= 525 && mouseY >= 475 && mousePressed)
    {
      makeButton(width/2, 500, 300, 50, 185);
      diff = 3;
    }
  }

  if (state == 11)
  {
    makeButton(width/2, 300, 300, 50, 255);
    text_in_butt("Tree Pose", width/2, 300);

    makeButton(width/2, 400, 300, 50, 255);
    text_in_butt("Warrior Pose", width/2, 400);

    if (mouseY <= 325 && mouseY >= 275)
    {
      makeButton(width/2, 300, 300, 50, 185);
      text_in_butt("Tree Pose", width/2, 300);
    }

    if (mouseY <= 425 && mouseY >= 375)
    {
      makeButton(width/2, 400, 300, 50, 185);
      text_in_butt("Warrior Pose", width/2, 400);
    }
    // Pressed Button Warrior Pose
    if (mouseY <= 325 && mouseY >= 275 && mousePressed)
    {
      makeButton(width/2, 300, 300, 50, 185);
    }

    // Pressed Button Tree Pose
    if (mouseY <= 425 && mouseY >= 375 && mousePressed)
    {
      makeButton(width/2, 400, 300, 50, 185);
      state = 2;
    }
  }

  if (state == 2)                                   //Session length
  {
    textAlign(CENTER);
    textSize(40);
    text("How long do you want the session? ", width/2, height/2 - 30);
    textSize(20);
    text("\nEnter in minutes (max 9 minutes) ", width/2, height/2 - 30);
    if (keyPressed)
    {
      rTime = key - 48;
      print(rTime);
      state = 3;
    }
  } else 
  if (state == 3)
  {
    drawParts();
  }
}

// A function to draw humans body parts as circles
void drawParts() {

  if (data != null) {
    try {  
      user_pose = data.getJSONArray("poses").getJSONArray(0);
    }
    catch( Exception e) {
      text_in_butt("No human being detected!", width/2, height/2);
    }    
    final JSONArray RefHolder = loadJSONArray("wrp.JSON");
    final JSONArray RefWPpoints = RefHolder.getJSONObject(0).getJSONArray("poses").getJSONArray(0);
    Pose ref_pose = new WarriorPose( RefWPpoints, "Warrior Pose", 1) ;
    Pose user_wp = new WarriorPose(user_pose, "Warrior Pose", 1) ; 
    for (int h = 0; h < user_pose.size(); h++) 
    {
      // Now that we have one human, let's draw its body parcts
      for (int k = 0; k < user_pose.size(); k++) 
      {
        // Body parts are relative to width and weight of the input
        JSONArray point = user_pose.getJSONArray(k); 
        float x = point.getFloat(0);
        float y = point.getFloat(1);
        noStroke();
        fill(135, 206, 250);
        ellipse(x * width, y * height, 10, 10);

        displaySkeletonWithAngleCorrection(user_wp, ref_pose );
      }
    }
  }
}
String toPass;
void displaySkeletonWithAngleCorrection(Pose user_pose, Pose ref_pose)
{
  boolean[] incorrect_angle_vertices = user_pose.comparePosesByAngles(ref_pose) ;
  if (incorrect_angle_vertices!=null) {
    JSONArray[] points = new JSONArray[3] ; 
    for (int i = 0; i < incorrect_angle_vertices.length; i++)
    {
      for (int j = 0; j < 3; j++)
        points[j] = user_pose.keypoints.getJSONArray( user_pose.angle_vertices[i][j] ) ;
      String angle_name = user_pose.angle_names[user_pose.angle_vertices[i][3]] ; 
      for (int j = 0; j < 2; j++) {
        float x1 = points[j].getFloat(0);
        float y1 = points[j].getFloat(1);
        float x2 = points[j+1].getFloat(0);
        float y2 = points[j+1].getFloat(1);

        if (!incorrect_angle_vertices[i])
          stroke(0, 0, 255) ;
        else 
        stroke(255, 0, 0 );
        line(width*x1, height*y1, width*x2, height*y2) ;
      } 
      
      textAlign(CENTER);
      //text("Adjust " + a + "", width/2, 100);
    }
  } else
    println("Null pointer exception! \n");
}

void connect() {
  OscMessage m = new OscMessage("/server/connect");
  oscP5.send(m, myBroadcastLocation);
}

void disconnect() {
  OscMessage m = new OscMessage("/server/disconnect");
  oscP5.send(m, myBroadcastLocation);
}

void keyPressed() {
  switch(key) {
    case('c'):
    /* connect to Runway */
    connect();
    break;
    case('d'):
    /* disconnect from Runway */
    disconnect();
    break;
  }
}


// OSC Event: listens to data coming from Runway
void oscEvent(OscMessage theOscMessage) {
  if (!theOscMessage.addrPattern().equals("/data")) return;
  // The data is in a JSON string, so first we get the string value
  String dataString = theOscMessage.get(0).stringValue();

  // We then parse it as a JSONObject
  data = parseJSONObject(dataString);
}
/*iteration+ t
 save iteration for 1 + 
 */
