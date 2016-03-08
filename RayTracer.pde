class RayTracer {
  float fov;
  color bg;
  ArrayList<SceneObject> objList;
  ArrayList<LightSource> lsList;
  HashMap<String, SceneObject> namedObjList;
  color current_diffuse_color;
  color current_ambient_color;
  float h, w, d;
  int rpp; // rays per pixel
  float lensr, lensfd;
  
  RayTracer(float _h, float _w, float _d) {
    fov = 0;
    bg = color(0, 0, 0);
    objList = new ArrayList<SceneObject>();
    lsList = new ArrayList<LightSource>();
    namedObjList = new HashMap<String, SceneObject>();
    current_diffuse_color = color(0, 0, 0);
    current_ambient_color = color(0, 0, 0);
    h = _h;
    w = _w;
    d = _d;
    lensr = 0;
    lensfd = 0;
  }
  
  void setrpp(int _rpp) {
    this.rpp = _rpp;
  }
  
  void displayObjLists() {
    println("SceneObjs : " + objList);
    println("NamedObjs : " + namedObjList);
  }
  
  SceneObject getLastSceneObject() {
    SceneObject obj = objList.remove(objList.size() - 1);
    return obj;
  }
  
  void AddNamedObject(String name, SceneObject o) {
    namedObjList.put(name, o);
  }
  
  SceneObject getNamedObject(String name) {
    return namedObjList.get(name);
  }
  
  void instantiate(SceneObject o, PMatrix3D ctm) {
    SceneObject obj = null;
    if(o.shape == 's') obj = new Sphere((Sphere) o);
    else if (o.shape == 'p') obj = new Polygon((Polygon) o);
    //println("Instantiating obj = " + obj + " from o = " + o);
    obj.setMatrix(ctm);
    objList.add(obj);
  }
  
  void AddLightSource(float x, float y, float z, float r, float g, float b) {
    LightSource ls = new LightSource(x, y, z, r, g, b);
    objList.add((SceneObject) ls);
    lsList.add(ls);
    //println("LightSource added at " + ls.position + "with color = " + r + g +b);
  }
  
  void AddDiskLightSource(float x, float y, float z, float rad, float dx, float dy, float dz, float r, float g, float b) {
      DiskLightSource dls = new DiskLightSource(x, y, z, rad, dx, dy, dz, r, g, b);
      objList.add((SceneObject) dls);
      lsList.add(dls);
  }
  
  void AddSphere(float r, float x, float y, float z) {
    Sphere s = new Sphere(r, x, y, z);
    s.diffuse = current_diffuse_color;
    s.ambient = current_ambient_color;
    objList.add((SceneObject) s);
    //println("Sphere added at " + s.center + " with radius = " + s.radius);
  }
  
  void AddMovingSphere(float radius, float x1, float y1, float z1, float x2, float y2, float z2) {
    Moving_Sphere ms = new Moving_Sphere(radius, x1, y1, z1, x2, y2, z2);
    ms.diffuse = current_diffuse_color;
    ms.ambient = current_ambient_color;
    objList.add((SceneObject) ms);
  }
  
  void AddPolygon(ArrayList<PVector> VertexList) {
    Polygon p = new Polygon(VertexList);
    p.diffuse = current_diffuse_color;
    p.ambient = current_ambient_color;
    objList.add((SceneObject) p);
    //println("Polygon added with the following vertices : " + VertexList + " and normal = " + p.N + " and intercept = " + p.d);
  }
  
  void AddBox(PVector min, PVector max) {
    Box b = new Box(min.x, min.y, min.z, max.x, max.y, max.z);
    b.diffuse = current_diffuse_color;
    b.ambient = current_ambient_color;
    objList.add((SceneObject) b);
    //println("Box added at min = " + b.minVertex + " and max = " + b.maxVertex);
  }
  
  void AddList(int listSize) {
    //println("Scene contains : " + objList);
    ListObject l = new ListObject();
    int idx = objList.size() - listSize;
    while(listSize > 0) {
      SceneObject o = objList.remove(idx);
      l.add(o);
      listSize--;
    }
    l.computeBBox();
    objList.add(l);
    //println("Bounding box for the list = " + l.bbox.minVertex + l.bbox.maxVertex);
    //println("Scene contains : " + objList);
    //print("List contains : "); l.disp();
  }
  
  void AddAccel(int listSize) {
    BVHAccelerator bvh;
    //println("Scene contains : " + objList);
    ListObject l = new ListObject();
    int idx = objList.size() - listSize;
    while(listSize > 0) {
      SceneObject o = objList.remove(idx);
      l.add(o);
      listSize--;
    }
    l.computeBBox();
    bvh = new BVHAccelerator(l);
    objList.add(bvh);
    //println("Bounding box for the list = " + bvh.l.bbox.minVertex + bvh.l.bbox.maxVertex);
    //println("Scene contains : " + objList);
    //print("List contains : "); bvh.l.disp();  
  }
  
  Intersection traceRay(Ray r) {
    /*Get intersections with all objects*/
    for(int i = 0 ; i < objList.size() ; i++) {
      SceneObject o = objList.get(i); 
      if(o.ictm!=null && o.shape!='l' && o.shape!='b')  r.transform(o.ictm);// Transform ray
      Intersection isect = o.getIntersection(r);
      if(o.ictm!=null && o.shape!='l' && o.shape!='b')  r.restore();// Transform ray
      if (isect != null) {
        //println("Intersection at t = " + isect.t);
        r.isectList.add(isect);
      }
    }
    /*Select the closest intersection*/
    if(r.isectList.size() == 0)
      return null;
    Intersection visible_isect = r.isectList.get(0);
    for(int i = 1 ; i < r.isectList.size() ; i++) {
      if(r.isectList.get(i).t < visible_isect.t)
        visible_isect = r.isectList.get(i);
    }
    return visible_isect;
  }
  
  PVector getSampledPoint(float x, float y) {
    float sx, sy;
    sx = x + random(-5, 5)/10.0;
    sy = y + random(-5, 5)/10.0;
    return(new PVector(sx, sy, 0));
  }
  
  PVector getSampledLensPoint() {
    float sx, sy;
    sx = lensr * random(-100, 100)/100.0;
    sy = lensr * random(-100, 100)/100.0;
    return(new PVector(sx, sy, 0));
  }

  PVector getCameraPoint(float x, float y, float z) {
    float k = tan(0.5 * fov);
    float xd, yd, zd;
    xd = (x - 0.5*w)*2*(k/w);
    yd = -1*(y - 0.5*h)*2*(k/h);
    zd = (z - d);
    return (new PVector(xd, yd, zd));
  }
  
  PVector getScreenPoint(float xd, float yd, float zd) {
    float k = tan(0.5 * fov);
    float x, y, z;
    x = (0.5 * w) * ((xd/k) + 1);
    y = -1 * (0.5 * h) * ((yd/k) + 1);
    z = zd + d;
    return (new PVector(x, y, z));
  }

  void drawPixel(Ray r, Intersection visible_isect) {
    PVector cameraPoint = r.getPointAt(visible_isect.t);
    PVector screenPoint = getScreenPoint(cameraPoint.x, cameraPoint.y, cameraPoint.z);
    stroke(1,1,1);
    point(screenPoint.x, screenPoint.y, screenPoint.z);
    noStroke();
  }
  
  color processIntersect(Intersection isect, Ray r, int x, int y) {
    SceneObject obj = isect.ObjOfIsection;
    if(obj.ictm!=null)  r.transform(obj.ictm);
    PVector pt = r.getPointAt(isect.t);
    PVector nl = new PVector();
    nl.set(obj.getNormal(pt));
    nl.normalize();
    if(obj.shape == 'p')
    {
      if(r.direction.dot(nl)>0)
      {
        nl.set(-nl.x,-nl.y,-nl.z);
        //obj.invertNormal();
        //println("inverting normal as n = "+nl);
      }
    }
    if(obj.ictm!=null)  r.restore();
    color surface_color = obj.ambient;
    //println(lsList.size());
    for(int i = 0 ; i < lsList.size() ; i++) {
      LightSource l = lsList.get(i);
      if(l.shape == 'd')  ((DiskLightSource)l).updatePosition();
      PVector pl = PVector.sub(l.position, pt);
      pl.normalize();
      if(mutually_visible(pt, l.position, obj)) {
        //println("Surface visible");
        PVector col = new PVector(red(l.lightColor),green(l.lightColor),blue(l.lightColor));
        col.x *= red(obj.diffuse);
        col.y *= green(obj.diffuse);
        col.z *= blue(obj.diffuse);
        col.mult(max(nl.dot(pl),0));
        surface_color += color(min(col.x,255),min(col.y,255),min(col.z,255));
        //surface_color += l.lightColor * obj.diffuse * max(normal.dot(pl), 0);
      }
      if(l.shape == 'd')  ((DiskLightSource)l).restorePosition();
    }
    //println(surface_color);
/*    stroke(surface_color);
    point(x, y, 0);
    noStroke();*/
    return surface_color;
  }
  
  boolean mutually_visible(PVector pt, PVector lightPos, SceneObject obj) {
    Ray r = new Ray(lightPos, pt);
    Intersection isect = traceRay(r);
    if((isect==null) || (isect.ObjOfIsection==obj)) return true;
    return false;
  }
  
  void AddLens(float radius, float focal_distance) {
    lensr = radius;
    lensfd = focal_distance;
  }
  
  PVector getFocalPoint(PVector cp) {
    Ray auxray = new Ray(cp.x, cp.y, cp.z);
    float t = -lensfd/auxray.direction.z;
    PVector fp = auxray.getPointAt(t);
    return fp;
  }
  
  void simulate() {
    color sc, c;
    PVector cv = new PVector(0, 0, 0);
    int x, y, z = 0;
    PVector sp, cp;
    Ray r;
    for(x = 0; x < w; x++) {
      for(y = 0; y < h; y++) {
        cv.set(0, 0, 0);
        for(int jj=0; jj<rpp; jj++) {
          updateMovingSphere();
          if (lensr == 0) {
            sp = getSampledPoint(x, y);
            cp = getCameraPoint(sp.x, sp.y, z);
            r = new Ray(cp.x, cp.y, cp.z);
          }
          else {
            cp = getCameraPoint(x, y, z);          
            PVector fp = getFocalPoint(cp);
            //fp.set(-fp.x, -fp.y, -fp.z);
            sp = getSampledLensPoint();
            //sp = new PVector(0, 0, 0);
            r = new Ray(sp, fp);
          }
          Intersection visible_isect = traceRay(r);
          /*Process intersection*/
          if(visible_isect != null) {
            c = processIntersect(visible_isect, r, x, y);
            /*stroke(sc);
            point(x, y, 0);
            noStroke();*/
          }
          else{
            c = bg;
            /*stroke(bg);
            point(x, y, 0);
            noStroke();*/        
          }
          cv.x += red(c);  cv.y += green(c);  cv.z += blue(c);
          restoreMovingSphere();
        }
        cv.x = cv.x/rpp;  cv.y = cv.y/rpp;  cv.z = cv.z/rpp;
        sc = color(min(cv.x, 255), min(cv.y, 255), min(cv.z, 255));
        stroke(sc);
        point(x, y, 0);
        noStroke();
      }
    }
  }
  
  void updateMovingSphere() {
    for(int i = 0 ; i < objList.size() ; i++) {
      SceneObject o = objList.get(i);
      if(o.shape == 'm'){
        ((Moving_Sphere)o).updatePosition();
      }
    }
  }
  
  void restoreMovingSphere() {
    for(int i = 0 ; i < objList.size() ; i++) {
      SceneObject o = objList.get(i);
      if(o.shape == 'm'){
        ((Moving_Sphere)o).restorePosition();
      }
    }
  }
  
}
