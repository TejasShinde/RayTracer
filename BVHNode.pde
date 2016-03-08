class BVHNode {
  Box bbox;
  boolean leaf;
  SceneObject obj;

  BVHNode() {
    bbox = null;
    leaf = false;
    obj = null;
  } 
  BVHNode(Box _b, boolean _leaf, SceneObject _o) {
    bbox = _b;
    leaf = _leaf;
    obj = _o;
  }  
}
