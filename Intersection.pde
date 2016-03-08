class Intersection {
  float t; /*tvalue*/
  float texit; /*for box*/
  SceneObject ObjOfIsection;/*pointer to the object*/
  /*surface normal at the intersection*/
  Intersection () {
    t = -1;
    ObjOfIsection = null;
  }
  Intersection (float _t, SceneObject o) {
    t = _t;
    ObjOfIsection = o;
  }
}

