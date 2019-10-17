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
