class ListObject extends SceneObject {
  Box bbox;
  ArrayList<SceneObject> elements;
  
  ListObject() {
    elements = new ArrayList<SceneObject>();
    shape = 'l';
  }
  
  ListObject(ArrayList<SceneObject> list) {
    elements = list;
    shape = 'l';
    computeBBox();
  }
  
  void add(SceneObject obj) {
    elements.add(obj);
  }
  
  void computeBBox() {
    SceneObject o;
    Box b;
    bbox = new Box(Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.POSITIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY, Float.NEGATIVE_INFINITY);
    for(int i = 0; i < elements.size(); i++) {
      o = elements.get(i);
      b = o.getBBox();
      if(bbox.xmin() > b.xmin())  bbox.xmin(b.xmin());  if(bbox.xmax() < b.xmax())  bbox.xmax(b.xmax());
      if(bbox.ymin() > b.ymin())  bbox.ymin(b.ymin());  if(bbox.ymax() < b.ymax())  bbox.ymax(b.ymax());
      if(bbox.zmin() > b.zmin())  bbox.zmin(b.zmin());  if(bbox.zmax() < b.zmax())  bbox.zmax(b.zmax());
    }
    bbox.bounding = true;
  }
  
  void disp() { println(elements); }
  
  Intersection getIntersection(Ray r) {
    SceneObject o;
    Intersection isect = null;
    Intersection tsect = null;
    isect = bbox.getIntersection(r);
    if(isect == null)  return null;
    o = elements.get(0);
    if(o.ictm!=null)  r.transform(o.ictm);
    isect = o.getIntersection(r);
    if(o.ictm!=null)  r.restore();
    for (int i = 1; i < elements.size(); i++) {
      o = elements.get(i);
      if(o.ictm!=null)  r.transform(o.ictm);
      tsect = o.getIntersection(r);
      if(o.ictm!=null)  r.restore();
      if(tsect==null)  continue;
      if(isect==null)  isect = tsect;
      else if(isect.t > tsect.t)  isect = tsect;
      //if(isect.t > tsect.t)  isect = tsect;
    }
    return isect;
  }
  
  PVector getNormal(PVector p) {
    return null;
  }
  
  void invertNormal() {}
  
  Box getBBox() {
    return bbox;
  }
}

