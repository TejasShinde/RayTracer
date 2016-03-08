class Box extends SceneObject {
  ArrayList<PVector> vertexList;
  PVector minVertex, maxVertex;
  boolean bounding;
  
  Box(float xmin, float ymin, float zmin, float xmax, float ymax, float zmax) {
    minVertex = new PVector(xmin, ymin, zmin);
    maxVertex = new PVector(xmax, ymax, zmax);
    shape = 'x';
  }
  
  Box(PVector minV, PVector maxV) {
    minVertex = new PVector(minV.x, minV.y, minV.z);
    maxVertex = new PVector(maxV.x, maxV.y, maxV.z);
    shape = 'x';
  }

  float xmin() {  return minVertex.x;  }  float ymin() {  return minVertex.y;  }  float zmin() {  return minVertex.z;  }
  float xmax() {  return maxVertex.x;  }  float ymax() {  return maxVertex.y;  }  float zmax() {  return maxVertex.z;  }

  void xmin(float v) {  minVertex.x = v;  }  void ymin(float v) {  minVertex.y = v;  }  void zmin(float v) {  minVertex.z = v;  }
  void xmax(float v) {  maxVertex.x = v;  }  void ymax(float v) {  maxVertex.y = v;  }  void zmax(float v) {  maxVertex.z = v;  }

  Intersection getIntersection(Ray r) {
  //Perform ray box intersection
    float tnear=Float.NEGATIVE_INFINITY, tfar=Float.POSITIVE_INFINITY, t1, t2;
    float[] dir = r.direction.array();
    float[] origin = r.rayOrigin.array();
    float[] minV = minVertex.array();
    float[] maxV = maxVertex.array();
    for(int i = 0; i < 3; i++){
      if(dir[i] == 0)
        if(origin[i] < minV[i] || origin[i] > maxV[i])
          return null;
      t1 = (minV[i] - origin[i])/dir[i];
      t2 = (maxV[i] - origin[i])/dir[i];
      if (t1 > t2) {t1 = t1 + t2; t2 = t1 - t2; t1 = t1 - t2;}
      if (t1 > tnear) tnear = t1;
      if (t2 < tfar) tfar = t2;
      if (tnear > tfar || tfar < 0) return null;
    }
    Intersection isect = new Intersection(tnear, (SceneObject)this);
    isect.texit = tfar;
    return isect;
  }
  
  PVector getNormal(PVector p) {
    float EPS = 0.01;
    PVector n = new PVector();
    if(abs(p.x - minVertex.x) < EPS) 
      n.set(-1,0,0);
    else if(abs(p.x - maxVertex.x) < EPS) 
      n.set(1,0,0);
    else if(abs(p.y - minVertex.y) < EPS) 
      n.set(0,-1,0);
    else if(abs(p.y - maxVertex.y) < EPS) 
      n.set(0,1,0);
    else if(abs(p.z - minVertex.z) < EPS) 
      n.set(0,0,1);
    else if(abs(p.z - maxVertex.z) < EPS) 
      n.set(0,0,-1);
    return n;
  }
  
  void invertNormal() {  
  }
  
  Box getBBox() {
    if(this.bounding)  return this;
    Box b = new Box(minVertex.x, minVertex.y, minVertex.z, maxVertex.x, maxVertex.y, maxVertex.z);
    b.bounding = true; 
    return b;
  }
}
