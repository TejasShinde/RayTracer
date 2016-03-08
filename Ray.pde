class Ray {
  //float x0, y0, z0, dx, dy, dz;
  PVector rayOrigin, direction;
  PVector oldRayOrigin, oldDirection;
  float t;
  ArrayList<Intersection> isectList;
  
  Ray(float xd, float yd, float zd) {
    rayOrigin = new PVector(0, 0, 0); // initiate ray from origin. Change this line to give custom initiation for a ray.
    direction = new PVector(xd - rayOrigin.x, yd - rayOrigin.y, zd - rayOrigin.z);
    direction.normalize();
    isectList = new ArrayList<Intersection>();
  }
  
  Ray(PVector o, PVector p) {
    rayOrigin = new PVector(o.x, o.y, o.z); // initiate ray from origin. Change this line to give custom initiation for a ray.
    direction = new PVector(p.x - rayOrigin.x, p.y - rayOrigin.y, p.z - rayOrigin.z);
    direction.normalize();
    isectList = new ArrayList<Intersection>();
  }
  
  float x(float _t) { return rayOrigin.x + (_t*direction.x); } /*return x at _t*/
  float y(float _t) { return rayOrigin.y + (_t*direction.y); }
  float z(float _t) { return rayOrigin.z + (_t*direction.z); }
  PVector getPointAt(float _t) {
    return (new PVector(x(_t), y(_t), z(_t)));
  }
  
  void transform(PMatrix3D ictm) {
    oldRayOrigin = new PVector(rayOrigin.x, rayOrigin.y, rayOrigin.z);
    oldDirection = new PVector(direction.x, direction.y, direction.z);
    ictm.mult(this.rayOrigin, this.rayOrigin);
    float[] auxdir = new float[4];
    float[] target = new float[4];
    auxdir[0] = this.direction.x;    auxdir[1] = this.direction.y;    auxdir[2] = this.direction.z;    auxdir[3] = 0;  
    ictm.mult(auxdir, target);
    this.direction.set(target[0], target[1], target[2]);
  }
  
  void restore() {
    this.rayOrigin.set(oldRayOrigin.x, oldRayOrigin.y, oldRayOrigin.z);
    this.direction.set(oldDirection.x, oldDirection.y, oldDirection.z);
    oldRayOrigin = null;
    oldDirection = null;
  }
}

