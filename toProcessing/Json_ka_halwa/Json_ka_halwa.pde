import oscP5.*;
import netP5.*;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

int width = 400;
int height = 350;

OscP5 oscP5;
NetAddress myBroadcastLocation;

// This array will hold all the humans detected
JSONObject data;
JSONArray humans;

// Thes are the pair of body connections we want to form. 
String[][] connections = 
{
  {"nose", "leftEye"}, 
  {"leftEye", "leftEar"}, 
  {"nose", "rightEye"}, 
  {"rightEye", "rightEar"}, 
  {"rightShoulder", "rightElbow"}, 
  {"rightElbow", "rightWrist"}, 
  {"leftShoulder", "leftElbow"}, 
  {"leftElbow", "leftWrist"}, 
  {"rightHip", "rightKnee"}, 
  {"rightKnee", "rightAnkle"}, 
  {"leftHip", "leftKnee"}, 
  {"leftKnee", "leftAnkle"}
};

void setup() 
{
  size(400, 350);
  frameRate(60);

  OscProperties properties = new OscProperties();
  properties.setRemoteAddress("127.0.0.1", 57200);
  properties.setListeningPort(57200);
  properties.setDatagramSize(99999999);
  properties.setSRSP(OscProperties.ON);
  oscP5 = new OscP5(this, properties);

  // Use the localhost and the port 57100 that we defined in Runway while exporting
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
}

void draw() {
  background(0);
  drawParts();
  JSONArray test;
}
float xB = 0.380;
float xE = 0.560;
float yB = 0.520;
float yE = 1.156;
float width_s = xE - xB;
float height_s = yE - yB;

// A function to draw humans body parts as circles
void drawParts() {
  // Only if there are any humans detected
  if (data != null) {
    humans = data.getJSONArray("poses");
    for (int h = 0; h < humans.size(); h++) {
      JSONArray keypoints = humans.getJSONArray(h);
      // Now that we have one human, let's draw its body parts
      for (int k = 0; k < keypoints.size(); k++) {
        // Body parts are relative to width and weight of the input
        JSONArray point = keypoints.getJSONArray(k);
        //Ref R hand
        JSONArray points = keypoints.getJSONArray(10);

        float x1 = width * (points.getFloat(0));
        float y1 = height * (points.getFloat(1));
        //Ref L hand
        JSONArray pointss = keypoints.getJSONArray(9);

        float x2 = width * (pointss.getFloat(0));
        float y2 = height * (pointss.getFloat(1));
        textSize(40);
        textAlign(CENTER);
        fill(255);
        //reference for scale
        /*
        text(x1,(width/2),height-60);
        text(y1,(width/2),height-20);
        
        text(x2,(width/2),40);
        text(y2,(width/2),80);
        */
        if(x1 < 70 && y1 < height/3 && x2 > width - 70 && y2 < height/3)
        {
          text("Warrior Pose",(width/2),height-20);
        }
        float x = point.getFloat(0);
        float y = point.getFloat(1);
        fill(10,10,255);
        noStroke();
        ellipse(x * width, y * height, 10, 10);
      }
    }
  }
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
