class Polygon extends SceneObject {
  ArrayList<PVector> vertexList;
  //PVector N; // surface normal
  float d;
  
  Polygon(ArrayList<PVector> _vertexList) {
    vertexList = _vertexList;
    N = calculateNormal();
    d = calculateIntercept();
    shape = 'p';
  }
  
  Polygon(Polygon p) {
    super(p);
    vertexList = p.vertexList;
    N = calculateNormal();
    d = calculateIntercept();
    shape = 'p';
  }
  
  PVector getNormal(PVector point){
    ictm.transpose();
    ictm.mult(N, N);
    ictm.transpose();
    return N;
  }
  
  void invertNormal() {
    this.N.set(-N.x, -N.y, -N.z);
  }
  
  PVector calculateNormal() {
    PVector E1 = PVector.sub(vertexList.get(1), vertexList.get(0));
    PVector E2 = PVector.sub(vertexList.get(2), vertexList.get(0));
    PVector E1crossE2 = E1.cross(E2);
    E1crossE2.normalize();
    return E1crossE2;
  }
  
  float calculateIntercept() {
    PVector P = vertexList.get(0);
    float _d = -1 * N.dot(P);
    return _d;
  }
  
  Intersection getIntersection(Ray r) {
    Intersection isect = null;
    float t, numerator, denominator;
    numerator = N.dot(r.rayOrigin) + d;
    denominator = N.dot(r.direction);
    if(denominator == 0) return isect;
    t = -numerator/denominator;
    if(t < 0) return isect;
    if(intersectionInsidePolygon(r.getPointAt(t)) == true) {
      isect = new Intersection(t, this);
    }
    return isect;
  }
  
  /*boolean intersectionInsidePolygon(PVector P) {
    ArrayList<PVector> edges = new ArrayList<PVector>();
    for(int i = 0 ; i < vertexList.size()-1; i++) {
      edges.add(PVector.sub(vertexList.get(i+1), vertexList.get(i)));
    }
    edges.add(PVector.sub(vertexList.get(0), vertexList.get(vertexList.size()-1)));
    for(int i = 0; i < vertexList.size(); i++) {
      PVector skewRadius = PVector.sub(P, vertexList.get(i));
      PVector crossProduct = (edges.get(i)).cross(skewRadius);
      if(crossProduct.dot(N)<0){
        return false;
      }
    }
    return true;
  }*/
  
  boolean intersectionInsidePolygon(PVector P) {
    PVector v0 = PVector.sub(vertexList.get(2), vertexList.get(0)); // C-A
    PVector v1 = PVector.sub(vertexList.get(1), vertexList.get(0)); // B-A
    PVector v2 = PVector.sub(P, vertexList.get(0)); // P-A
    
    float dot00 = v0.dot(v0);
    float dot01 = v0.dot(v1);
    float dot02 = v0.dot(v2);
    float dot11 = v1.dot(v1);
    float dot12 = v1.dot(v2);
    float denom = (dot00 * dot11 - dot01 * dot01);
    
    float u = (dot11 * dot02 - dot01 * dot12) / denom;
    float v = (dot00 * dot12 - dot01 * dot02) / denom;
    
    return (u >= 0) && (v >= 0) && (u+v <= 1);
  }
  
  Box getBBox() {
    PVector minV, maxV, v;
    minV = new PVector();  maxV = new PVector();
    maxV.set(Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY);
    minV.set(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY);
    for(int i = 0; i < vertexList.size(); i++) {
      v = vertexList.get(i);
      if(v.x < minV.x)  minV.x = v.x;  if(v.x > maxV.x)  maxV.x = v.x;
      if(v.y < minV.y)  minV.y = v.y;  if(v.y > maxV.y)  maxV.y = v.y;
      if(v.z < minV.z)  minV.z = v.z;  if(v.z > maxV.z)  maxV.z = v.z;
    }
    Box b = new Box(minV.x, minV.y, minV.z, maxV.x, maxV.y, maxV.z);
    b.bounding = true;
    return b;
  }
}

