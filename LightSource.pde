class LightSource extends SceneObject {
  PVector position;
  color lightColor;
  
  LightSource(float x, float y, float z, float r, float g, float b) {
    position = new PVector(x, y, z);
    lightColor = color(r, g, b);
  }
  
  PVector getNormal(PVector p) {
    return null;
  }
  
  void invertNormal() {}
  
  Intersection getIntersection(Ray r) {
    return null;
  }
  
  Box getBBox() {
    return null;
  }
}
