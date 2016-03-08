class DiskLightSource extends LightSource {
  float radius;
  PVector oposition;
  /*Normal direction is inherited from SceneObject. Use it.*/
  
  DiskLightSource(float _x, float _y, float _z, float _rad, float _dx, float _dy, float _dz, float _r, float _g, float _b) {
    super(_x, _y, _z, _r, _g, _b);
    oposition = new PVector(_x, _y, _z);
    radius = _rad;
    N = new PVector(_dx, _dy, _dz);
    N.normalize();
    shape = 'd';
  }
  
  PVector getOutsidePoint() {
    float x, y, z;
    if (N.x == 0)  return new PVector(1, 0, 0);
    if (N.y == 0)  return new PVector(0, 1, 0);
    if (N.z == 0)  return new PVector(0, 0, 1);
    return new PVector(-N.x, N.y, N.z);
  }
  
  void updatePosition() {
    PVector p = getOutsidePoint();
    PVector u, v;
    u = N.cross(p);
    u.normalize();
    v = N.cross(u);
    v.normalize();
    float t = radius * random(-100, 100)/200.0;
    float x, y, z;
    x = position.x + t * (u.x - v.x);
    y = position.y + t * (u.y - v.y);
    z = position.z + t * (u.z - v.z);
    this.position.set(x, y, z);  
  }
  
  void restorePosition() {
    this.position.set(oposition.x, oposition.y, oposition.z);
  }
}

