class Sphere extends SceneObject {
  float radius;
  //float x, y, z;
  PVector center;

  Sphere(float _radius, float _x, float _y, float _z) {
    radius = _radius;
    center = new PVector(_x, _y, _z);
    shape = 's';
  }
  
  Sphere(Sphere s) {
    super(s);
    radius = s.radius;
    center = new PVector(s.center.x, s.center.y, s.center.z);
    shape = 's';
  }

  PVector getNormal(PVector point) {
    N = PVector.sub(point, this.center);
    ictm.transpose();
    ictm.mult(N, N);
    ictm.transpose();
    return N;
  }

  void invertNormal() {
    //this.N.set(-N.x, -N.y, -N.z);
  }

  /*Intersection getIntersection(Ray r) {
    float t0, t1; // solutions for t if the ray intersects
    // geometric solution
    PVector L = PVector.sub(center, r.rayOrigin);
    float tca = L.dot(r.direction);
    if (tca < 0) {
      return null;
    }
    float d2 = L.dot(L) - tca * tca;
    float r2 = radius * radius;
    if (d2 > r2) {
      return null;
    }
    float thc = sqrt(r2 - d2);
    t0 = tca - thc;
    t1 = tca + thc;
    Intersection isect = new Intersection(t0, this);
    r.t = t0;
    return isect;
  }*/
  Intersection getIntersection(Ray ray) {
    Intersection isect;
    float t1, t2;
    float A, B, C;
    float x0, y0, z0; // ray origin
    float dx, dy, dz; // ray direction
    float hc, kc, lc; // sphere center
    float r; // sphere radius
    
    x0 = ray.rayOrigin.x;  y0 = ray.rayOrigin.y;  z0 = ray.rayOrigin.z;
    dx = ray.direction.x;  dy = ray.direction.y;  dz = ray.direction.z;
    hc = this.center.x;  kc = this.center.y;  lc = this.center.z;
    r  = this.radius;
    
    A = (dx*dx) + (dy*dy) + (dz*dz);
    B = 2 * ((x0*dx + y0*dy + z0*dz) - (dx*hc + dy*kc + dz*lc));
    C = (x0*x0 + y0*y0 + z0*z0 + hc*hc + kc*kc + lc*lc) - (r*r) - 2*(x0*hc + y0*kc + z0*lc);
    
    if(A == 0) {
      println("undefined ray direction");
      return null;
    }
    
    float discriminant = (B*B) - (4*A*C);
    if(discriminant < 0) {
      return null;
    }
    if(discriminant == 0) {
      t1 = (-B)/(2*A);
      isect = new Intersection(t1, this);
      return isect;
    }
    
    t1 = ( (-B) + (sqrt(discriminant)) )/(2*A);
    t2 = ( (-B) - (sqrt(discriminant)) )/(2*A);
    if(t1>t2)  t1 = t2;
    isect = new Intersection(t1, this);
    return isect;
  }
  
  Box getBBox() {
    Box b = new Box(center.x - radius, center.y - radius, center.z - radius, center.x + radius, center.y + radius, center.z + radius);
    b.bounding = true;
    return b;
  }
}

