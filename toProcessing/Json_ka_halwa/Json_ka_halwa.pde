import oscP5.*;
import netP5.*;

// Runway Host
String runwayHost = "127.0.0.1";

// Runway Port
int runwayPort = 57100;

int width_ = 1095;
int height_ = 720;

OscP5 oscP5;
NetAddress myBroadcastLocation;


JSONObject data;
JSONArray user_pose;

class Angle {
  JSONArray  p1, p2, p3 ;

  Angle(JSONArray p1, JSONArray p2, JSONArray p3) {
    this.p1 = p1 ;
    this.p2 = p2 ;
    this.p3 = p3 ;
  }

  public float computeAngle()
  {
    float x1 = p1.getFloat(0) ;
    float y1 = p1.getFloat(1) ;

    float x2 = p2.getFloat(0) ;
    float y2 = p2.getFloat(1) ;

    float x3 = p3.getFloat(0) ;
    float y3 = p3.getFloat(1) ;

    float dist_p1_p2 = dist(x1, y1, x2, y2) ;
    float dist_p1_p3 = dist(x1, y1, x3, y3) ;
    float dist_p2_p3 = dist(x2, y2, x3, y3) ;

    float cos_angle = ( sq(dist_p1_p2) + sq(dist_p2_p3) - sq(dist_p1_p3) ) / ( 2 * dist_p1_p2 * dist_p2_p3 ) ;
    float angle = acos(cos_angle) * 180 / PI  ;
    return angle ;
  }
}

class Pose {

  JSONArray keypoints ;
  String pose_name ; 
  int difficulty_level ;

  String[] angle_names ;
  float[] angles ;
  int [][] angle_vertices ;

  Pose( JSONArray keypoints, String pose_name, int difficulty_level ){
    this.keypoints = keypoints ;  
    this.pose_name = pose_name ;
    this.difficulty_level = difficulty_level ;
  }

  boolean[] comparePosesByAngles( Pose refPose )
  {
    if ( angles.length != refPose.angles.length ) {
      System.out.println("Cannot compare two differnet poses");
      return null ;
    }
    boolean[] incorrect_angle_vertices = new boolean[angles.length]; 
    for (int i = 0; i < angles.length; i++) {
      if (  Math.abs(angles[i] - refPose.angles[i]) > 10 )
        incorrect_angle_vertices[i] = true ;
      else
        incorrect_angle_vertices[i] = false;
    }
    return incorrect_angle_vertices;
  }
  void testFunction()
  {
    System.out.println("Angles: ");
    for(int i = 0 ; i < angles.length ; i++)
       System.out.println("Angle " + i + " : " + angles[i]) ;
  }
}

class WarriorPose extends Pose {  
  
  WarriorPose( JSONArray keypoints, String pose_name, int difficulty_level )
  {
    super(keypoints, pose_name, difficulty_level) ; 
    initialize_parent_attributes() ; 
    angles = new float[angle_names.length] ;
    for (int i = 0; i < angles.length; i++)
      angles[i] = new Angle( keypoints.getJSONArray(angle_vertices[i][0]), keypoints.getJSONArray(angle_vertices[i][1]), keypoints.getJSONArray(angle_vertices[i][2]) ).computeAngle() ;
  }
  
  void initialize_parent_attributes()
  {
    final String[] angle_names = {
    "Angle between right torso and right knee",           //0
    "Angle between left knee and left leg",               //1
    "Angle between right shoulder and right torso",       //2
    "Angle between right elbow and right shoulder",       //3
    "Angle between right hand and right elbow",           //4
    "Angle between left shoulder and left torso",         //5
    "Angle between left shoulder and left elbow",         //6
    "Angle between left hand and left elbow"              //7
  };  

  final int [][] angle_vertices = {
    {12, 11, 13, 0},           //0
    {12, 14, 16, 1},           //1
    {5, 11, 13, 2},            //2
    {7, 5, 11, 3},             //3
    {9, 7, 5, 4},              //4       
    {6, 12, 14, 5},            //5
    {8, 6, 12, 6},             //6
    {10, 8, 6, 7}              //7 
    };
    
    super.angle_names = angle_names ;
    super.angle_vertices = angle_vertices ;
    
  }
  
}

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

  // Use the localhost and the port 57100 that we defined in Runway while exporting
  myBroadcastLocation = new NetAddress(runwayHost, runwayPort);

  connect();

  fill(255);
  stroke(255);
}

void draw() {
  background(0);
  drawParts();
}
float xB = 0.380;
float xE = 0.560;
float yB = 0.520;
float yE = 1.156;
float width_s = xE - xB;
float height_s = yE - yB;

// A function to draw humans body parts as circles
void drawParts() {

   if (data != null) {
   try{  
     user_pose = data.getJSONArray("poses").getJSONArray(0);
   }
   catch( Exception e) {
     System.out.println("No human being detected!");
   }    
   final JSONArray RefHolder = loadJSONArray("wrp.JSON");
   final JSONArray RefWPpoints = RefHolder.getJSONObject(0).getJSONArray("poses").getJSONArray(0);
   Pose ref_pose = new WarriorPose( RefWPpoints, "Warrior Pose",  1) ;
   Pose user_wp = new WarriorPose(user_pose, "Warrior Pose", 1) ; 
   for (int h = 0; h < user_pose.size(); h++) 
   {
    // Now that we have one human, let's draw its body parts
       for (int k = 0; k < user_pose.size(); k++) 
      {
       // Body parts are relative to width and weight of the input
       JSONArray point = user_pose.getJSONArray(k); 
       float x = point.getFloat(0);
       float y = point.getFloat(1);
       fill(10, 200, 10);
       ellipse(x * width, y * height, 10, 10);
       
       displaySkeletonWithAngleCorrection(user_wp, ref_pose ); 
      }
   } 
  } 
}
void displaySkeletonWithAngleCorrection(Pose user_pose, Pose ref_pose)
{
  boolean[] incorrect_angle_vertices = user_pose.comparePosesByAngles(ref_pose) ;
  if (incorrect_angle_vertices!=null){
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
   System.out.println("Warning-" + angle_name + " is out of range!"); 
  }
 }
 else
    System.out.println("Null pointer exception!");
 System.out.println(); 
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
