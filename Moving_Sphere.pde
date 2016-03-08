class Moving_Sphere extends Sphere {
  PVector startCenter, endCenter;
  Moving_Sphere(float _radius, float _x1, float _y1, float _z1, float _x2, float _y2, float _z2) {
    super(_radius, _x1, _y1, _z1);
    shape = 'm';
    startCenter = new PVector(_x1, _y1, _z1);
    endCenter = new PVector(_x2, _y2, _z2);
  }
  
  /*Intersection getIntersection(Ray r) {
    Intersection isect = super.getIntersection(r);
    return isect;
  }*/
  
  void updatePosition() {
    float t = random(0, 100)/100.0;
    //println("Noise = " + t);
    float x, y, z;
    x = startCenter.x + t * (endCenter.x - startCenter.x);
    y = startCenter.y + t * (endCenter.y - startCenter.y);
    z = startCenter.z + t * (endCenter.z - startCenter.z);
    this.center.set(x, y, z);  
  }
  
  void restorePosition() {
    this.center.set(startCenter.x, startCenter.y, startCenter.z);  
  }
}

