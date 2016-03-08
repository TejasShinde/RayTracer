class BVHAccelerator extends SceneObject {
  ListObject l;
  //ArrayList<BVHNode> BVH;
  BVHNode[] bvh;
  int bvhcnt;
  
  BVHAccelerator(ListObject _l) {
    l = _l;
    shape = 'b';
    int nObj = l.elements.size();
    bvh = new BVHNode[nObj * nObj];
    bvh[0] = new BVHNode(l.getBBox(), false, null);
    //println("world bb minV = "+bvh[0].bbox.minVertex);
    Build(l, 0);
    int i;
    for(i =0; i<nObj*nObj; i++)
      if(bvh[i] == null)
        break;
    bvhcnt = i;
  }
    
  void Build(ListObject list, int idx) {
    if(list.elements.size() < 1) return;
    Box b = list.getBBox();
    
    // take obj list
    ArrayList<SceneObject> elements = new ArrayList<SceneObject>(list.elements);
    
    // if size 1 -> { leaf =  true, obj = list.o, box = obj.getBBox}
    if(elements.size() == 1) {
      bvh[idx] = new BVHNode(b, true, elements.get(0));
      return;
    }
    
    // find max extent
    int maxExtentIdx = 0;
    PVector diff = PVector.sub(b.maxVertex, b.minVertex);
    if(abs(diff.y) > abs(diff.x) && abs(diff.y) > abs(diff.z))
      maxExtentIdx = 1;
    else if(abs(diff.z) > abs(diff.x))
      maxExtentIdx = 2;
      
    // sort accdly
    elements = sortElem(elements, maxExtentIdx);
    // find median
    int median = elements.size()/2;
    // create two lists
    ArrayList<SceneObject> l = new ArrayList<SceneObject>(elements.subList(0, median));//start index inclusive, end index exclusive
    ArrayList<SceneObject> r = new ArrayList<SceneObject>(elements.subList(median, elements.size()));
    ListObject left = new ListObject(l);
    ListObject right = new ListObject(r);
    
    //create two nodes with these lists
    bvh[2*idx+1] = new BVHNode(left.getBBox(), false, null);
    bvh[2*idx+2] = new BVHNode(right.getBBox(), false, null);
    
    // call build for each of them
    Build(left, 2*idx+1);
    Build(right, 2*idx+2);
  }
  
  ArrayList<SceneObject> sortElem(ArrayList<SceneObject>elements, int idx) {
    int cnt = elements.size();
    Box[] boxArray = new Box[cnt];
    ArrayList<SceneObject> e = new ArrayList<SceneObject>();
    for(int i = 0; i < cnt; i++) {
      boxArray[i] = elements.get(i).getBBox();
    }
    for(int i = 0; i < cnt; i++) {
      int minidx = 0;
      for(int j = 1; j < elements.size(); j++) {
        if(boxArray[minidx].minVertex.array()[idx] > boxArray[j].minVertex.array()[idx])
          minidx = j;
      }
      e.add(elements.get(minidx));
      elements.remove(minidx);
    }
    return e;
  }
  
  Intersection getIntersection(Ray r) {
    Stack s = new Stack();
    Intersection isect = null, tsect = null;
    Intersection lsect, rsect;
    isect = bvh[0].bbox.getIntersection(r);
    if(isect == null)  return null;
    int i = 0, left, right;
    while(true) {
      if(!bvh[i].leaf) {
        left = 2*i+1; right = 2*i+2;
        lsect = bvh[left].bbox.getIntersection(r);
        rsect = bvh[right].bbox.getIntersection(r);
        if(lsect!=null && rsect!=null) {
          if(lsect.t > rsect.t){  s.push(left);  i = right;}
          else{  s.push(right);  i = left;}
          continue;
        }
        else if(lsect!=null) {  i = left;  }
        else if(rsect!=null) {  i = right;  }
      }
      else {
        r.transform(bvh[i].obj.ictm);
        tsect = bvh[i].obj.getIntersection(r);
        if(tsect!=null){
          if(isect.ObjOfIsection.shape == 'x') isect = tsect;
          else if(isect.t > tsect.t)  isect = tsect;
        }
        r.restore();
      }
      if(s.empty())  break;
      i = s.pop();
    }
    if(isect == null)  return null;
    if(isect.ObjOfIsection.shape != 'x')  return isect;
    else return null;
  }
  
  PVector getNormal(PVector p) {
    return null;
  }
  
  void invertNormal() {}
  
  Box getBBox() {
    return null;  
  }
  
}
