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
