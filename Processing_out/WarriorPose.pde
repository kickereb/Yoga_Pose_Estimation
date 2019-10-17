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
