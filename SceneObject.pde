abstract class SceneObject {
  color diffuse;
  color ambient;
  char shape;
  PVector N;
  PMatrix3D ictm;
  
  SceneObject() {
    diffuse = color(0, 0, 0);
    ambient = color(0, 0, 0);
    ictm = new PMatrix3D(1, 0, 0, 0,
                         0, 1, 0, 0,
                         0, 0, 1, 0,
                         0, 0, 0, 1);
  }
  
  SceneObject(SceneObject o) {
    diffuse = o.diffuse;
    ambient = o.ambient;
    shape = o.shape;
    N = o.N;
    ictm = o.ictm;
  }
  
  void setMatrix(PMatrix3D ctm) {
    ictm = ctm;
    ictm.invert();
  }
  
  abstract Intersection getIntersection(Ray r);
  abstract PVector getNormal(PVector p);
  abstract void invertNormal();
  abstract Box getBBox();
}

